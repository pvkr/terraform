
## Agenda
* What is terraform
* Commands
* Variables
* Loops
* Modules
* State
* Workspace
* Examples

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
