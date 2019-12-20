# Setup minikube

Every components will be installed on top of kubernetes

You can use an existing one, or you can easily start a one new using minikube (https://kubernetes.io/fr/docs/tasks/tools/install-minikube/)

    # There is a known issue with JupyterHub and kubernetes version >= 1.16 (https://github.com/jupyterhub/kubespawner/issues/354)
    minikube start --kubernetes-version=1.15.7 --memory=4g --cpus=2 --addons=ingress
     
Then you have to add dns entries, either using minikube ingress-dns addons (https://minikube.sigs.k8s.io/ingress-dns/readme/) : 

    minikube addons enable ingress-dns

Or you can manually edit /etc/hosts

    echo "$(minikube ip) jupyterhub.minikube mlflow.minikube" | sudo tee -a /etc/hosts

# Helm usage

Following components will be installed with helm (https://helm.sh/docs/intro/install/)

    helm repo add stable https://kubernetes-charts.storage.googleapis.com 
    helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
    helm repo update

# JupyterHub

This JupyterHub setup uses a custom docker image as a profile, you have to build it and make it available.

## Docker image

Docker image is based on jupyter/docker-stacks (https://github.com/jupyter/docker-stacks)

    # to make it available from minikube
    eval $(minikube docker-env)
    docker build -t jupyter-mlflow-on-k8s-env:latest .

## Installation

JupyterHub helm chart

    helm install jupyterhub jupyterhub/jupyterhub --version=0.8.2 -f k8s-manifests/jupyterhub-values.yaml --timeout=600s

# MLFlow tracking

## Backends

PostgreSQL as a metadata backend and MinIO as an artifacts backend.

    helm install mlflow-metadata stable/postgresql -f k8s-manifests/postgresql-values.yaml
    helm install mlflow-artifacts stable/minio -f k8s-manifests/minio-values.yaml

# Notebook

This project is using tensorflow keras tutorial on zalando dataset : https://www.tensorflow.org/tutorials/keras/classification
    
