# Deploying an app to a Federtion of clusters

## Intro
Hey! In this page we will be seeing a quick overview of the Federation concept inside Kubernetes, creating a custom federstion with all of the main cloud provider and deploying the application into our cluster.

## Federation?
The name federation may sound weird in the beggining, you may as well think we are discussing [Star Trek stuff](https://en.wikipedia.org/wiki/United_Federation_of_Planets). Both ideas are very lookalike, they are a set of individual, smaller, independent pieces that work together under the same law and management. In our Kubernetes case, the pieces that make a federation are clusters, each one with its rules of working and independent from each other. 

## Sync everything
One important idea when discussing k8s fedration is the Sync. When you think about a set of components that you want to provide with the best performance, scalability and price, the idea that one of these component is not involved in the tasks that the others are is not very welcome. That's where the Sync comes in, it assures you that any resource running in the federation  is running at every cluster at once, that way you ease the usage of memory, processing, etc. and have more availability for your application.

## To boldly go...
Going back to our nerd analogy, in the Star Trek universe we have our discoverer and epxlorers. In kubernetes, the U.S.S Enterprise can be compared to a feature called Cross-Cluster Service Discovery. Before, let's metion a little bit more about Federated Services which creates all services in all clusters at your federation, also, it creates a DNS record for your application in some of the public DNS providers. 

The CCSD (for abreviation), is responsible for knowing where to find any other resource through all clusters inside your federation. In order to accomplish it, CCSD uses two different ways:

### DNS from inside the cluster
For first way, we have the following situation: one Pod from our Google Cloud cluster needs to access a resource running in an  Azure cluster, also they are both in the same federation. To make possible this access, CCSD uses one of the currently running resources named kubeDNS allied with a well formed DNS path makes it possible to query (from other cluster) the resource running in any other one.

#### How do I make a good path?
As an convention, we declare the DNS path as follows:

`hw.namespace` and is automatically expanded as `hw.namespace.svc.cluster.local`

For now on, we will consider the federation where the query is intended to hit:

`hw.namespace.federtion.svc.cluster.local`

### An external client trying to acces the federation
The concepts described above apllies to external application accessing the federted clusters, but, the expansion of the DNS hostname is not available. For that, it's common to manually update the entrypoints as CNAMEs to our cluster.

### And..
The title of discoverers and the fact that they are both in federtions is the only thing in common between CCSD and the NCC-1701. Oh, and the fact that both are awesome in their own areas.

# Hands On, baby!
## Pre-requisites
When I got through this tutorial, I was using an Ubuntu 16.04 machine, Kubenetes 1.6, an [Amazon Web Services](https://aws.amazon.com/pt/) account, [Azure](https://portal.azure.com) (and its SDK), [Google Cloud](https://cloud.google.com) (and its SDK), [Conjure-up](https://conjure-up.io/) 2.3.

## Bootstraping
First, since our federation is a set of cluster, we need to have them running and healthy. In the beggining, the Federation Control Pane requires a host cluster for it to run on. My option was to make the google cloud cluster our host cluster.

## Creating all clusters
In this section, we create the clusters that will be inside our federation, check out any of the tutorials who contain who to create a cluster on each of the cloud providers:

- [Azure](https://github.com/GabrielSVinha/kube-tutorials/blob/master/k8s/azure/README.md#creating-an-azure-acs-cluster)
- [AWS]() (TO-DO)
- [Google Cloud](https://github.com/GabrielSVinha/kube-tutorials/tree/master/k8s/gcp#creating-a-cluster)
- [On-Prem]() (TO-DO)