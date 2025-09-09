# Lesson 7 — EKS + ECR + Helm (Django)

## Інфраструктура
- **Terraform** створює:
    - S3 + DynamoDB для бекенду стану
    - VPC (3 public + 3 private підмережі)
    - ECR репозиторій
    - EKS кластер + NodeGroup

## Кроки виконання
1. Bootstrap бекенду:
   ```bash
   cd lesson-7/bootstrap
   terraform init
   terraform apply -auto-approve

    cd ..
    terraform init -migrate-state
    terraform apply -auto-approve

    ECR_URL=$(terraform output -raw ecr_repository_url)
       docker build -t django-app:latest ../app
       docker tag django-app:latest $ECR_URL:v1
       docker push $ECR_URL:v1
    
    aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region us-west-2
    
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    
    helm upgrade --install django-app ./charts/django-app \
    --namespace django --create-namespace \
    --set image.repository=$(terraform output -raw ecr_repository_url) \
    --set image.tag=v1
    
    kubectl -n django get deploy,svc,hpa,pods


