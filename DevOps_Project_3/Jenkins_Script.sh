#!/bin/bash
set -ex


export TF_VAR_region=$REGION
export TF_VAR_vpc_id=$VPC_ID
export TF_VAR_cluster_name=$CLUSTER_NAME

#goint to the terraform path
cd ${WORKSPACE}/DevOps_Project_3/Terraform

#replacing the cluster name field in backend.tf file
sed -i "s/cluster_name/my-cluster/g" backend.tf

#running terraform command
terraform init    
terraform plan
terraform $ACTION --auto-approve

if [ $ACTION == "apply" ]; then
#login into the eks cluster
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
kubectl get pods -A

#installing bitnami helm chart
helm repo add bitnami https://charts.bitnami.com/bitnami

#installing nginx
helm install nginx bitnami/nginx

#installing grafana
helm install grafana bitnami/grafana

else
echo "no need to install"
fi
