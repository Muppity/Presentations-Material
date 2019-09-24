#Agenda
#____
##
docker pull mcr.microsoft.com/mssql/server:2017-latest
#1. Detallar Docker en Win 7 y Win10 diferencias y ventajas.
#1.1 Detallar CLI - Boot2Docker - VBox e interface con docker-machine.
#connect to MobyLinux VM
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined \
--privileged --rm -v /:/host mcr.microsoft.com/mssql/server  /bin/sh
chroot /host

#disconnect
exit

#mostrar version de linux
uname -a -r
whoami
ls /opt/



#Crear Container
docker run -d -p 1433:1433 --name lesql --privileged -it --volume /Users/carloslopez/Desktop/Reports:/media\
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" 314918ddaedf
#Create Container with mount
docker run -d -p 1433:1433 --name lesql --privileged -it 
 --mount type=bind,src=/Users/carloslopez/Desktop/Reports,dst=/host_mnt/c -e "SA_PASSWORD=Clave01*"\
 -e "ACCEPT_EULA=Y" 314918ddaedf
#Create container without mount --only instance
docker run -d -p 1433:1433 --name lesql --privileged -it   -e "SA_PASSWORD=Clave01*"\
-e "ACCEPT_EULA=Y" 314918ddaedf

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
docker exec -it lesql  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i \
"C:\Users\A462175\Desktop\Github-Muppity\SQLQuery_1.sql"

#5.3 mostrar ps y mem docker starts y en la db usando memory_status
docker stats


#6. eliminar cuenta temporal
Remove-LocalUser -Name "cloAdmin"
