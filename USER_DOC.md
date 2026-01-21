# 👥 User & Administrator Documentation

This document explains how to interact with the **Inception** infrastructure. It is designed to help users and administrators manage the services efficiently.

---

## 🏗️ 1. Services Provided
The Inception stack is a multi-container environment where each service performs a specific role:

* **Nginx**: The **Web Server**. It is the only service that communicates with the outside world. It handles HTTPS requests and manages SSL/TLS encryption to keep connections secure.
* **WordPress**: The **Application Layer**. Powered by PHP-FPM, this service runs the website engine. It processes the code that generates your pages and handles the administrative dashboard.
* **MariaDB**: The **Database**. This is a secure SQL server that stores all persistent data, including your posts, user accounts, and site settings.



---

## 🚦 2. Starting and Stopping the Project
Project management is handled via the **Makefile** in the root directory to ensure all commands are executed in the correct order.

### How to Start
To build the custom images and launch all containers, run:
```bash
make

This will automatically prepare your local data folders, build the images based on Debian 12, and start the services.
How to Stop

To shut down the services without losing your database or website files, run:
Bash

make down

## 🌐 3. Accessing the System

Once the project is running, you can access the following web addresses:
Interface	URL	Description
Public Website	https://yrodrigu.42.fr	View the live site as a visitor.
Admin Panel	https://yrodrigu.42.fr/wp-admin	Log in to manage content and settings.

    Important: You must map the domain by adding 127.0.0.1 yrodrigu.42.fr to your /etc/hosts file.

## 🔐 4. Locating and Managing Credentials

Passwords and sensitive configurations are managed through Environment Variables and Docker Secrets to keep them out of the source code.

    Variables: General settings like database names are found in srcs/.env.

    Passwords: Sensitive secrets (like the DB root password or WP admin password) are located in the srcs/secrets/ folder.

    Access: For security, the MariaDB database is only accessible from within the internal Docker network. External tools cannot connect to it directly.

## 🔍 5. Checking Service Health

To ensure the infrastructure is healthy, administrators can perform the following checks:
Check Container Status

Verify that all services are active:
Bash

docker ps

Expected Result: You should see three containers running (nginx, wordpress, mariadb).
Inspect Logs

If you encounter a connection error, check the logs of the relevant container:
Bash

docker logs wordpress
docker logs mariadb

Verify Network

Ensure the containers are connected to the isolated bridge:
Bash

docker network ls
