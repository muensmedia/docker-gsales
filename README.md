![license](https://img.shields.io/badge/license-GPL--3.0-blue.svg)

## g*Sales: dockerized gSales + 🐋 = 💕

Dockerfile to build a [GSALES](https://www.gsales.de/) image for the [Docker](https://www.docker.com/products/docker-engine) opensource container platform.

GSALES is set up using PHP 7.2.x, nginx and MariaDB.  
``docker-compose.yml`` and Træfik support included.
 
If you have improvements or suggestions please open an issue or pull request on the GitHub project page.

## Træfik ![](https://github.com/containous/traefik/raw/master/docs/img/traefik.icon.png "Træfik")

[Træfik](https://github.com/containous/traefik/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy.  
This Docker container **can be** used with the reverse proxy Træfik.

## Quickstart
The quickest way to get started is using docker-compose.  
The coolest way is using Træfik as reverse proxy.

### Docker Compose
```
wget https://raw.githubusercontent.com/muensmedia/docker-gsales/master/docker-compose.yml
```
Please adjust the passwords.

Start g*Sales using:
```
docker-compose up
```

Point your browser to ``http://localhost:8080`` to install g*Sales.  
Go on with section [SMTP](#smtp).

### Docker Compose for Træfik
To use traefik you must have [traefik installed](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-as-a-reverse-proxy-for-docker-containers-on-ubuntu-16-04).  
A docker network named ``traefik`` was created.

Get ``docker-compose.yml`` with traefik support:
```
wget https://raw.githubusercontent.com/muensmedia/docker-gsales/traefik/docker-compose.yml
```
Please adjust the passwords, the network name (if it does not fit for you) and the ``traefik.frontend.rule``.

Start g*Sales using:
```
docker-compose up
```
Point your browser to ``http://localhost:8080`` to install g*Sales.  
Go on with section [SMTP](#smtp).

### Docker
Start a MariaDB container where g*Sales can connect to
```
docker run -d \
--name gsales-mariadb \
-v /path/to/mysql-data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=rootPassword \
-e MYSQL_DATABASE=gsales2 \
-e MYSQL_USER=gsales \
-e MYSQL_PASSWORD=password \
-p 3306:3306 \
mariadb:latest
```
Run the g*Sales container
```
docker run -d \
--link gsales-mariadb:mariadb \
-e MYSQL_DATABASE=gsales2 \
-e MYSQL_USER=gsales \
-e MYSQL_PASSWORD=password \
-e SMTP_HOST=smtp.domain.de \
-e SMTP_PORT=587 \
-e SMTP_SECURITY=ssl \
-e SMTP_USERNAME=mailer@example.com \
-e SMTP_PASSWORD=password \
-v /path/to/volume/DATA:/var/www/gsales/DATA \
-p 8080:80 \
muensmedia/gsales
```

## Available Configuration Parameters
The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag or within the docker-compose.yml file.

### g*Sales
| Name                | Description                                                                                 |
|---------------------|---------------------------------------------------------------------------------------------|
| MYSQL_DATABASE *    | Name of the database for g*Sales.                                                           |
| MYSQL_USER *        | User to access the database.                                                                |
| MYSQL_PASSWORD *    | Password to access the database.                                                            |
| SMTP_HOST           | SMTP domain. Defaults to ``smtp.domain.de``.                                                |
| SMTP_PORT           | SMTP server port. Defaults to ``587``.                                                      |
| SMTP_SECURITY       | SMTP encryption, defaults to `` `` (empty: no encryption). Possible values: ``ssl``, ``tls``|
| SMTP_USERNAME       | SMTP username.                                                                              |
| SMTP_PASSWORD       | SMTP password.                                                                              |

``* Required configuration parameters.``

## SMTP (sending mails)
**SMTP** is required for sending mails.
It can be configured by hand or using the configuration parameters above.

The SMTP configuration gets written to the database on the **first start** of the container **after** the **g\*Sales installation** was finished.

To use automatic SMTP-configuration:
1. Start container
2. Install g*Sales
3. Restart container  
    Using Docker Compose:
    ```
    docker-compose stop && docker-compose up
    ```
4. You are ready to send mails!
