# Terraform examples

Cache plugins:
1. Create `%APPDATA%/terraform.rc`
1. Add line: `plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"`

Resource graph:
1. Install Graphviz software
1. Execute: `terraform graph | dot -Tsvg > graph.svg`
1. Apply some filters: `terraform graph | grep -v meta.count-boundary | grep -v "\[root\] var\." | dot -Tsvg > image.svg`

Apply external varaibles:

`terraform apply --var-file=variables.tfvars`

Apply backup:

`terraform apply --backup=main.tfstate.backup`
