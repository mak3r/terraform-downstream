# terraform-rancher
Create downstream clusters for import/registration using Terraform

## Dependencies

* terraform
* helm
* jq
* kubectl
* aws
* URL for Rancher instance

## Quick Start

### Prep
* `cp terraform-setup/terraform.tfvars.template terraform-setup/terraform.tfvars`
    * Adjust the tfvars variables as desired
* Set your aws account id and key using the terraform variables
    * `aws_access_key_id`
    * `aws_secret_access_key`
* See `variables.tf` for other infrastructure configuration 

1. `make DOWNSTREAM_COUNT=3 infrastructure` # create 3 downstream instances

## Make targets

* `infrastructure` - build the infrastructure needed to host k3s clusters
* `k3s_install` -  
    * Single node clusters only
    * Not HA
* `destroy` - destroy the infrastructure 
* `install_kubeconfig` - run after `k3s_install` target. **WARNING** THIS WILL OVERWRITE YOUR LOCAL `.kube/config`
* `backup_kubeconfig` - backup your local `.kube/config` before overwriting it with `install_kubeconfig`
