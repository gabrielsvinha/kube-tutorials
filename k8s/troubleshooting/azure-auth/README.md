# RBAC Authorization issue with azure

When joining your azure cluster using:
`kubefed join [azure-cluster] --host-cluster-context [host] --cluster-context [azure-context]`

You face the following error message:

By default, Azure clusters does not enable Role-Based Authorization used by kubernetes. That is fixed in version 1.7, until then, here are the steps to fix it:

- SSH to your master machine
- First, add the flag `- "--authorization-mode=RBAC"` in `/etc/kubernetes/manifests/kube-apiserver.yaml` so that APIServer can use RBAC as authenticator
- Now it's needed to create a new Cluter Role Binding in the master node so that kubelet can access and manage resources:
    - Log in as superuser: `$ sudo -i`
    - Run the following: 
        ```
        # kubectl create clusterrolebinding permissive-binding \
                                            --clusterrole=cluster-admin \ 
                                            --user=admin \
                                            --user=kubelet \
                                            --user=kubeconfig \
                                            --user=client \
                                            --group=system:serviceaccounts
        ```
- Finally, restart kubelet in the node:
`$ systemctl restart kubelet`

Now you are able to join you cluster to your federation!