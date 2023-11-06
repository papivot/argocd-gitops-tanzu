#!/bin/bash

TKC_NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
kubectl get secret -n "${TKC_NAMESPACE}" "${TKC_NAME}"-kubeconfig -o json|jq -r ".data.value"|base64 -d > tkc-kubeconfig

#read the kubeconfig file
CA=$(yq -r '.clusters[0].cluster.certificate-authority-data' tkc-kubeconfig)
SERVER=$(yq -r '.clusters[0].cluster.server' tkc-kubeconfig)
CLIENT_CA=$(yq -r '.users[0].user.client-certificate-data' tkc-kubeconfig)
CLIENT_KEY=$(yq -r '.users[0].user.client-key-data' tkc-kubeconfig)

# Export variabls for substution
export NAMESPACE=${TKC_NAMESPACE}
export CLUSTER_NAME=${TKC_NAME}
export CLUSTER_IP=${SERVER}
export CLUSTER_CERT=${CA}
export USER_CA=${CLIENT_CA}
export USER_KEY=${CLIENT_KEY}

# Generate the secret file
envsubst < argocd-secret.template.yaml > argocd-secret.yaml

# Wait for the workload cluster API EP to be fully operational
while ! kubectl version -o json --kubeconfig tkc-kubeconfig > /dev/null; do
  echo "Cluster not ready, retrying..."
  sleep 10
done

kubectl apply -f argocd-secret.yaml -n  "${TKC_NAMESPACE}"