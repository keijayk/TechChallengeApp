## Summary

This solution automates the deployment of `TechChallengeApp`using Terraform on Azure Cloud Platform.

## Pre-requisites for the deployment solution.

A system with the following installed:

* Azure CLI (2.31.0)
* Terraform (v1.1.0)
* Git (2.25.1)
* Docker (20.10.11)
* Go (1.17.5)

## Required Changes

The following fixes were required to automate the deployment of `TechChallengeApp` using Terraform on Azure Cloud Platform. 

1. Changes in [Dockerfile](Dockerfile) to deploy the frontend of the application as Azure app service.

   To manually configure a custom port like 3000, Azure app service requires one to use the EXPOSE instruction in the Dockerfile and `WEBSITES_PORT` in the app setting, with the port value to bind on the container [[11](https://docs.microsoft.com/en-us/azure/app-service/faq-app-service-linux#custom-containers)].

   Expose port:

   ```
   EXPOSE 3000
   ```

   Fix the path for swagger.json:
   ```
   && sed -i 's#"https://petstore\.swagger\.io/v2/swagger\.json"#"/swagger/swagger.json"#g' /tmp/swagger/dist/index.html
   ```

   Copy files related to swagger to the application container image:
   ```
   COPY --from=build /tmp/swagger/dist ui/assets/swagger
   COPY --from=build /swagger.json ui/assets/swagger/swagger.json
   ```

2. Changes in the frontend of the application for connecting to DB.

   Azure Database for PostgreSQL Single Server [[10](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-postgresql-server-database-using-azure-powershell)] requires that the Username for connecting to postgresql database should be in <username@hostname> format.

   Therefore, the following files were changed to make the DB connection from the frontend of the application.

   - [config/config.go](../config/config.go) 

      Add:
      ```
      v.SetDefault("DbUserWithHost", "postgres@localhost")

      conf.DbUserWithHost = strings.TrimSpace(v.GetString("DbUserWithHost"))
      ```

   - [db/db.go](../db/db.go)

      Change:
      ```
      return fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
          cfg.DbHost, cfg.DbPort, cfg.DbUserWithHost, cfg.DbPassword, cfg.DbName)
      ```

   - [cmd/root.go](cmd/root.go)

      Add:
      ```
      cfg.UI.DB.DbUserWithHost = conf.DbUserWithHost
      ```

   - [conf.toml](conf.toml)

      Add:
      ```
      "DbUserWithHost" = "postgres@localhost"
      ```

      Change:
      ```
      "ListenHost" = "0.0.0.0"
      ```
3. Introduction of Terraform

   The deployment of the application is automated and required infrastructure is deployed using Terraform [code](../terraform).

4. Introduction of Makefile

   The commands in  [Makefile](../Makefile) is used for the process instructions for provisioning the solution on Azure Cloud platform.


## High level architectural overview of the deployment.

![Architecture](./images/scalable-web-app.png?raw=true)

The solution was designed based on the guide [[1](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree)] to choose the following Azure compute services and components for deploying the `TechChallengeApp`application on Azure cloud platform.

### Azure Components

I chose the following Azure Components based on the reasons listed for each one of them.

* Azure App Service [[2](https://azure.microsoft.com/en-us/services/app-service/)] for deploying the `TechChallengeApp`frontend component.
  - A fully managed service that includes built-in infrastructure maintenance, security patching - simplify operations
  - Supports auto scaling: it can be scaled up or scaled out to handle the changing demand - leads to highly available frontend
  - Supports for virtual networks - leads to network segmentation implemented in this solution. 

* Azure Database for PostgreSQL [[3](https://azure.microsoft.com/en-us/services/postgresql/)] Single Server [[4](https://docs.microsoft.com/en-us/azure/postgresql/overview-single-server)] as database given the requirement.
  -  Offers a single-node database service with built-in high availability. 
  -  Handles most of the database management functions such as patching, backups, security with minimal user configuration and control. 

* Azure Container Instance [[5](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)] for executing `updatedb` task for initializing database. The container instance will removed from the infrastructure as the last step of the deployment process.
  - Provides fast startup times - quick to iniitilize database as a one time operation. 

* Azure Key Vault [[6](https://azure.microsoft.com/en-us/services/key-vault/#product-overview)] as Secrets storage for storing database credentials.
  - Integrate with App Service (the frontend app) for advanced secrets management. 
  - Support securely accessing the secrets with a managed identity from App Service (the frontend app).
  
* Azure Virtual Networks(VNets) [[14](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)] to enable the frontend of the application to access database through a virtual network.
  - Support App Service (the frontend app) to access other resources such as database in a seccure manner.

## How the deployment solution meets assessment criteria?

The deployment solution satisfies the following assessment criteria as described below. 

### Security

- Network Segmention

  The deployment solution is designed to achieve network segmentation as folows. The frontend of the application (as Azure app service) is hosted in a Virtual Network (VNet). Private Link [[9](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link)] for Azure Database for PostgreSQL-Single server is used to bring Postgres server inside the VNet in which the frontend of the application is also hosted. The private endpoint exposes a private IP within a subnet that the frontend could use to connect to the database server. This setup secures the outbound connection from an App Service Fronend application to the postgres database.

- Azure Key Vault as Secret Storage

  The deployment solution is designed in a way that the frontend of the application deployed as Azure App Service with a system-assigned identity [[8](https://docs.microsoft.com/en-us/azure/app-service/app-service-key-vault-references)], which is used for securely accessing the Key Vault secret storage to retrieve the database credentials.


- Platform security features
  
  The deployment solution is designed to utilize the platform security features. For instance, using Azure App Service for deploying the frontend of the application benefits from the platform security features such as automated security patching etc. The platform components of Azure App Service are actively secured [[12](https://docs.microsoft.com/en-us/azure/app-service/overview-security)]. There are multiple layer of security options available for Azure Database for PostgreSQL Single Server [[13](https://docs.microsoft.com/en-us/azure/postgresql/concepts-security)]. For example, Azure Database for PostgreSQL uses storage encryption as well as in-transit data encryption. 


### Simplicity
  The deployment solution is designed to be simple to consume only the required dependencies from the Azure cloud platform. 

### Resiliency
  The deployment solution is designed to enable auto scaling and highly available frontend by using a) Azure App Service for the frontend of the application and b) Azure Database for PostgreSQL-Single server as highly available Database.
  

## Process instructions for provisioning the solution on Azure Cloud platform.

Checkout 
```console
git clone --recursive git@github.com:keijayk/TechChallengeApp.git
cd TechChallengeApp
```

Initiailize Terraform deployment:
```console
make init
```

Build app from source:
```console
make build
```

Build app container image:
```console
make build-image
```

To deploy:
```console
make deploy
```

Delete the deployed resources (app, database and all Azuere infrastrucure component):
```console
make destroy
```

Cleanup Terraform cache files:
```console
make clean
```

## Interesting endpoints on Azure:

- App UI URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/
- Swagger URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/swagger/dist/
- Healthcheck URL: https://devopschallengeservian-appservice-ejpn-d.azurewebsites.net/healthcheck/

## References
1. https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree
2. https://azure.microsoft.com/en-us/services/app-service/
3. https://azure.microsoft.com/en-us/services/postgresql/
4. https://docs.microsoft.com/en-us/azure/postgresql/overview-single-server
5. https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview
6. https://azure.microsoft.com/en-us/services/key-vault/#product-overview
7. https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
8. https://docs.microsoft.com/en-us/azure/app-service/app-service-key-vault-references
9. https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link
10. https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-postgresql-server-database-using-azure-powershell
11. https://docs.microsoft.com/en-us/azure/app-service/faq-app-service-linux#custom-containers
12. https://docs.microsoft.com/en-us/azure/app-service/overview-security
13. https://docs.microsoft.com/en-us/azure/postgresql/concepts-security 
14. https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview


## Sample screenshots of the deployed application on Azure.

**Deployed TechChallengeApp UI shows that a new task was added to postgresql DB.**
![app_azure](./images/frontend_azure.png?raw=true)

**Successful Health check for the application.**

![healthcheck_azure](./images/healthcheck_azure.png?raw=true)

**Swagger interface for the application.**

![swagger_azure](./images/swagger_azure.png?raw=true)

