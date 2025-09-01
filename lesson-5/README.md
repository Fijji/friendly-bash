# lesson-5 — Terraform AWS (S3+DynamoDB backend, VPC, ECR)

## Структура
├── main.tf # підключення модулів
├── backend.tf # конфіг Terraform backend (S3 + DynamoDB)
├── providers.tf # провайдер AWS
├── variables.tf # змінні root модуля
├── outputs.tf # загальні вихідні дані
├── modules/ # каталог з модулями
│ ├── s3-backend/ # S3 bucket + DynamoDB для зберігання state
│ ├── vpc/ # VPC з публічними/приватними сабнетами
│ └── ecr/ # ECR репозиторій
└── README.md # документація проєкту

## Попередні вимоги
- Terraform ≥ 1.5
- AWS creds 

## Bootstrapping 
1. **Тимчасово вимкніть** `backend.tf` (закоментуйте блок).
2. Ініціалізація:
   terraform init          # ініціалізація
   terraform plan          # перегляд плану змін
   terraform apply         # створення/оновлення ресурсів
   terraform destroy       # видалення ресурсів

Пояснення модулів
🔹 s3-backend
Створює S3 bucket для зберігання Terraform state.
Включає версіонування і шифрування.
Створює DynamoDB table для блокування state (щоб уникати конфліктів при одночасних змінах).

🔹 vpc
Створює VPC з CIDR 10.0.0.0/16.
Піднімає 3 публічні та 3 приватні підмережі в різних AZ.
Додає Internet Gateway для публічних підмереж.
Створює NAT Gateway у першій публічній підмережі для виходу приватних ресурсів у інтернет.
Налаштовує Route Tables і їх асоціації.

🔹 ecr
Створює Elastic Container Registry для зберігання Docker-образів.
Вмикає image scanning on push.
Прописує політику доступу для root користувача облікового запису.
Виводить повний repository_url, щоб пушити образи.