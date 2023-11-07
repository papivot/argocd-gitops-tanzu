# GitOps on vSphere with Tanzu leveraging ArgoCD

* In this example, we will be using the vSphere Namespace (pre-created from vCenter) called `demo1`. Users can change the reference as needed. 
* We will be deploying ArgoCD in the `demo` vSphere Namespace. 
* Using ArgoCD, we will deploy a Classy Cluster `workload-vsphere-tkg1`.
* Once the cluster deployment complete, the `PostSync` job hook within ArgoCD will add the new cluster to ArgoCD.
* The job will then install `cert-manager` and `contour` K8s addons to the workload cluster deployed in the previous step. 

## Argocd installation (to be execute on the CPVM)
```shell
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
vi install.yaml # There are two ClusterRoleBindings with reference to "namespace: argocd". Change them to "namespace: demo1" and save the file. 
kubectl apply -f install.yaml -n demo1

# Expose the argocd-server service as type LoadBalancer and get the IP address of the UI service. 
# This can be later modified to expose the service as type Ingress or HttpProxy
kubectl patch svc argocd-server -n demo1 -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n demo1 -o json|jq -r '.status.loadBalancer.ingress[0].ip'

# Grab the initial-admin-secret to login to ArgoCD 
kubectl get secret -n demo1 argocd-initial-admin-secret -o json|jq -r '.data.password'|base64 -d;echo
```

