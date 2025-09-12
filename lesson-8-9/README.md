## Lesson 8-9 — CI/CD Bootstrap: Terraform + Jenkins + Argo CD (AWS)

### Terraform
- VPC
- ECR репозиторій
- EKS кластер + NodeGroup
- Jenkins (через Helm)
- Argo CD (через Helm) + Application для `charts/django-app`

### Quick start
1) AWS профіль:
```bash
export AWS_PROFILE=dev
export AWS_REGION=us-west-2
aws sts get-caller-identity
```

2) Bootstrap (S3+DynamoDB)
```bash
cd lesson-8-9/bootstrap
terraform init
terraform apply -auto-approve

cd ..
```

3) Set remote backend
- `lesson-8-9/backend.tf` set `bucket`, `key`, `region`, `dynamodb_table` .

4) Infra
- `lesson-8-9/terraform.tfvars` set:
```hcl
region        = "us-west-2"
cluster_name  = "lesson-8-9-eks"
vpc_cidr      = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24"]
private_subnets = []
azs            = ["us-west-2a"]
ecr_repo_name  = "lesson-8-9-ecr"

# Argo CD 
apps_repo_url  = "git@github.com:Fijji/friendly-bash.git"
apps_repo_rev  = "main"
apps_repo_path = "lesson-8-9/charts/django-app"
app_namespace  = "default"
app_name       = "django-app"
```

5) Ініціалізація
```bash
cd lesson-8-9
terraform init -migrate-state
terraform apply
```

6) kubeconfig для доступу до кластера
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $AWS_REGION
```

7) Jenkins pipeline
- Jenkins (`kubectl -n ci get svc,po`).
- Set pipeline and use `app/Jenkinsfile`.
- Set creds:
  - `aws-ci-user` — AWS access key для ECR.
  - `helm-repo-deploy-key` — SSH ключ.

8) pipeline:
- Збирає Docker образ Kaniko в Kubernetes, пушить у ECR.
- Оновлює `values.yaml` у `lesson-8-9/charts/django-app` з новим тегом образу.
- Пушить зміни в Git. Argo CD підхоплює й застосовує в EKS.

9) Перевірка
```bash
kubectl -n default get deploy,svc,hpa,pods
```