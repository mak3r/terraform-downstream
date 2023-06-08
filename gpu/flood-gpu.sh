#!/bin/sh

MAX=$1

for i in {1..30}; do
	cat gpu/vector-add-job.yaml | sed "s/\([[:space:]]\{2\}name:[[:space:]]\{1\}vectoradd-job\)/\1\.$i/g" | kubectl --kubeconfig ./kubeconfig-gpu apply -f -
done

#USE AMI ami-0b7e0d9b36f4e8f14