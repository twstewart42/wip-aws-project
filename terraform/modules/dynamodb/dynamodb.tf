provider "aws" {
    profile = "default"
    region = "us-east-1"
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
    name = "${var.dyn-db-accounts-name}"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "email"
    range_key = "userId"
   
    attribute {
        name = "userId"
        type = "S"
    }

    attribute {
        name = "email"
        type = "S"
    }

    local_secondary_index {
        name = "userIdIndex"
        range_key = "userId"
        projection_type = "ALL"
    }

    server_side_encryption {
        enabled = "true"
    }

    tags = {
        Name = "${var.dyn-db-accounts-name}"
        Project = "${var.dyn-db-accounts-proj-tag}"
        Environment = "${var.dyn-db-accounts-env-tag}"
    }
}
