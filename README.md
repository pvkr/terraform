# Terraform examples

## Setup provider (Step 0)

1. `cd step0_provider`
1. `terraform init`

Cache plugins:
1. Create `%APPDATA%/terraform.rc`
1. Add line: `plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"`

## Terraform commands (Step 1)
1. `terraform plan`
1. `terraform apply`
1. `terraform plan -destroy`
1. `terraform destroy`
1. `terraform apply --backup=terraform.tfstate.backup `
1. `terrafrom graph`
1. `terraform graph | dot -Tsvg > graph.svg` (dot util is part of Graphviz software)

## Vairables (Step 2)
