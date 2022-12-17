variable "region" {
    default = "ap-south-1"
}



variable "vpc_id" {
    default = "vpc-0f82fd20be060b915"
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
