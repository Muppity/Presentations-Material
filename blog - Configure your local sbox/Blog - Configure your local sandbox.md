# Configure a local sandbox DB from an AZ environment

  Sometimes we need to create a sandbox environment to do some testing before we push it into our company main Dev repository, we need to do some unit testing while developing our database changes; to do so we need to replicate the testing environment to have it in our local machines. In the following note we will work with a cloud database from an Azure SQL that is in a serverless tier and will create a copy, prepare it for our container environment testing, connect it, and do some local tasks to poor in some data tests inside it.

 These are the steps that will be followed to complete the task:


- [Configure a local sandbox DB from an AZ environment](#configure-a-local-sandbox-db-from-an-az-environment)
  - [Configure you local sandbox DB from your AZ environment](#configure-you-local-sandbox-db-from-your-az-environment)
  - [Connect to Azure tenant](#connect-to-azure-tenant)
  - [Generate BACPAC file and download to local machine](#generate-bacpac-file-and-download-to-local-machine)
  - [Create a container in local container management system](#create-a-container-in-local-container-management-system)
  - [Connect and restore your bacpac binary](#connect-and-restore-your-bacpac-binary)

## Configure you local sandbox DB from your AZ environment

As breifly explained at the begining we are going to start by connecting 

## Connect to Azure tenant

  The first step that need to be done is to start by connecting to our Azure database, the necessary information needed is the server name so for that we can gather that information from:

   * The Azure Portal  
   * The Azure CLI AZ DB command custommed query
   

  **Using the Azure Portal**

Once connected to your Azure account and into the Azure portal, search for the SQL Databases

![SQL Servers](/images/sqlservers.png)

Look up for your server from the list, select it and find your database

![SQL Name](/images/sql%20name.png)

Select the connection string option

![connection option](/images/connection%20option.png)

Now take the connection string for the full name

![String](/images/string.png)

**Using the Azure CLI Terminal for custommed query**

    
  ```azurecli
  az login -u [YourUser] --tenant [if you have more than 1]
  ```
    
  ```azurecli
  az sql server list --query "{name,fullyQualifiedDomainName}"
  ```
  
  
  Retrieve results from Query parameter:

  ![AZ CLI SQL](/images/AZ%20CLI%20SQL%20ls.png)


   - Using ADS
  
  First link your azure account into the ADS.

![ADSAzureAccount](/images/AzureAccount.png)

Expand your ADS Connections search for your server and connect

![ADSConnections](/images/ADS%20Connections.png)



## Generate BACPAC file and download to local machine

- Using ADS
  
  Install Database Admin Tool Extensions for Windows 

![ADS Extension](/images/ADS%20extension.png)

On the targeted database choose the Data-tier Application wizard

![ADS Wizard](/images/ADS%20Wizard%20choose.png)

Select the bacpac generation option in the admin tool extension and select the following option

![ADS Wizard s1](/images/ADS%20Wiz%20step1.png)

Select destination and name for local bacpac file in your machine

![ADS Wizard s2](/images/ADS%20Wiz%20step2.png)

Verify the task response from the panel on sucess operation

![ADS Wizard s4](/images/ADS%20Wiz%20step4.png)


## Create a container in local container management system

Find your Container image and use it, create your container

```bash
#Find your image and update your run command
docker image ls
#Create Container with mount using shared volume created
docker run -d -p 1433:1433 --name Daltanious --privileged -it \
 --mount type="bind,src='shared-vol',dst='/mnt/SQL'" -v   -e "SA_PASSWORD=Clave01*"\
 -e "ACCEPT_EULA=Y" d04f
```

## Connect and restore your bacpac binary

![ADS Import S1](/images/ADS%20Import%20Step%201.png)

![ADS Import S2](/images/ADS%20Import%20Step%202.png)

![ADS Import S3](/images/ADS%20Import%20Step%203.png)

![ADS Result1](/images/ADS%20Result.png)


![ADS Result2](/images/ADS%20Connection.png)