
## Agenda
* What is terraform
* Commands
* Resource dependencies
* Variables
* Loops
* Modules
* State
* Workspace
* Provision

## Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.

Features:
* Infrastructure as code (HCL/JSON)
* Cloud agnostic
* Manages infrastructure/not software
* Manage State
* Execution Plan
* Resource graph
* Free

## Resource dependencies

* Implicit
* Explicit

## Commands

* terraform plan
* terraform apply
* terraform destroy
* terraform plan -destroy
* terraform init
* terraform graph
* terraform validate

## Variables

1. tf code (variable "key" { type = "string"  default = "value" })

1. export TF_VAR_key=value

1. terraform apply -var key=value

1. tfvars files (key=value)

Supported types:
* string/number/bool
* list/set
* map/tuples/object

## Loops
Loop
```
resource "aws_subnet" "subnet" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_cidrs[count.index]}"
  availability_zone = "${var.azs[count.index]}"
}
```
Condition
```
resource "aws_s3_bucket" "s3" {
  count  = "${var.s3_enabled ? 1 : 0}"
  bucket = "pvkr-terraform-s3"
  acl    = "private"
}
```

## Modules
```
module "vpc" {
  # Local Folder
  source = "./vpc"
  # VC (git)
  # S3 (archive)

  input_var1 = value1
  ...
}
```
Module structure:
```
root/
├── main.tf
├── outputs.tf
├── variables.tf
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
```

Module structure (+env):
````
root/
├── main.tf
├── outputs.tf
├── variables.tf
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
```
