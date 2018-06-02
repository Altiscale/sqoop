#!/usr/bin/env bash
docker container run --mount type=bind,source="$(pwd)",target=/root -e ALTISCALE_RELEASE=$ALTISCALE_RELEASE -e PACKAGE_NAME=$PACKAGE_NAME -e SQOOP_VERSION=$SQOOP_VERSION sqoop_base_1_7:1.2 sh build_rpm.sh
