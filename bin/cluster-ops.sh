#!/bin/bash

TF_STATE="terraform-setup/terraform.tfstate"
DIP=($(terraform output -state=$TF_STATE -json downstream_ips | jq -r '.[]'))
RANCHER_HOST=($(terraform output -state=$TF_STATE -json rancher_url | jq -r '.'))
ACCESS_TOKEN=($(terraform output -state=$TF_STATE -json rancher_access_token | jq -r '.'))

# takes argument of cluster name within rancher
function create-cluster() 
{
  CLUSTER_NAME=$1
  CLUSTER_NS='fleet-default'

  read -r -d '' CLUSTER_CONFIG <<-EOF
	{
	"metadata": {
		"name": "$CLUSTER_NAME",
		"namespace": "$CLUSTER_NS"
	},
	"spec": null,
	"status": null
	}
	EOF

  # Create the cluster
  curl -s -k -u "$ACCESS_TOKEN" -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -d "$CLUSTER_CONFIG" https://$RANCHER_HOST/v1/provisioning.cattle.io.clusters >/dev/null; 
  # Wait for object to init
  sleep 2;

  # Get cluster id
  CLUSTER_ID=$(curl -s -k -u "$ACCESS_TOKEN" https://$RANCHER_HOST/v1/provisioning.cattle.io.clusters/fleet-default/$CLUSTER_NAME | jq -r '.status.clusterName');

  # Get registration commands
  curl -s -k -u "$ACCESS_TOKEN" https://$RANCHER_HOST/v3/clusterregistrationtokens?clusterId=$CLUSTER_ID | jq -r '.data[].insecureCommand' | cut -d'|' -f 1;
}

# takes arguement of cluster name within rancher
function get_cluster_status ()
{
  CLUSTER_NAME=$1;
  CLUSTER_NS='fleet-default';
  curl -sk -u $ACCESS_TOKEN https://$RANCHER_HOST/v1/provisioning.cattle.io.clusters/$CLUSTER_NS/$CLUSTER_NAME | jq '.metadata.state';
}

function delete_cluster() 
{
	curl -s -k -X DELETE -u "$ACCESS_TOKEN" https://$RANCHER_HOST/v1/provisioning.cattle.io.clusters/fleet-default/$cluster_name 

}
