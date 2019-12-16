# Notebook

This project is using tensorflow keras tutorial on zalando dataset : https://www.tensorflow.org/tutorials/keras/classification

# Docker images

Docker image is based on jupyter/docker-stacks (https://github.com/jupyter/docker-stacks)

    docker build -t jupyter-mlflow-on-k8s-env .
    
# Scaled development

Every components will be installed on top of kubernetes

You can use an existing one, or you can easily start a one new using minikube (https://kubernetes.io/fr/docs/tasks/tools/install-minikube/)

    minikube start
    
## Traefik as ingress gateway

    helm install traefix-ingress stable/traefik    
    
## MLFlow tracking

### Backends

PostgreSQL as a metadata storage

MinIO as an artifacts storage

Both of them will be installed with helm (https://helm.sh/docs/intro/install/)

    helm install mlflow-metadata stable/postgresql -f k8s-manifests/postgresql-values.yaml
    helm install mlflow-artifacts stable/minio -f k8s-manifests/minio-values.yaml

