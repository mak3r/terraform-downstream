#!/bin/bash

TF_STATE="terraform-setup/terraform.tfstate"
DIP=($(terraform output -state=$TF_STATE -json downstream_ips | jq -r '.[]'))
TOKEN=($(terraform output -state=$TF_STATE -json rancher_access_token | jq -r '.'))
VCLUSTER_PER_CLUSTER=$1

function install-downstreams {
	echo $0
	echo $@
	DOWNIP=$1
	START=$(( ($2 * $VCLUSTER_PER_CLUSTER) + 1 ))
	END=$(( ($2+1) * $VCLUSTER_PER_CLUSTER ))
	ACCESS_TOKEN=$3

	ssh -o StrictHostKeychecking=no ec2-user@$DOWNIP "sudo zypper -n in jq git make"	
	ssh ec2-user@$DOWNIP "git clone https://github.com/mak3r/terraform-downstream.git"
	ssh ec2-user@$DOWNIP "cd terraform-downstream && bin/install-k3s.sh"
	ssh ec2-user@$DOWNIP "cd terraform-downstream && bin/install-helm.sh"
	ssh ec2-user@$DOWNIP "cd terraform-downstream && bin/install-vcluster.sh"
	ssh ec2-user@$DOWNIP "cd terraform-downstream && make install_scripts"

	# Start a screen and build the clusters in the background
	scp bin/build-cluster-group.sh ec2-user@$DOWNIP:~/. 
	ssh ec2-user@$DOWNIP screen -dmS vc ./build-cluster-group.sh $END $START $ACCESS_TOKEN
}

for i in "${!DIP[@]}"
do 
	install-downstreams "${DIP[$i]}" $i $TOKEN &
done

