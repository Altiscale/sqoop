#!/usr/bin/env bash
docker container run --mount type=bind,source="$(pwd)",target=/root sqoop_base_1_7:1.2 sh build_rpm.sh
