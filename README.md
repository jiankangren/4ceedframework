4CeeD Framework Deployment
====

4CeeD is a framework that supports **C**apture, **C**urate, **C**oordinate, **C**orrelate, and **D**istribute scientific data. For more information, visit 4CeeD's website at https://4ceed.github.io 

This repository consists of a collections of deployment scripts for various tools and components that make up the 4CeeD framework.

## Prerequisites
- Docker (1.9.1 or later)
- Kubernetes (1.1 or later)

## Quick start
To quickly test 4CeeD framework, we recommend to use a local setup of Kubernetes using [minikube](https://github.com/kubernetes/minikube). To setup a minikube cluster on a local computer, follow [minikube's setup instructions](http://kubernetes.io/docs/getting-started-guides/minikube/).

After installing minikube, start a minikube cluster:

```
minikube start
```

Before starting 4CeeD services, modify `custom.conf` file to customize new your 4CeeD instance. For the quick start with minikube, you only need to modify `ADMIN_EMAIL` and `SMTP_SERVER` to update your own orignazation information. After that, run `./reconf.sh` to refresh the configuration. Then, start all 4CeeD services by running the following command:
```
./startup.sh
```

Wait until all 4CeeD services start (this process can take a while since it will require downloading a bunch of Docker images from Docker Hub). To check the status of all services, use the following command and make sure that all pods have status `Running`:

```
kubectl get pods --namespace=4ceed
```

When all servies have started, we can access 4CeeD Curator at `http://192.168.99.100:32500`, and 4CeeD Uploader at `http://192.168.99.100:32000/4ceeduploader/`. Please note that `192.168.99.100` is the default IP address of minikube node. To obtain this address, run `minikube ip`.

To stop all services, run the following command:
```
./shutdown.sh
```

## Setup 4CeeD on a baremetal cluster

This guide is recommended for more advanced users with Linux and cluster setup experience.

First, you will need to have Kubernetes setup on a baremetal cluster. Pick your own solution [here](http://kubernetes.io/docs/getting-started-guides/#bare-metal) (we have tested on [Ubuntu](http://kubernetes.io/docs/getting-started-guides/ubuntu/) cluster). 

Next, update configuration in `custom.conf` according to your Kubernetes setup:

* `KUBECTL`: Path to `kubectl` command
* `MONGODB_IP`, `RABBITMQ_IP`, `ELASTICSEARCH_IP`: IP addresses of services based on your cluster IP range setup
* `CURATOR_IP`, `UPLOADER_IP`: IP addresses of the node in cluster being exposed for accessing Curator & Uploader 

Then, run `./reconf.sh` to refresh configuration information.

After that, you can follow remaining steps that are similar to ones in Quick start. Please note that 4CeeD curator is now at: `http://[CURATOR_IP]:32500`, and 4CeeD Uploader is now at: `http://[UPLOADER_IP]:32000/4ceeduploader/`.


