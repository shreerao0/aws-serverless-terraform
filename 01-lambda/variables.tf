variable "aws_region" {
  description = "AWS region in which to create the Lambda function."
  type        = string
  default     = "us-east-1"
}

variable "function_name" {
  description = "Name assigned to the Lambda function and execution role."
  type        = string
  default     = "terraform-hello-lambda"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,64}$", var.function_name))
    error_message = "function_name must contain 1-64 letters, numbers, hyphens, or underscores."
  }
}
