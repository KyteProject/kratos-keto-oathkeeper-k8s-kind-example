#!/bin/bash

# Check for local version of kubectl
KUBECTL_CLIENT="kubectl"
if [ -e "./kubectl" ]; then
  KUBECTL_CLIENT="./kubectl"
fi
# Check for local version of kustomize
KUSTOMIZE_CLIENT="kustomize"
if [ -e "./kustomize" ]; then
  KUSTOMIZE_CLIENT="./kustomize"
fi

deployments=$($KUBECTL_CLIENT get deployments.apps -o jsonpath='{.items[*].metadata.name}' | tr " " "\n")
for deployment in $deployments
do
  if [[ ${deployment} == *"keto"* ]]; then
    echo "# $($KUBECTL_CLIENT rollout status deployment $deployment)"
    if [ -f "deployment/k8s/keto/keto-job/kustomization.yaml" ]; then
      $KUSTOMIZE_CLIENT build deployment/k8s/keto/keto-job/
    else
      echo "No file in deployment/k8s/keto/keto-job/kustomization.yaml"
    fi
  fi
done