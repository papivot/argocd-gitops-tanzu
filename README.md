# GitOps on vSphere with Tanzu leveraging ArgoCD

* In this example, we will be using the vSphere Namespace (pre-created from vCenter) called `demo1`. Useres can change the reference as needed. 
* We will be deploying ArgoCD in the `demo` vSphere Namespace. 
* Using ArgoCD, we will deploy a Classy Cluster `workload-vsphere-tkg1`.
* Once the cluster deployment complete, the `PostSync` job hook within ArgoCD will add the new cluster to ArgoCD.
* The job will then install `cert-manager` and `contour` K8s addons to the workload cluster deployed in the previous step. 

## Argocd installation (to be execute on the CPVM)
```shell
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```