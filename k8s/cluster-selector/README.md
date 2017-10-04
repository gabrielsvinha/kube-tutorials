# Setup Federation using Cluster Selector to map resources between clusters

In this tutorial, we intent to go through concepts of Cluster Selector using labels, possibly use cases and a quick setup.

## Prerequisites

For this tutorial, I am assuming you have at least two clusters up and running, one On-Premises, one GKE and one Azure (you can also add other clusters from different providers, but have in mind the concepts of labeling we are going through here). Configurations details like number of nodes, regions, etc are left for the reader decision. In case you do not know how to do that, try these steps:

* [How to setup a On Prem cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-on-prem)
* [How to setup a GKE cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-gke)
* [How to setup an Azure cluster](https://github.com/walteraa/kubernetes_tutorials/tree/master/k8s-usage/k8s-azure)

## Hands-on!

### Bootstrapping a federation

