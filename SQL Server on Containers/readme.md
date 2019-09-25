![](https://github.com/Muppity/Presentations-Material/blob/master/SQL%20Server%20on%20Containers/%C3%ADndice.png)

### SQL Server on Containers

The following presentation slides are developed through thinking in the hypervisor vs 
containerized environment diferences. Showing the changes in the breakthrough technology, 
taking the benefits of the hypervisor still and Kernel utilization differences.
Pre-compiled Kernels, compiled build designed kernels and the Unikernels.
Based on the library module building philosophy and taking it further Unikernels use parameter based files to create new builds of kernel definitions, based on the soul purpose they are inteded which makes the service light and fast to deploy.

Finally an overview of the layout of the three scenarios practically shown based on Docker,
the second creating a one node clusterized using kubernetes and the third a glance of the
configuration for schematics for AKS.

Here are the description items covered in the presentation slides:

**Table of Contents**

#### Hypervisors vs Containers : 

Having a benchmark between goods and better with containers.

#### Container Infrastructure
Understanding a little bit of Container Infrastructure with their components and interactions.
### Utilizing Docker with SQL Server
Having a glance of Docker layout in a single environment
### Kubernetes K8S with SQL Server
Having an example fo K8S on a Minikube single instance cluster install.
### Describing AKS scenario
Detailing of the Layout configuration for AKS
#### Demos
###### Demo 1
Check out Docker running and interaction with CLI and features.Control, administrate containers in SQL Server perspective.

##### Demo 2
Check out Kubernetes cluster configuration infrastructure layout and features and tools.

##### Script Detail


``` Shell
#####This is the docker part#####

#connect to MobyLinux VM image
#note: detail your image path in case you need to
#access a different one
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host mcr.microsoft.com/mssql/server  /bin/sh
chroot /host


#Show linux version for image containerized
uname -a -r
whoami

#disconnect host return to Guest
exit



#2. Iniciate Docker   /  Create a container detail options: mount point,  restore a DBS.

#Crear Container
docker run -d -p 1433:1433 --name lesql --privileged -it --volume /Users/carloslopez/Desktop/Reports:/mnt/share\
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 314918ddaedf
#Create Container with mount
docker run -d -p 1433:1433 --name lesql --privileged -it 
 --mount type=bind,src=/Users/carloslopez/Desktop/Reports,dst=/mnt/share -e "SA_PASSWORD=Clave01*"\
 -e "ACCEPT_EULA=Y" 314918ddaedf
#Create container without mount --only instance
docker run -d -p 1433:1433 --name lesql --privileged -it   -e "SA_PASSWORD=Clave01*"\
-e "ACCEPT_EULA=Y" 314918ddaedf

#Show configurations of container: inspect JSON
docker inspect lesql
#Show downloaded Images
docker images
#Iniciate Container
docker start lesql
#stop the running Container
docker stop lesql
#Remove  Container
docker rm lesql
#See the status container
docker ps -a
#Show resources utilized for Container
docker stats lesql

#3. Show Kitematic .

#execute  SQLCMD
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -Q "select @@servername,@@version"

#5. Connect a Server y SSMS Ejecutar queries.
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i \
"/Users/carloslopez/GitHub/Presentations-Material/SQL\ Server\ on\ Containers/SQLQuery_1.sql"

#5.3 mostrar ps y mem docker starts y en la db usando memory_status
docker stats

#######This is the K8S Part #################


#starting K8s
## minikube is a service dedicated for running k8s in macOs
## in case you are running under Linux you need to run 
minikube start

#verify on configuration
kubectl config view
##verify on cluster nodes
kubectl get nodes
kubectl get pods


##Create Secret
kubectl create secret generic mssql --from-literal=SA_PASSWORD="MyC0m9l&xP@ssw0rd"
#Create persistent volume
## if succeded you will see the message “persistentvolumeclaim “mssql-data-claim” created
kubectl apply -f /Users/carloslopez/Desktop/pv-claim.yaml
#Create a load balancer.
## After created and deployment you will read “mssql-deployment” created.
kubectl apply -f /Users/carloslopez/Desktop/sqldeployment.yaml
#Start SQL Service

kubectl get service
minikube service mssql-deployment --url

#Stop k8s
minikube stop

#verify on minikube
kubectl cluster-info dump


#set minikube context
kubectl config use-context minikube

#minikube logs
minikube logs

kubectl get event
kubectl --help

##verify on service for minikube, Minikube runs on a built in Docker daemon
minikube dashboard