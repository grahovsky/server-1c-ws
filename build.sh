#!/bin/bash

docker build --tag grahovsky/server-1c-ws:8.3.18.1698 \
    --build-arg ONEC_VERSION='8.3.18.1698' \
    $1 -- .
