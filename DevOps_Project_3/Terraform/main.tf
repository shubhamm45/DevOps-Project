data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

data "aws_subnet_ids" "subnet_id" {
  vpc_id = var.vpc_id

  tags = {
    Name = "pub*"
  }
}


output "ids" {
    value = data.aws_subnet_ids.subnet_id.ids
}



resource "aws_security_group" "EKS_SG" {
  name        = "${var.cluster_name}-sg"
  description = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id
  

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = [local.workstation-external-cidr]
    
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}


resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-eks-cluster-cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "myeks" {
    name = var.cluster_name
    role_arn = aws_iam_role.cluster_role.arn

    vpc_config {
        
        subnet_ids = data.aws_subnet_ids.subnet_id.ids
        endpoint_private_access = true
        endpoint_public_access = false
        security_group_ids = [aws_security_group.EKS_SG.id]
    
    }

}

#

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-terraform-eks-eks_node_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}



resource "aws_eks_node_group" "mynode_node" {
    cluster_name = aws_eks_cluster.myeks.name
    node_group_name = "${var.cluster_name}-node"
    node_role_arn = aws_iam_role.eks_node_role.arn
    subnet_ids = data.aws_subnet_ids.subnet_id.ids

    scaling_config {
        desired_size = 1
        max_size = 1
        min_size = 1
    }

    instance_types = [var.node_instance_type]
}
