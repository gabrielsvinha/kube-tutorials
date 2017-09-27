# Trouble with DNS in a federation

When creating a federation hoted by a Google Cloud cluster, the Federation Control Pane shows you the following logs:

![h](https://raw.githubusercontent.com/GabrielSVinha/kube-tutorials/master/k8s/troubleshooting/dns/auth/Screenshot%20from%202017-09-26%2015-23-08.png)

The error resides in the host cluster, by default the Google Container Engine does not create our cluster with the scopes and configuration proper to a federated approach.

Since we have a federation and, amongst other resources, Cross-Cluster Discovery and Federated services require a DNS record inside the cluster so that all balancing work properly, we need the google cloud dns scope running in our cluster. For doing so, you need top create your cluster as follows:

```
$ gcloud container clusters create [your-cluster-name] \
        --num-nodes 1 \
        --scopes "cloud-platform,storage-ro,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

Now DNS will be working properly in your cluster!