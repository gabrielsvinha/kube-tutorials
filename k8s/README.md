# Running the application in your GCloud cluster

In this tutorial we will show how to run this simple application on [Google Cloud](https://cloud.google.com/?hl=pt-br).

## The application
The app is built in Flask and returns the IP Address of the Pod which the request is running. If you had trouble knowing what is a Pod check out this [link](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/).

## Specifications
 In order to complete this tutorial I am assuming your have an machine with [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), bash, an account on google cloud (check link above) and the [Google Cloud SDK](https://cloud.google.com/sdk/?hl=pt-br) already installed.
 
### Creating a cluster
 
 To create a cluster on Google Cloud you can use the following command:
 
 `$ gcloud container clusters create [your-cluster-name]`
 
 After a couple of minutes, in your online  Google Cloud console, you will check that your cluster is created as well your Virtual Machines instances.
 
 ![cluster](https://raw.githubusercontent.com/GabrielSVinha/hw-flask/master/k8s/screenshots/Screenshot%20from%202017-09-11%2009-28-06.png)
 &
 ![nodes](https://raw.githubusercontent.com/GabrielSVinha/hw-flask/master/k8s/screenshots/Screenshot%20from%202017-09-11%2009-27-46.png)
 
### Creating a deployment
 
 In this step we will create a Deployment with our container image and attach it to our cluster. A deployment is a resources in Kubernetes managed by the Deployment Controller. Such controller will be responsible for managing the current state, this means he will receive a desired state (in the form of a YAML file) and make all efforts to make the Actual deployment state closest to the desired one. Our desired state is expressed in this [file](https://github.com/GabrielSVinha/hw-flask/blob/master/k8s/hello-world-deployment.yaml), the most importante data is 
 
 `number of replicas = 2`

 `image of the container = vinhags/hw-flask:1.0`

 `port it will be running = 8080`
 
 Download the file, then run:
 `$ kubectl create -f /path/to/hello-world-deployment.yaml`
 
### [Exposing](https://pbs.twimg.com/profile_images/760600630192996353/PKs7nZm6.jpg)

Now we want our application to be viewable from the outside world, for that we will create a Service, another kubernetes resource managed by the Service Controller. This controller is reponsible to provide a way of access the application from outside the cluster. For that run the following command:

`$ kubectl expose deployment hello-world-deployment --type="LoadBalancer" --name=[your-service-name]`

`TO-DO: Update yaml file to to do the same`

With this command we are creating a service attached to the `hello-world-deployment` we created earlier. Notice the type we specified in `--type="LoadBalancer"` flag, a Load Balancer is a resource managed by the cloud provider (in our case, google cloud) that gives an External IP address and map all requests to this IP into some Pod in our cluster.

If you type:

`$ watch kubectl get svc [your-service-name]`

You will se the External IP field change and give you the IP addres from the Load Balancer.

![endpoint](https://raw.githubusercontent.com/GabrielSVinha/hw-flask/master/k8s/screenshots/ip%2Bport.png)

In the port field, we see two values, in the left, is the external port (specified in both the Deployment creation and in the container Dockefile) which is `8080`, by the right we see the node port which is internal to the cluster.

### Finally

Now our application is running and exposed we can make requests at will to the external IP and it will return the internal IP of the Pod it is running.

`$ curl <externalIP>:<port>`

Thanks!