# Running the application in your Azure cluster

## Setting up azure

First, you need an active account on [Azure Cloud](https://portal.azure.com/) as well as a valid subscription.

This tutorial was built in a Ubuntu machine using bash, (KubeCTL)[https://kubernetes.io/docs/tasks/tools/install-kubectl/]. Also, we will need (Azure Command Line tool)[https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest].

Login in your azure account in the CLI using the command:
`az login`

This will show a message with a link + token, open it in your naviagator and log in.

## Creating a Resouce Group

Azure uses resource groups to map all objects created in the provider. Resource groups provide quotas, security access, etc. to all Virtual Machines, containers, clusters, etc in the group, you can also specify a location where all the created objects will be running at. Let's create a resource group for our cluster to run at:

`az group create --name [your-group-name] --location [your-preferred-location]`

## Creating an Azure ACS cluster

Now. we can create a cluster using the following command:

`az acs create --orchestrator-type kubernetes --resource-group [your-group-name] --name [your-cluster-name] --generate-ssh-keys`

Here is what each flag represents,

--orchestrator-type: specify which orchestrator will be used, azure supports kubernetes, Swarm, DCOS, DockerCE
--resource-group: defines the resource group where the cluster will be running
--name: names the cluster
--generate-ssh-keys: generates keys to access each machine from outside the cluster 

## Setting up local Kubernetes

Now, we need to setup kubectl locally to make requests, manage and control our cluster in azure. For that, we use the following command:

`az acs kubernetes get-credentials --resource-group [your-group-name] --name [your-cluster-name]`

This will change your `~/.kube/config` file with all keys and access tokens to your cluster.

## Running our app

### Creating a deployment
 
 In this step we will create a Deployment with our container image and attach it to our cluster. A deployment is a resources in Kubernetes managed by the Deployment Controller. Such controller will be responsible for managing the current state, this means he will receive a desired state (in the form of a YAML file) and make all efforts to make the Actual deployment state closest to the desired one. Our desired state is expressed in this [file](https://github.com/GabrielSVinha/hw-flask/blob/master/k8s/hello-world-deployment.yaml), the most importante data is 
 
 `number of replicas = 2`

 `image of the container = vinhags/hw-flask:1.0`

 `port it will be running = 8080`
 
 Also, our deployment passes an `env` tag which is data we want our Pods and VMs to know about. In the file, you can see the `spec.nodeName` on the fields of the environment variable.

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

After executing the above command you should see a result such as:

![results](https://raw.githubusercontent.com/GabrielSVinha/hw-flask/master/k8s/screenshots/Screenshot%20from%202017-09-11%2015-04-21.png)

If you had any trouble following this tutorial or any questions regarding the app or kubernetes structures proposed, feel free to open an [issue](https://github.com/GabrielSVinha/hw-flask/issues) and I will be checking soon.

Mesmos passos do GCP.