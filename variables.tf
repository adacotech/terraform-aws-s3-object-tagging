variable "s3_bucket_name" {
  type        = string
  description = "target s3 bucket name"
  default     = null
}

variable "suffix" {
  type        = string
  description = "s3 object key suffix"
}

variable "prefix" {
  type        = string
  description = "s3 object key prefix"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the objects created"
}

variable "nameprefix" {
  type        = string
  description = "the common name prefix to aws resource name"
  default     = "aws-s3-object-tagging"
}
