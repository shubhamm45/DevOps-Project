variable "region" {
    default = "ap-south-1"
}



variable "vpc_id" {
    default = "vpc-0771b69fc0dcf2e11"
}   

variable "cluster_name" {
    default = "mycluster"
}

variable "node_group_name" {
    default = "mynode"
}

variable "node_instance_type" {
    default = "t2.micro"
}
