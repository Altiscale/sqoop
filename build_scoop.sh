#!/bin/sh -ex
docker container run --mount type=bind,source="$(pwd)",target=/root sqoop_base_1_7:1.2 ant tar
