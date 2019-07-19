provider "aws" {
    region = "us-east-1"
    profile = "default"
}

resource "aws_s3_bucket" "wip-uploads" {
    bucket = "${var.upload-bucket-name}"
    acl = "private"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm  = "AES256"
            }
        }
    }

    versioning {
        enabled = true
    }

    lifecycle_rule {
        id = "expired"
        enabled = true
                
        transition {
            # 5 = 5 days
            days  = "${var.upload-bucket-transition-days}"
            storage_class = "GLACIER"
        }

        expiration {
            # 30 = 30 days
            days = "${var.upload-bucket-expire-days}"
        }

        tags = { 
            "Rule" = "expired"
            "autoclean" = "true"
        }
    }

    tags = { 
        Name = "${var.upload-bucket-name}"
        Project = "${var.upload-bucket-proj-tag}"
        Environment = "${var.upload-bucket-env-tag}"
    }

}
