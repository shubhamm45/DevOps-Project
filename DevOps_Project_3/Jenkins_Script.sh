#!/bin/bash
set -ex

export AWS_PROFILE="euran_devops_project"
export REGION="ap-south-1"
export TF_VAR_cluster_name=$CLUSTER_NAME

#goint to the terraform path
cd ${WORKSPACE}/DevOps_Project_3/Terraform

#replacing the cluster name field in backend.tf file
sed -i "s/cluster_name/my-cluster/g" backend.tf

#running terraform command
terraform init -migrate-state     
terraform plan
terraform $ACTION --auto-approve

#login into the eks cluster
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION --profile $AWS_PROFILE

#installing bitnami helm chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install nginx bitnami/nginx



