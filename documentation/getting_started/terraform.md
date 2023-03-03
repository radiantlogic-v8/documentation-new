---
title: Terraform
description: Terraform
---

# **FID on EKS using Terraform**


## **EKS**

**Amazon Elastic Kubernetes service** is a managed Kubernetes service provided by AWS. EKS is a certified Kubernetes Conformant, so existing applications that run in Kubernetes are compatible with EKS. Amazon EKS automatically manages the availability and scalability of the Kubernetes control plane nodes and also provides advantages like performance, scaling, reliability and, availability
Integration with other AWS services like networking, security, IAM and, VPC is also supported making EKS suitable for cloud applications and services.

Learn more about EKS [here](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)


## **Terraform**

Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.
Terraform must be installed, refer to [documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli) for more details.

## **Prerequisites**

1. Terraform (terraform CLI)
2. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured
3. Machine with [kubectl](https://kubernetes.io/docs/tasks/tools/) installed
4. Valid FID License (if you do not have a valid license please contact support@radiantlogic.com)
5. [Helm](https://helm.sh/docs/intro/install/) installed (optional)


## **Deployment**

Terraform connects to AWS using the configuration details provided (either through a tfvars file or configured in the cli where terraform commands will be run) to deploy the necessary resources in a highly configurable manner 

### **Components that will be created and deployed**

1. VPC
2. Subnets
3. Security Groups
4. Worker Nodes
5. NAT Gateway
6. EKS Cluster
7. Kubernetes
8. FID using Helm Charts


### NOTE: Navigate to the location where you have either cloned or downloaded the terraform files.


### **Terraform INIT**

The [terraform init](https://www.terraform.io/cli/commands/init) command is used to initialize a working directory containing Terraform configuration files.
This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.
It is safe to run this command multiple times.


Initialize terraform
```
terraform init [options]
```

### **Terraform VALIDATE**

The [terraform validate](https://www.terraform.io/cli/commands/validate) command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.


Validate the terraform configuration and existing file
```
terraform validate [options]
```

### **Terraform PLAN**

The terraform plan command creates an execution plan. By default, creating a plan consists of:

- Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
- Comparing the current configuration to the prior state and noting any differences.
- Proposing a set of change actions that should, if applied, make the remote objects match the configuration.


Create the execution file
```
terraform plan [options]
```

### **Terraform APPLY**

The [terraform apply](https://www.terraform.io/docs/cli/commands/apply.html) command executes the actions proposed in a Terraform plan.

The most straightforward way to use terraform apply is to run it without any arguments at all, in which case it will automatically create a new execution plan (as if you had run terraform plan) and then prompt you to approve that plan, before taking the indicated actions.

Another way to use terraform apply is to pass it the filename of a saved plan file you created earlier with terraform plan -out=..., in which case Terraform will apply the changes in the plan without any confirmation prompt. This two-step workflow is primarily intended for when running Terraform in automation


Apply the execution (plan file) file created
```
terraform apply [options] [plan file]
```

### **Terraform DESTROY**

The [terraform destroy](https://www.terraform.io/docs/cli/commands/destroy.html) command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

While you will typically not want to destroy long-lived objects in a production environment, Terraform is sometimes used to manage ephemeral infrastructure for development purposes, in which case you can use terraform destroy to conveniently clean up all of those temporary objects once you are finished with your work.

```
terraform destroy [options]
```



## **REQUIREMENTS**

| Name | Version |
| - | - |
| terraform | >=0.13.1 |
| aws | >=3.63 |



## **PROVIDERS**

| Name | Version |
| - | - |
| aws | >=3.63 |
| helm |   |


## **INPUTS**

| Name | Description |
| - | - |
| region | AWS region |
| namespace | Name of the namespace that will be created in kubernetes environment |
| cluster_name | Name of the EKS cluster. Also used as a prefix in names of related resources |
| cluster_version | Kubernetes version to use for the EKS cluster |
| workers_group_defaults | Override default values for target groups. See workers_group_defaults_defaults in local.tf for valid keys |
| subnets | A list of subnets to place the EKS cluster and workers within |
| worker_groups | A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys |
| instance_type | The type of instance to start
| create_spot_instance | Depicts if the instance is a spot instance
| create_vpc | Controls if VPC should be created (it affects almost all resources)
| vpc_name | Name to be used on all the resources as identifier
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
| public_subnets | A list of public subnets inside the VPC
| private_subnets | A list of private subnets inside the VPC
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks
| single_nat_gatewa| Should be true if you want to provision a single shared NAT Gateway across all of your private networks
| enable_dns_support|  Should be true to enable DNS hostnames in the VPC
| one_nat_gateway_per_az| Should be true to enable only one NAT gateway per availability zone
| public_subnet_tags| Additional tags for the public subnets
| private_subnet_tags| Additional tags for the private subnets
| application_name| Name of the application
| application_name2|





## **OUTPUTS**


| Name | Description |
| - | - |
| region | AWS region |
| cluster_id|EKS cluster ID
|cluster_endpoint|Endpoint for EKS control plane
|cluster_security_group_id|Security group ids attached to the cluster control plane
|kubectl_config|kubectl config as generated by the module
|config_map_aws_auth|A kubernetes configuration to authenticate to this EKS cluster.
|cluster_name|Kubernetes Cluster Name
|vpc_resource_level_tags| tags
|vpc_all_tags| tags




 






