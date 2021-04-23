#!/bin/bash

clear

echo "Hey there, this is Eric Gip's submission for the SADA Google Cloud Trainee test"
echo
echo

while true; do
    read -p "This script requires HyperKit, Docker, and MiniKube, do you wish to install these programs? (Just "Y" if already installed.) y/n " yn
    case $yn in
        [Yy]* ) brew install hyperkit minikube docker; break;;
        [Nn]* ) exit;;
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
echo
docker build -t sadachallenge2 .
echo
echo

echo "You should see an image called sadachallenge2"
echo
docker images -a

kubectl create deployment sadachall2 --image=sadachallenge2
echo
echo

echo "I couldn't figure out how to automate this, please change ImagePullPolicy=Always to ImagePullPolicy=Never in order to avoid a bug you can view in the ReadMe."
echo
while true; do
    read -p "Are you ready to use VIM editor? Please change ImagePullPolicy=Always to ImagePullPolicy=Never in order to avoid a bug you can view in the ReadMe. If you aren't comfortable with VIM, you may enter N and try to see if it doesn't fail. y/n " yn
    case $yn in
        [Yy]* ) kubectl edit deployment sadachall2; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "We should see sadachall2 running"
echo
kubectl get deployments

echo "We should see sadachall2 running"
echo
kubectl get pods

echo "Next, creating a service to expose the Pod to allow outside users to view."
echo
kubectl expose deployment sadachall2 --type=LoadBalancer --port=4000

echo "Viewing our services to ensure everything is running smoothly"
echo
kubectl get services

echo "Finally, launching our app and seeing our server.js"
echo
minikube service sadachall2
