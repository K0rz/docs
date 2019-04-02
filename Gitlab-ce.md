# Installation Gitlab - Docker

Download and run Gitlab-CE with Docker.

```bash
sudo docker run --detach \
        --hostname www.exemple.com \
        --publish 443:443 --publish 80:80 --publish 22:22 \
        --name Gitlab \
        --restart always \
        --volume /srv/gitlab/config:/etc/gitlab:Z \
        --volume /srv/gitlab/logs:/var/log/gitlab:Z \
        --volume /srv/gitlab/data:/var/opt/gitlab:Z \
        gitlab/gitlab-ce:latest
```
Don't forget to replace www.exemple.com with your FQDN.

Connect to Gitlab container.
```bash
sudo docker exec -it Gitlab /bin/bash
```

