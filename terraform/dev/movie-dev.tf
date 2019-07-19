# TF config for Development Environment

module "dynamodb" {
    source = "../modules/dynamodb"
    dyn-db-accounts-name = "mv-dev-accounts"
    dyn-db-accounts-proj-tag = "WIP"
    dyn-db-accounts-env-tag = "Development"
}

module "S3" {
    source = "../modules/S3"
    upload-bucket-name = "mv-dev-uploads"
    upload-bucket-proj-tag = "WIP"
    upload-bucket-env-tag = "Development"
    upload-bucket-transition-days = 5
    upload-bucket-expire-days = 30
}

module "lambda" {
    source = "../modules/lambda"
    lambda-sign-up-name = "lambda-wip-dev-signup"
    lambda-check-auth-name = "lambda-wip-dev-auth"
    tag-env = "Development"
    tag-project = "WIP"
}
