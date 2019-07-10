### SQL Server containers with Docker on Windows

![]http://www.ervik.as/wp-content/uploads/2016/09/microsoft-docker-containers.jpg)

As time changes so does Architectures, MSFT isn't the exception, as a change of paradigm containerized environment IS the actual use of services.

The following material shows the evolution of Docker for windows as well as little bit of history from 2016 release until today (2019).

Here are the description items covered in the presentation slides:

**Table of Contents**

[TOCM]

[TOC]


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
#connect to MobyLinux VM
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host mcr.microsoft.com/mssql/server  /bin/sh
chroot /host

#disconnect
exit

#mostrar version de linux
uname -a -r
whoami
ls /opt/

#2. Iniciar Docker   /  Crear un container explicar las opciones mount point, restaurar DBS.
 
#2.1 Create a Local Adminsitrator Account on O.S. host
$Password = Read-Host -AsSecureString 
New-LocalUser "cloAdmin" -Password $Password -FullName "Carlos Lopez" -Description "Temp. Account for tests."
Add-LocalGroupMember -Group "Administrators" -Member "cloAdmin"

#Crear Container
docker run -d -p 1433:1433 --name lesql --privileged -it --volume C:\SQL_Backups:/media -e "SA_PASSWORD=Clave01*" `
 -e "ACCEPT_EULA=Y" 885d07287041
#Create Container with mount
docker run -d -p 1433:1433 --name lesql --privileged -it  --mount type=bind,src=C:\SQL_Backups,dst=/host_mnt/c `
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 885d07287041
#Create container sin mount
docker run -d -p 1433:1433 --name lesql --privileged -it   -e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 885d07287041

#Mostrar Configuraciones inspect JSON
docker inspect lesql
#Mostrar Images
docker images
#Iniciar Container
docker start lesql
#detener Container
docker stop lesql
#Eliminar Container
docker rm lesql
#Ver el estado del container
docker ps -a
#Mostrar Recursos Usados por Container
docker stats lesql

#3. Mostrar Kitematic .


#ejecutar SQLCMD
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -Q "select @@servername,@@version"

#5. Conectarse a Server y SSMS Ejecutar queries.

#5.3 mostrar ps y mem docker starts y en la db usando memory_status
docker stats


#6. eliminar cuenta temporal
Remove-LocalUser -Name "cloAdmin"

