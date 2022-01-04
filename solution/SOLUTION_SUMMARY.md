## Summary

This solution automates the deployment of `TechChallengeApp`using Terraform on Azure Cloud Platform.

## Pre-requisites for the deployment solution.

* Azure CLI (2.31.0)
* Terraform (v1.1.0)
* Git (2.25.1)
* Docker (20.10.11)

## Required Changes

The following fixes were required to automate the deployment of `TechChallengeApp`using Terraform on Azure Cloud Platform. 

- Dockerfile
1. Expose port
```
EXPOSE 3000
```

2. Added the following to Dockerfile to fix configuring Swagger

```
COPY --from=build /tmp/swagger/dist ui/assets/swagger
COPY --from=build /swagger.json ui/assets/swagger/swagger.json
```

- config/config.go 

DbHostName

- db/db.go

```
return fmt.Sprintf("host=%s port=%s user=%s@%s password=%s dbname=%s sslmode=disable",
		cfg.DbHost, cfg.DbPort, cfg.DbUser, cfg.DbHostName, cfg.DbPassword, cfg.DbName)
```

- cmd/root.go


- go.mod

- conf.toml

## High level architectural overview of the deployment.

The deployment solution was designed based on the guide [1](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) to choose the following Azure compute services and components for the `TechChallengeApp`application.

### Azure Components
I chose the following Azure Components based on the underlying reasons listed for each one of them.

* Azure App Service [2](https://azure.microsoft.com/en-us/services/app-service/) for deploying the `TechChallengeApp`frontend component.

  Azure App Services:
  - is a fully managed service that includes built-in infrastructure maintenance, security patching - simplify operations
  - Supports auto scaling: it can be scaled up or scaled out to handle the changing demand - leads to highly available frontend
  - Supports for virtual networks - leads to network segmentation implemented in this solution. 

* Azure Database for PostgreSQL [3](https://azure.microsoft.com/en-us/services/postgresql/) Single Server [4](https://docs.microsoft.com/en-us/azure/postgresql/overview-single-server) as database given the requirement.
 
  Azure Database for PostgreSQL Single Server:
  -  Offers a single-node database service with built-in high availability. 
  -  Handles most of the database management functions such as patching, backups, security with minimal user configuration and control. 

* Azure Container Instance [5](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)for executing `updatedb` task for initializing database. 

  Azure Container Instance:
  - Provides fast startup times - quick to iniitilize  data based as a one time operation.

* Azure Key Vault [6](https://azure.microsoft.com/en-us/services/key-vault/#product-overview) as Secrets storage for storing database credentials.
  
  Azure Key Vault:
  - 

* Azure Virtual Networks(VNets) to enable Web application to access database through a virtual network.


### Security

- Network Segmention

  The deployment solution is designed to achieve network segmentation as folows. 

  The Frontend of the application (as Azure app service) is hosted in a Virtual Network (VNet). Private Link [9](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link) for Azure Database for PostgreSQL-Single server is used to bring Postgress server inside the Virtual Network (VNet) in which Frontend application is also hosted. The private endpoint exposes a private IP within a subnet that the Frontend could use to connect to the database server. This setup secures the outbound connection from an App Service Fronend application to the postgress database. 

- Azure Key Vault as Secret Storage

  The deployment solution is designed in a way that the Frontend of the application deployed as Azure App Service with a system-assigned identity [8](https://docs.microsoft.com/en-us/azure/app-service/app-service-key-vault-references), which is used for accessing the Key Vault secret storage to access the database credentials.


- Platform security features
  
  The deployment solution is designed to utilize the platform security features. For instance, using Azure App Serivice for deploying Frontend of the application benefits from the platform security features such as automated security patching etc.


### Simplicity
  The deployment solution is designed to be simple and to consume only the required dependencies from the Azure cloud platform. 

### Resiliency
  The deployment solution is designed to enable auto scaling and highly available frontend by using a) Azure App Service for the Frontend of the application and b) Azure Database for PostgreSQL-Single server as highly available Database.
  

## Process instructions for provisioning your solution.

### Deploying Solution Locally


### Deploying Solution on Azure

Checkout 
```console
git clone --recursive git@github.com:keijayk/TechChallengeApp.git
```

Setup:
```console
make init
```

Build app container image:
```console
make build-image
```

Push app container image:
```console
make push-image
```

To deploy:
```console
make deploy
```

Delete deployed resources (app, database and all Azuere infrastrucure component):
```console
make destroy
```

Cleanup:
```console
make clean
```



## Interesting endpoints on Azure:

- App UI URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/
- Swagger URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/swagger/dist/
- Healthcheck URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/healthcheck/

## Reference
1. https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree
2. https://azure.microsoft.com/en-us/services/app-service/
3. https://azure.microsoft.com/en-us/services/postgresql/
4. https://docs.microsoft.com/en-us/azure/postgresql/overview-single-server
5. https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview
6. https://azure.microsoft.com/en-us/services/key-vault/#product-overview
7. https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
8. https://docs.microsoft.com/en-us/azure/app-service/app-service-key-vault-references
9. https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link
10.https://docs.microsoft.com/en-gb/archive/blogs/waws/things-you-should-know-web-apps-and-linux
11.