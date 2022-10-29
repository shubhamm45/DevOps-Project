DOCKER_IMAGE="044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:latest"

aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin "044967670847.dkr.ecr.ap-south-1.amazonaws.com"

docker build -t nginx-application .

docker tag nginx-application:latest 044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:latest

docker push 044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:latest

sed -i "s/devops_image/$DOCKER_IMAGE/g" nginx_deployment.yaml

aws eks update-kubeconfig --name mycluster --region ap-south-1 --profile euran_devops_project

kubectl apply -f nginx_deployment.yaml

