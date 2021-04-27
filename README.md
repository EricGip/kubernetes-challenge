Eric Gip - SADA Challenge submission

Minikube - hello 

Fork a repository, deploy application to minikube 

The reason I chose this project is because I'm really interested in cloud computing / scalability, haven't had a usecase for Kubernetes/Minikube so I haven't worked with them yet. I was really happy to take a break from leetcode and learn a technology I've been wanting to learn. 

# How to use (macOS)

1. Enter terminal, either move to directory or find relative path to file. 

2. Give permission to script `chmod +x /path/to/run.sh`

3. `/path/to/run.sh` or just `./run.sh`

~~An error I ran into here was `ImagePullBackOff` on my pod statuses. Please fix this by using VIM and changing the k8's configuration with `ImagePullPolicy=Always` to `ImagePullPolicy=Never` when prompted on screen.~~

The whole point of DevOps is CI/CD and automation. I first learned that there are KubeCTL commands to deploy, but then found out that you can auto deploy based on configurations with a YAML file. So I removed the manual steps requiring VIM above and the app should auto deploy now. 

![56sf50](https://user-images.githubusercontent.com/42220408/115805030-fd012800-a398-11eb-821b-76856ac01fb6.gif)

## Steps

1. Learn about minikube 

2. Deploy minikube on your computer

3. Fork https://github.com/learnk8s/kubernetes-challenge

4. Deploy the app to minikube

5. Update the forked repository with files used to deploy the app

6. Send URL to your forked repository

## 1. Minikube overview

Kubernetes is generally going to have master and worker nodes. 

If you want to test something on your local machine, you might not have enough resources to support many nodes. 

Minikube will run Master and Node processes on ONE Machine, and host both master processes and worker processes node. 

It does this with a hypervisor, such as virtual box or HyperKit in our case.

basically creates a virtual box on your laptop, and node runs in that virtual box. 1 node k8's cluster. Used for testing purposes. 

To interact with this cluster, we will use kubeCTL. If you want to configure anything in kubernetes, you'll have to contact one of the master processes, **API Server**. 

We can interact with the API Server through a UI, built in API commands, or through a command line interface, **KubeCTL**.   

## 2. Minikube installation and deploy (for macOS)

For other OS installations, refer to https://minikube.sigs.k8s.io/docs/start/

Note: minikube runs on a hypervisor[https://www.vmware.com/topics/glossary/content/hypervisor], so you're going to need one installed. If you're on mac we can do everything with brew. 

1. Enter Terminal
2. Good practice, but feel free to skip.`brew update`
3. First going to install hypervisor, `brew install hyperkit`
5. `brew install minikube`
	* kubeCTL is a depedency, so we don't have to install it ourselves.
6. If you want to view the commands, `minikube` 
7. To start our local testing cluster,`minikube start --vm-driver=hyperkit`
8. To ensure they're running, we can do `kubectl get nodes` or `minikube status` 
	* We're making sure **status** is `READY` and **kubelet** is `RUNNING`. 

## 3. Fork github repo and build the docker image

1. Fork this page with your github account [https://github.com/learnk8s/kubernetes-challenge]
2. Open terminal or your favorite IDE and enter the directory you want to store the folder in, `git clone github.com/your_forked_repo`
3. Open that folder in your IDE's workspace or ensure that you're in the app's directory in terminal.  

Now, we're going to build the container image with `Docker`.

Normally, we would have to normally configure the `Dockerfile` ourselves, but the repo we forked has already configured it for us. 

IMPORTANT NOTE: Since we're using the image in minikube and not our local system, we need to set the environment variable. `eval $(minikube docker-env)`

4. `docker build -t sadachallenge2 .` View the link in resources for more information on the commands. 

5. ensure the image is created with `docker images -a`

## 4. Deploying our docker container onto minikube. 

We have minikube running, but we still need to deploy a `pod`, which is a group of one or more containers. In this case, its going to be our `sadachallenge2` image we built. 

1. Ensure minikube is still running, `kubectl create deployment sadachall2 --image=sadachallenge2`, replace sadachall2 to any name you want and image=yourContainerName. (View resources for help)

2. View deployments/pods with `kubectl get deployments` or `kubectl get pods`

2.5 An error I ran into here was `ImagePullBackOff` on my pod statuses. We can fix this by changing the k8's configuration with `kubectl edit deployment sadachall2`
   * NOTE: In VSC, this may require you to use VIM. we want to change `ImagePullPolicy` from `Always` to `Never`. `ImagePullPolicy=Never`. 
   * Save and exit, the pod should automatically restart and should be online with `get deployments` or `get pods`

3. Next, we need to create a service to expose the Pod and allow outside users to access it.
	* `kubectl expose deployment sadachall2 --type=LoadBalancer --port=4000`
		* Match port with `Dockerfile` configuration.

4. Ensure everything is set up with `kubectl get services`

5. Launch the app through `minikube service sadachall2`


# Resources

Parts 1 & 2. learn about minikube + deploy minikube on computer. 

https://minikube.sigs.k8s.io/docs/start/

Originally followed the documentation, but I was interested in learning more about what was going on behind the scenes. 

I recommend this channel if you're interested in learning more: https://www.youtube.com/watch?v=E2pP1MOfo3g

Part 3: 

https://docs.docker.com/get-started/02_our_app/

Part 4:

https://kubernetes.io/docs/tutorials/hello-minikube/

ImagePullBackOff issue: 
https://stackoverflow.com/questions/40144138/pull-a-local-image-to-run-a-pod-in-kubernetes

Credits for bash scripts:

http://kb.ictbanking.net/article.php?id=483&oid=5
