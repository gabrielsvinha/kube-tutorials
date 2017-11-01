# Monitoring CLuster using HIG stack

## Intro

Kubernetes cluster can be easily set up (specially with the many tools, sdks and cloud providers). After you have it running, the possibilities are infinite. You can have your containerized applications running on your cluster-infra, exposed, etc. All this under the enlightment and management of Kubernetes.

Another interest you may have in your cluster is monitor how it is being used (or how much). In order to do that, there are several tools for monitor your nodes and containers themselves.

In this tutorial, we will go through the HIG stack, which stans for:

* **H**eapster: in a cluster level, Heapster is responsible for collecting data from all Kubelet daemons (kubelet is the kubernetes part that runs in every node inside a cluster).
* **I**nfluxDB: database optimized for massive querys for write events and metrics.
* **G**rafana: a dashboard for visualization of Heapster data.

## Prerequisites

To complete this tutorial I am assuming you have a created and configured cluster. If you do not, feel free to check any of these [tutorials]().

## Deploying stack

The files for all the resources needed are in this directory, download them and run:



```
kubectl create -f influxdb.yaml
kubectl create -f grafana.yaml
kubectl create -f heapster.yaml
```

This will create all the resources we need, specified below:

### Influx

Influx is a database written in Go. designed to be able to support massive loads of events, in the file we created above:

First, we have a deployment containing the InfluxDB container in its spec, we want to create one replica which is more than enough for our context.

In line 21 we have a volume mount for the data, you may want to change the value emptyDir:

```
volumes:
    - name: influxdb-storage
      emptyDir: {}
```

To any place you may mount to store the data in definitive. In the above configuration, if the replica has a health problem the data so far will not be saved.

After that, we have a service to expose Influx data, it creates a Load Balancer. When you create it, kubernetes will give you an external ip address.

### Heapster

Heapster is an engine to collect data from all the nodes in the cluster, it uses the cAdvisor to communicate with kubelet and store all the data in the influx database.

If you take a look at the deployment with the heapster container, there a `command` field in the spec. The first field is:

```
- --source=kubernetes:https://kubernetes.default
```

This means we will be having the default kubernetes configuration. Then we have:

```
- --sink=influxdb:http://monitoring-influxdb:8086
```

This is a sink, a sink is a place where the data collected by heapster is stored. In the above lines I mentioned that heapster throws the data in Influx, that's true in our context, but the config for it can be changed, there are others sinks such as Google Cloud Monitoring, Elastic Search, Kafka, etc.

Finally, we expose heapster with a Load Balancer service running on port 8082.

### Grafana

This is the last part of the stack, Grafana is a data vizualization engine to certain types of computer resources.

In the file we just used to create grafana resources, we have a deployment containing the container replica for Grafana, inside it we have some configuration specifications:

```
- name: INFLUXDB_HOST
  value: monitoring-influxdb
```

This tag passes the endpoint to the Influx data collection

```
- name: GF_SERVER_HTTP_PORT
    value: "3000"
- name: GF_AUTH_BASIC_ENABLED
    value: "false"
- name: GF_AUTH_ANONYMOUS_ENABLED
    value: "true"
- name: GF_AUTH_ANONYMOUS_ORG_ROLE
    value: Admin
- name: GF_SERVER_ROOT_URL
    value: /
```

This is grafan's internal system configs, we enabled anonymou7s access, basic auth access, an organization role enabling anonymous access, the root url which redirects you to all the resources viz, also, the first one represents the port in which grafa will be running.

Then, using the port mentioned above, we expose it with a Load Balancer.

## Goog to go

After that, wait for the cloud provider to give you the external ips from the services above to access them. 

```
watch kubectl get services -n kube-system
```

To view the data via grafan, acces the endpoint in your browser.