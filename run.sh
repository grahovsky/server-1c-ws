#!/bin/sh
docker rm -f server-1c 2> /dev/null
docker volume rm  1c-server-home 1c-server-logs 2> /dev/null

docker run --name server-1c \
  -it \
  --detach \
  --net my_app_net \
  -p 1540-1541:1540-1541 \
  -p 1560-1591:1560-1591 \
  -p 1545:1545 \
  --privileged \
  --volume server-1c-logs:/var/log/1c \
  grahovsky/server-1c-ws:latest
