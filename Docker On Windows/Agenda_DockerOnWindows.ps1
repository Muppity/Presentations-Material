#Agenda
#____
##
docker pull mcr.microsoft.com/mssql/server:2017-latest
#1. Detallar Docker en Win 7 y Win10 diferencias y ventajas.
#1.1 Detallar CLI - Boot2Docker - VBox e interface con docker-machine.
#connect to MobyLinux VM
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined `
--privileged --rm -v /:/host mcr.microsoft.com/mssql/server  /bin/sh
chroot /host

#disconnect
exit

#mostrar version de linux
uname -a -r
whoami
ls /opt/

#2. Iniciar Docker   /  Crear un container explicar las opciones mount point, restaurar DBS.
#2.1.a Iniciate docker service on windows
set-service -Name com.docker.service -Status Stopped
set-service -Name com.docker.service -Status Running
set-service -Name com.docker.service -Status Paused
set-service -Name vmicrdv -Status Running
get-Service -Name com.docker.service 

#2.1 Create a Local Adminsitrator Account on O.S. host
$Password = Read-Host -AsSecureString 
New-LocalUser -Name "cloAdmin" -Password $Password -FullName "Carlos Lopez"`
 -Description "Temp. Account for tests."

Add-LocalGroupMember -Group "Administrators" -Member "cloAdmin"

#Crear Container
docker run -d -p 1433:1433 --name lesql --privileged -it --volume C:\SQL_Backups:/media `
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 885d07287041
#Create Container with mount
docker run -d -p 1433:1433 --name lesql --privileged -it `
 --mount type=bind,src=C:\SQL_Backups,dst=/host_mnt/c -e "SA_PASSWORD=Clave01*"`
 -e "ACCEPT_EULA=Y" 885d07287041
#Create container without mount --only instance
docker run -d -p 1433:1433 --name lesql --privileged -it   -e "SA_PASSWORD=Clave01*"`
-e "ACCEPT_EULA=Y" 885d07287041

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
#Check status of the container
docker ps -a
#Show Resources used by Container
docker stats lesql

#3. show Kitematic resources .


#ejecutar SQLCMD
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -Q "select @@servername,@@version"

#5. Conectarse a Server y SSMS Ejecutar queries.
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i "C:\Users\A462175\Desktop\Github-Muppity\SQLQuery_1.sql"

#5.3 mostrar ps y mem docker starts y en la db usando memory_status
docker stats


#6. eliminar cuenta temporal
Remove-LocalUser -Name "cloAdmin"
