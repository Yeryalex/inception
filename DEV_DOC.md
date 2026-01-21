# 🛠️ Developer Documentation

This document describes how to set up, build, and maintain the **Inception** infrastructure from a developer's perspective.

---

## 🏗️ 1. Environment Setup

### Prerequisites
To build and run this project, the host environment must have:
* **Operating System**: Debian 12 (Bookworm) is recommended for host-container parity.
* **Docker**: Engine version 20.10+ and Docker Compose V2.
* **Make**: GNU Make to handle the build automation.
* **Sudo Privileges**: Required for volume directory creation and Docker commands.

### Configuration & Secrets
The project uses a combination of Environment Variables and Docker Secrets:
1. **Environment Variables**: Defined in `srcs/.env`. These handle non-sensitive data like database names and the domain name (`yrodrigu.42.fr`).
2. **Secrets**: Sensitive passwords must be stored in the `srcs/secrets/` directory as `.txt` files:
   - `db_password.txt`
   - `db_root_password.txt`
   - `wp_admin_password.txt`
   - `wp_user_password.txt`

---

## 🔨 2. Build and Launch
The infrastructure is orchestrated using **Docker Compose** and a **Makefile** to ensure consistent deployments.

### Build and Execution
Run the following command from the root of the repository:
```bash
make

This command triggers the following sequence:

    Creates local data folders in /home/yrodrigu/data/.

    Builds custom Docker images for Nginx, WordPress, and MariaDB based on Debian 12.

    Orchestrates the startup of containers and the internal network.

Management Commands

    Rebuild everything: make re

    Clean containers/networks: make clean

    Full wipe (including data/volumes): make fclean

## 📦 3. Container & Volume Management
Project Data & Persistence

Data is stored on the host machine using Named Volumes combined with a Local Driver Bind. This ensures data survives container deletion and is easily accessible for backups.
Data Type	Host Path	Container Path
Database Files	/home/yrodrigu/data/mariadb	/var/lib/mysql
WordPress Files	/home/yrodrigu/data/wordpress	/var/www/html
Internal Networking

The services communicate via a dedicated bridge network named inception_network.

    Nginx connects to WordPress via FastCGI on port 9000.

    WordPress connects to MariaDB via the MySQL protocol on port 3306.

    Isolation: Only Nginx exposes port 443 to the host. All other ports are internal.

## 🔍 4. Troubleshooting for Developers
Checking Volume Health

To verify that Docker is correctly binding the host paths:
Bash

docker volume inspect srcs_wp_data

Look for the Options section to confirm the device path points to /home/yrodrigu/data/wordpress.
Accessing Containers

To debug a specific service from the inside:
Bash

docker exec -it wordpress /bin/bash

Log Streaming

To monitor the initialization process in real-time:
Bash

docker compose -f srcs/docker-compose.yml logs -f
