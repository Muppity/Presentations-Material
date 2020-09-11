#Take Image from SQL Server
#Choose bewteen
#2019-latest
#2017-latest
FROM mcr.microsoft.com/mssql/server:2017-latest

#containing personal instructions.
#COPY testfile.txt .
RUN -d -p 1433:1433 --name Daltanious --privileged -it \
 --mount type=bind,src='shared-vol',dst='/mnt/SQL' -e "SA_PASSWORD=Clave01*"\
 -v sqlvolume:/var/opt/mssql\
 -e "ACCEPT_EULA=Y" d04f
LABEL "name"="Daltanious"
#Copying the SQL Backups
COPY mnt/c/Users/Beralios/Desktop/SQLBackups/*  /mnt/SQL/

#Copying SQL Scritps

#


