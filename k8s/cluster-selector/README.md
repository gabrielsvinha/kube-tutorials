# Setup Federation using Cluster Selector to map resources between clusters

In this tutorial, we intent to go through concepts of Cluster Selector using labels, possibly use cases and a quick setup.

## Prerequisites

For this tutorial, I am assuming you have at least two clusters up and running, one On-Premises, one GKE and one Azure (you can also add other clusters from different providers, but have in mind the concepts of labeling we are going through here). Configurations details like number of nodes, regions, etc are left for the reader decision. In case you do not know how to do that, try these steps:

* [How to setup a On Prem cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-on-prem)
* [How to setup a GKE cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-gke)
* [How to setup an Azure cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-azure)

## Hands-on

### Bootstrapping a federation

First, you will need the tools kubernetes has to build clusters and federations. So install [Kubefed](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage#kubernetes-federation-administratorkubefed).

Now, to start the Federation Control Pane, you need to choose a couple of things:

- A host cluster, where the FCP will be running (we will use the GKE cluster)
- A DNS provider (we will be using Google Cloud DNS)

So, with that information, create a Federation using this [tutorial](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-hybrid-federation)

We intent to have the following structure:

![federation structures](https://raw.githubusercontent.com/GabrielSVinha/kube-tutorials/master/k8s/cluster-selector/img/cluster-str.png)

### Labeling nodes

The command to put a label on a node is similar to label any other resource, we use the following command:

```
kubectl label cluster gke kind=public location=us --context=cluster-labeled-federation
kubectl label cluster azure kind=public location=asia--context=cluster-labeled-federation
```

Now we have azure and google cluster labeled as `kind = public`. You can check it by running `cmcmc`, with the following output:

![az label output](https://raw.githubusercontent.com/GabrielSVinha/kube-tutorials/master/k8s/cluster-selector/img/azure.png)
![gke label output](https://raw.githubusercontent.com/GabrielSVinha/kube-tutorials/master/k8s/cluster-selector/img/gke.png)

Our OpenStack cluster needs to be labeled as well, for that run:

```
kubectl label cluster on-prem kind=on-prem location=br --context=cluster-labeled-federation
```

And see it through:

TO-DO

### Running a resource in selected clusters

Now the clusters are labeled, we want to run resources in some specific clusters. First we will create a deployment in all resources,

Kubernetes selects the cluster based on labels in every cluster, when you specify the conditions of the cluster you want to the application to be run at in the resource YAML file. My first example is a deployment with a container with a Flask app that return the node + pod it is running at, you can check the spec in this [file](https://github.com/GabrielSVinha/kube-tutorials/blob/master/k8s/cluster-selector/hello-world-deployment.yaml). Note the annotation with:

```
metadata:
  name: hello-world
  annotations:
    federation.alpha.kubernetes.io/cluster-selector: 
      '[{
        "key": "location",
        "operator": "In",
        "values": ["public"]
      }]'
```

All conditions must be satisfied to the deployment to be created in the cluster. In this case, it will look for a label with the key `kind` and check is the value one of the (`In`) values `["public"]`.

After that, we can create a Service to expose it, it needs to be in the same group os resources of the Deployment, for that we will add the same annotation above. Run:

```
kubectl create -f hello-world-service.yaml
```

This will create a deployment based on this [file](https://github.com/GabrielSVinha/kube-tutorials/blob/master/k8s/cluster-selector/hello-world-service.yaml), redirecting all requests made to `https://<external-ip>:80` to the deployment at port `8080`.

In our context, we will have two Load Balancers (in each public cloud provider) because of the annotation we passed (same as the one above).

If you request any of the ExternalIPs the federated service returns, you will have a response from the initial deployment we created.

## Issues

During the built of this tutorial, I found the following issues:

* When you label a cluster, the resource is created, but you can't see it with the command `kubectl get cluster <your-cluster> --show-labels` only when you describe it, that's probably a bug to be investigated.
* Federates services in a On Premises cluster. We are using OpenStack as cloud provider but this a weak documented and not intuitive option. Version 1.8.0 of kubeadm tend to doesn't work.