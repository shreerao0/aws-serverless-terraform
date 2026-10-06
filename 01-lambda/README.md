# Deploy a Python AWS Lambda with Terraform

This example packages `lambda_function.py`, creates a Lambda execution role with
CloudWatch Logs permissions, deploys the function, and invokes it from the AWS
CLI. The Terraform configuration defaults to `us-east-1`; change the region
before deployment if needed.

## Prerequisites

- An AWS account and AWS CLI credentials configured for the account
- Terraform 1.5 or later
- AWS CLI v2
- IAM permissions to create Lambda functions, IAM roles and policies, and
  CloudWatch log groups/streams

Do not put AWS access keys in this directory or commit them to Git. Use an
existing AWS CLI profile, environment-based credentials, or an approved
credential provider.

## Step-by-step

1. Open a terminal in this directory:

   ```sh
   cd projects/terraform/AWS/Lambda
   ```

2. Confirm the AWS identity and select the profile you intend to use:

   ```sh
   aws sts get-caller-identity
   export AWS_PROFILE=your-profile
   ```

   Omit `AWS_PROFILE` if the AWS CLI's default credential chain is already
   configured. Terraform uses the same AWS credential chain.

3. (Optional) Set a different AWS region or Lambda function name by creating
   `terraform.tfvars`:

   ```hcl
   aws_region   = "us-west-2"
   function_name = "terraform-hello-lambda"
   ```

   The default region is `us-east-1`; the default function name is
   `terraform-hello-lambda`.

4. Initialize Terraform and check the configuration:

   ```sh
   terraform init
   terraform fmt -check
   terraform validate
   ```

5. Review the resources Terraform will create:

   ```sh
   terraform plan -out=tfplan
   ```

6. Deploy the Lambda and its execution role:

   ```sh
   terraform apply tfplan
   ```

   The apply output includes the function name and ARN. The function uses
   Python 3.12 and logs to CloudWatch Logs when invoked.

7. Invoke the deployed function with a JSON event:

   ```sh
   aws lambda invoke \
     --function-name "$(terraform output -raw function_name)" \
     --cli-binary-format raw-in-base64-out \
     --payload '{"name":"Terraform"}' \
     response.json
   cat response.json
   ```

   The response body contains `Hello, Terraform!`. If `name` is omitted, it
   contains `Hello, world!`.

8. Review recent execution logs:

   ```sh
   aws logs tail \
     "/aws/lambda/$(terraform output -raw function_name)" \
     --since 10m
   ```

9. When finished learning, remove the resources to avoid ongoing charges:

   ```sh
   terraform destroy
   ```

   Review the destroy plan and confirm when prompted. The Terraform state file
   and generated plan can contain infrastructure metadata; keep them private.

## Files

- `lambda_function.py` — Lambda handler
- `main.tf` — IAM role, basic logging policy, and Lambda function
- `variables.tf` — configurable region and function name
- `outputs.tf` — deployed function name and ARN
- `versions.tf` — Terraform and provider requirements

