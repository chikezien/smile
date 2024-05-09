# Instructions to execute the Terraform code and deploy the infrastructure on AWS.

### STEP 1 - Set Up AWS Credentials:
Ensure you have AWS credentials configured on your system with sufficient permissions to create and manage resources. You can set up AWS credentials using environment variables, AWS CLI profiles, or IAM roles. Refer to the AWS documentation for instructions on configuring AWS credentials.

### STEP 2 -Initialize Terraform:
Navigate to the directory containing your Terraform configuration files (main.tf, variables.tf, etc.). Run the following command to initialize Terraform and download the required providers:

`terraform init`

### STEP 3 - Review and Adjust Variables:
Review the variables defined in the variables.tf file and adjust them if needed to match your requirements. You can either modify the default values directly in the variables.tf file or override them using Terraform -var flag during execution.

### STEP 4 - Plan Infrastructure Changes:
Run the following command to create an execution plan, which shows what Terraform will do when you apply the configuration:

`terraform plan`

Review the plan to ensure it matches your expectations. Terraform will display a summary of the resources it will create, modify, or delete.

### STEP 5 - Apply Infrastructure Changes:
If the plan looks correct, apply the changes to create the infrastructure on AWS:

`terraform apply`

Terraform will prompt you to confirm the plan. Type yes and press Enter to proceed. Terraform will then create the specified resources on AWS.

### STEP 6 - Verify Deployment:
Once Terraform has finished applying the changes, verify that the infrastructure has been deployed as expected. You can check the AWS Management Console, AWS CLI, or other tools to inspect the created resources.
