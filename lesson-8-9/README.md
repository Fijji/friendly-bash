## Lesson 8-9 — CI/CD Bootstrap: Terraform + Jenkins + Argo CD (AWS)

### Що створює Terraform
- VPC (мінімально необхідне для демо)
- ECR репозиторій
- EKS кластер + NodeGroup
- Jenkins (через Helm)
- Argo CD (через Helm) + Application для `charts/django-app`

### Quick start
1) Підготуй AWS профіль
```bash
export AWS_PROFILE=dev
export AWS_REGION=us-west-2
aws sts get-caller-identity
```

2) Bootstrap бекенду стану (S3+DynamoDB)
```bash
cd lesson-8-9/bootstrap
terraform init
terraform apply -auto-approve

# Запам'ятай значення bucket/table з виводів
cd ..
```

3) Вкажи remote backend
- Відкрий `lesson-8-9/backend.tf` та вистави власні `bucket`, `key`, `region`, `dynamodb_table` відповідно до створених ресурсів.

4) Заповни змінні інфраструктури
- Відкрий `lesson-8-9/terraform.tfvars` і вкажи значення, наприклад:
```hcl
region        = "us-west-2"
cluster_name  = "lesson-8-9-eks"
vpc_cidr      = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24"]
private_subnets = []
azs            = ["us-west-2a"]
ecr_repo_name  = "lesson-8-9-ecr"

# Argo CD застосування чартів з цього ж репозиторію
apps_repo_url  = "git@github.com:Fijji/friendly-bash.git"
apps_repo_rev  = "main"
apps_repo_path = "lesson-8-9/charts/django-app"
app_namespace  = "default"
app_name       = "django-app"
```

5) Ініціалізація та створення інфри
```bash
cd lesson-8-9
terraform init -migrate-state
terraform apply
```

6) kubeconfig для доступу до кластера (локально)
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $AWS_REGION
```

7) Jenkins pipeline
- Зайди в Jenkins (URL/пароль — у виводах модуля Jenkins або в `kubectl -n ci get svc,po`).
- Створи pipeline і використай `app/Jenkinsfile` з кореня репозиторію.
- Створи креденшли:
  - `aws-ci-user` — AWS access key для ECR (ID у Jenkins повинен збігатися).
  - `helm-repo-deploy-key` — SSH ключ з доступом для пушу в Git репозиторій.
- Переконайся, що в Jenkins існує агент/label `kaniko` (Kubernetes pod з Kaniko).
- За потреби відкоригуй у `app/Jenkinsfile` значення `ACCOUNT_ID`, `AWS_REGION`, `ECR_REPO_NAME`, `CHART_REPO_URL`, `CHART_BRANCH`, `CHART_PATH`.

8) Як працює pipeline
- Збирає Docker образ Kaniko в Kubernetes, пушить у ECR.
- Оновлює `values.yaml` у `lesson-8-9/charts/django-app` з новим тегом образу.
- Пушить зміни в Git. Argo CD підхоплює й застосовує в EKS.

9) Перевірка розгортання
```bash
kubectl -n default get deploy,svc,hpa,pods
```

10) Вартість
- Для демо достатньо 1 public subnet без NAT. Після перевірки видаляй кластер, щоб уникнути витрат.


