#!/bin/bash
curl https://releases.rancher.com/install-docker/17.03.sh | sudo sh
sudo docker run -d --restart=unless-stopped -p 80:8080 rancher/server:stable
