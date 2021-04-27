#!/bin/bash

clear

echo "Hey there, this is Eric Gip's submission for the SADA Google Cloud Trainee test"
echo
echo

while true; do
    read -p "This script requires HyperKit, Docker, and MiniKube, do you wish to install these programs? (Just "N" if already installed.) y/n " yn
    case $yn in
        [Yy]* ) brew install hyperkit minikube docker; break;;
        [Nn]* ) break;;
        * ) echo "Please answer enter y or n";;
    esac
done
echo
echo

echo "Download complete, we're going to start up minikube"
echo
minikube start --vm-driver=hyperkit
echo
echo

echo "To ensure everything is running smoothly, we should see Status=READY and Kubelet=Running"
echo
kubectl get nodes

minikube status
echo

echo "Then, we were told to fork a repository and deploy the app on minikube"
echo "This file already has the Dockerfile configured, so we just need to build an image"

eval $(minikube docker-env)

echo
echo "Building the docker image"
echo "Building the docker image"
echo
docker build -t sadachallenge2 .
echo
echo

echo "You should see an image called sadachallenge2"
echo
docker images -a

echo "Now, we're going to deploy our docker container inside kubernetes automated through our YAML file."
echo "Now, we're going to deploy our docker container inside kubernetes automated through our YAML file."
kubectl apply -f sadachal-deployment.yaml
echo
echo

echo "We should see sadachall4 running for deployments"
echo
kubectl get deployments
echo
echo

echo "We should see sadachall4 running in pods"
echo
kubectl get pods
echo
echo

echo "Next, creating a service to expose the Pod to allow outside users to view."
echo
kubectl expose deployment sadachall4 --type=LoadBalancer --name=sadachall4

echo "Viewing our services to ensure everything is running smoothly"
echo
kubectl get services
echo
echo


echo "Finally, launching our app and seeing our server.js"
echo
minikube service sadachall4
