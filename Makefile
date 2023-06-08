SHELL := /bin/bash
K3S_TOKEN="mak3rVA87qPxet2SB8BDuLPWfU2xnPUSoETYF"
ADMIN_SECRET="6DfOqQMzaNFTg6VV"
K3S_CHANNEL=v1.24
K3S_UPGRADE_CHANNEL=v1.25
RANCHER_HOST="demo.mak3r.design"
export KUBECONFIG=kubeconfig
BACKUP_NAME=kubeconfig.tf_downstream
API_TOKEN="abcdef:EXAMPLEtokenGoesHere"
DOWNSTREAM_COUNT=0
CIP=""

.PHONY: destroy
destroy:
	-rm kubeconfig*
	cd terraform-setup && terraform destroy -auto-approve && rm terraform.tfstate terraform.tfstate.backup

.PHONY: infrastructure
infrastructure:
	echo "Creating infrastructure"
	cd terraform-setup && terraform init && terraform apply -auto-approve \
	-var downstream_count=$(DOWNSTREAM_COUNT) \
	-var rancher_access_token=$(API_TOKEN)

.PHONY: k3s_install
k3s_install:
	echo "Creating k3s cluster"
	ssh -o StrictHostKeyChecking=no ec2-user@$(CIP) '/bin/bash -s' -- < bin/install-k3s.sh "$(K3S_CHANNEL)" "$(CIP)"
	scp -o StrictHostKeyChecking=no ec2-user@$(CIP):/etc/rancher/k3s/k3s.yaml kubeconfig-$(CIP)
	sed -i '' "s/127.0.0.1/$(CIP)/g" kubeconfig-$(CIP)

.PHONY: backup_kubeconfig
backup_kubeconfig:
	cp ~/.kube/config ~/.kube/$(BACKUP_NAME)

.PHONY: install_kubeconfig
install_kubeconfig:
	cp ./kubeconfig ~/.kube/config

.PHONY: restore_kubeconfig
restore_kubeconfig:
	cp ~/.kube/$(BACKUP_NAME) ~/.kube/config

.PHONY: info
info:
	cd terraform-setup && terraform output

install_scripts:
	sudo cp ./bin/*.sh /usr/local/bin

install_vclusters:
	# Do this for every downstream host
	# Argument is the number of downstream virtual clusters to setup on every host.
	bin/setup-vclusters.sh 20