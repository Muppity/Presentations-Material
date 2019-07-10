### SQL Server containers with Docker on Windows


As time changes so does Architectures, MSFT isn't the exception, as a change of paradigm containerized environment IS the actual use of services.

The following material shows the evolution of Docker for windows as well as little bit of history from 2016 release until today (2019).

Here are the description items covered in the presentation slides:

**Table of Contents**

#### Inspect Docker on Windows : 

Have a look on Docker for windows and its Architecture.

#### Docker Features comparison
Compare between versions Docker 1 and 2, and its Features advantages and disadvantages.
#### Demos
###### Demo 1
Check out Docker running and interaction with CLI and features.

##### Demo 2
Control, administrate containers in SQL Server perspective.

##### Script Detail

```Powershell
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

#1.1 Create a Local Adminsitrator Account on O.S. host
#important: you need to add this step in case you 
#are running under elevated security on the O.S.
$Password = Read-Host -AsSecureString 
New-LocalUser "cloAdmin" -Password $Password -FullName "Local Admin" -Description "Temp. Account for tests."
Add-LocalGroupMember -Group "Administrators" -Member "cloAdmin"


#2. Iniciate Docker   /  Create a container detail options: mount point,  restore a DBS.


#Create Container with volume option
docker run -d -p 1433:1433 --name lesql --privileged -it --volume C:\SQL_Backups:/media -e "SA_PASSWORD=Clave01*" `
 -e "ACCEPT_EULA=Y" 885d07287041
#Create Container with mount option
docker run -d -p 1433:1433 --name lesql --privileged -it  --mount type=bind,src=C:\SQL_Backups,dst=/host_mnt/c `
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 885d07287041
#Create container without mounting
docker run -d -p 1433:1433 --name lesql --privileged -it   -e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 885d07287041

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

#5.3 mostrar ps y mem docker starts y en la db usando memory_status
docker stats


#6. delete temporal account
Remove-LocalUser -Name "cloAdmin"

