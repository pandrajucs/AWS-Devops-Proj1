#!/bin/bash
echo "Starting script"
curl https://get.docker.com/ | bash
sleep '10s'
sed -i "/ExecStart=/c\ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H unix:// -H tcp://0.0.0.0:2375" /lib/systemd/system/docker.service

systemctl daemon-reload

service docker restart

curl http://localhost:2375/images/json

echo "Ending script"