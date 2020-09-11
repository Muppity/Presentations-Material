#Agenda
#____
##WSL
#check the WSL mode, run
wsl -l -v
wsl -s Ubuntu-20.04
code --remote wsl+Ubuntu-20.04


#To upgrade your existing Linux distro to v2, run:

wsl --set-version (distro name) 2

#To set v2 as the default version for future installations, run:

wsl --set-default-version 2

##
docker pull mcr.microsoft.com/mssql/server:2017-latest


#show linux environment
uname -a -r
whoami
ls /opt/mssql

tail /etc/mtab

#inspect available images
docker image ls

#Create a  Container with volume option 
docker run -d -p 1433:1433 --name Daltanious --privileged -it -e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y"\
--volume /mnt/c/Users/Beralios/Desktop/SQLBackups:/mnt/share\
-e "SA_PASSWORD=Clave01*" -e "ACCEPT_EULA=Y" d04f

#Create a shared volume
docker volume create shared-vol
docker volume create sqlvolume

docker volume ls

#Create Container with mount using shared volume created
docker run -d -p 1433:1433 --name Daltanious --privileged -it \
 --mount type=bind,src='shared-vol',dst='/mnt/SQL' -v   -e "SA_PASSWORD=Clave01*"\
 -e "ACCEPT_EULA=Y" d04f
#Create container without mount --only instance
docker run -d -p 1433:1433 --name Daltanious --privileged -it   -e "SA_PASSWORD=Clave01*" \
 -e "ACCEPT_EULA=Y" --mount type=bind,src=/mnt/c/Users/Beralios/Desktop, dst=/mnt/SQLBackups d04f

#Start Container
docker start Daltanious
#Stop Container
docker stop Daltanious
#Eliminar Container
docker rm Daltanious
#Show containerized config inspect JSON
docker inspect Daltanious
#Check status of the container
docker ps -a


##wsl
#verify mount points from WSL perspective
ls /mnt/c/Users/Beralios/Desktop/SQLBackups
ls /mnt/c/Users/Beralios/Desktop/Query/*
ls -ltr /mnt/wsl/docker-desktop-bind-mounts/Ubuntu-20.04/2f12bd6eb0b585cd99d53c4c02567182704ba97379eeddcd19c768516fefe84b
ls /mnt/wsl
##Manually make changes on your windows scripts and copy to your container env.
##copy backups to Docker mountpoint
cp /mnt/c/Users/Beralios/Desktop/SQLBackups/*  /mnt/wsl/docker-desktop-bind-mounts/Ubuntu-20.04/2f12bd6eb0b585cd99d53c4c02567182704ba97379eeddcd19c768516fefe84b
##copy Scripts to Docker mountpoint
cp /mnt/c/Users/Beralios/Desktop/Query/* /mnt/wsl/docker-desktop-bind-mounts/Ubuntu-20.04/2f12bd6eb0b585cd99d53c4c02567182704ba97379eeddcd19c768516fefe84b




#execute SQLCMD

#check server running
docker exec -it Daltanious  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -Q "select @@servername,@@version"  -t10   -y5000 

#restore a database
docker exec -it Daltanious  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i "/mnt/SQL/SQLQuery_Restore.sql"  -t10   -y5000 
#inspect information from engine running
docker exec -it Daltanious  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i "/mnt/SQL/SQLQuery_Inspect.sql"  -t10   -y50 

docker exec -it Daltanious  /opt/mssql-tools/bin/sqlcmd  -Usa -PClave01* -i " sp_readerrorlog 0"  -t10   -y50 

#verify container mountpoints
#docker exec -it Daltanious ls /mnt/SQLBackups
docker exec -it Daltanious ls /mnt/SQL --color


#services verification
service  --status-all
service nginx start
service php7.3-fpm start


service nginx restart
service php7.3-fpm restart

#systemctl list-units --type=target
#systemctl start nginx.service

