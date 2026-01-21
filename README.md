# Inception

*This project has been created as part of the 42 curriculum by yrodrigu.*

---

## 📖 Description
The **Inception** project is a journey into System Administration through virtualization. The goal is to set up a small infrastructure composed of different services (**Nginx**, **WordPress**, and **MariaDB**) using **Docker Compose**.

Every service runs in its own dedicated container. This project emphasizes the "manual" approach: instead of using ready-made images from Docker Hub, I build my own images using **Debian 12-slim** as the base, ensuring a deep understanding of containerization and service orchestration.

---

## 🛠️ Project Design Choices
This infrastructure is designed for security and modularity:

* **Nginx**: Acts as the only entry point, handling TLS (SSL) via port `443`.
* **WordPress**: Runs with PHP-FPM to handle dynamic content, isolated from the web server.
* **MariaDB**: Stores the database, hidden from the public and accessible only by the WordPress container.

---

## 📊 Technical Comparisons

### Virtual Machines vs Docker
* **VMs**: Virtualize the hardware. Each VM has its own Kernel, making them heavy and slow to start.
* **Docker**: Virtualizes the Operating System. Containers share the host's Kernel, making them lightweight, fast, and highly portable.

### Secrets vs Environment Variables
* **Environment Variables**: Visible in `docker inspect` and process lists. Best for non-sensitive config (like Database names).
* **Secrets**: Protected files (located in `/run/secrets/` inside the container). Best for sensitive data like passwords, ensuring they are never exposed in logs or image history.

### Docker Network vs Host Network
* **Host Network**: The container shares the host's IP and ports directly. There is no isolation.
* **Docker Network**: Creates an isolated virtual bridge. Containers talk to each other using internal DNS (service names) and ports that aren't exposed to the outside world.

### Docker Volumes vs Bind Mounts
* **Bind Mounts**: Direct mapping of a host folder to a container folder. Simple but depends on host file structure.
* **Docker Volumes**: Managed by Docker. In this project, we use **Named Volumes with a local driver** to map data specifically to `/home/yrodrigu/data`, combining Docker's management with host-path persistence.

---

## 🚀 Instructions

### Prerequisites

* Docker & Docker Compose
* `sudo` privileges (to manage the `/home/yrodrigu/data` directory)

### Installation & Execution

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-link> inception && cd inception
    ```

2.  **Build and Start:**
    ```bash
    > It is important to notice that this project uses "secrets/*.txt" and ".env" files avoiding security disruption when running the application.
    > You must define your secrets passwords and the srcs/.env to complete the execution of make.
    
    Now write "make" in the CLI and press enter.
    ```
    *This will automatically create the necessary directories on your host and launch the containers.*

3.  **Access the site:**
    Open your browser and go to `https://yrodrigu.42.fr`.
    > **Note:** Ensure you have mapped this domain in your `/etc/hosts` file:
    > `127.0.0.1 yrodrigu.42.fr`

---

## ⌨️ Useful Commands

| Command | Action |
| :--- | :--- |
| `make down` | Stop and remove containers. |
| `make clean` | Remove containers and delete stored data. |
| `make re` | Full wipe and restart of the infrastructure. |

---

## 📚 Resources
* [Docker for starters](https://carpentries-incubator.github.io/docker-introduction/)
* [Docker tutorial for begginers](https://docker-curriculum.com/)
* [Docker Documentation](https://docs.docker.com/)
* [Nginx Beginner's Guide](http://nginx.org/en/docs/beginners_guide.html)
* [WordPress CLI Handbook](https://make.wordpress.org/cli/handbook/)
* [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

---

## 🤖 Use of AI
In this project, AI (Gemini) was used as a technical thought partner.

* **Tasks**: Debugging connection errors between containers (Error 1130), configuring the local volume driver for specific host path persistence, and optimizing `setup.sh` scripts to handle the Docker lifecycle (idempotency).
* **Parts of Project**: Specifically aided in the Docker Compose volume configuration and the shell script logic for waiting on service availability using `netcat`.
* **Guide Infrastructure**: Show the path to follow for an structured folder organization so that the application runs covering isolation, modularity and security.
