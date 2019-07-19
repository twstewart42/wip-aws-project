variable "upload-bucket-name" {
    type = string
    description = "The name of the S3 bucket name for uploads"
}
variable "upload-bucket-env-tag" {
    type = string
    description = "The environment tag of the S3 bucket name for uploads"
}

variable "upload-bucket-proj-tag" {
    type = string
    description = "The Project tag of the S3 bucket name for uploads"
}

variable "upload-bucket-transition-days" {
    type = number
    description = "The time in days for a file to be moved to cheaper storage"
}


variable "upload-bucket-expire-days" {
    type = number
    description = "The time in days for a file to be deleted"
}


