#!/usr/bin/env bash

# 1. build sources
ant tar

# rename target directory
mv ./build/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0 ./build/sqoop-${SQOOP_VERSION}

# delete shell scripts that have been copied in build
rm ./build/sqoop-${SQOOP_VERSION}/build_scoop.sh ./build/sqoop-${SQOOP_VERSION}/build_rpm.sh ./build/sqoop-${SQOOP_VERSION}/launch_docker_build_rpm.sh

# delete rpm if exists
if [ -f ./alti-sqoop-${SQOOP_VERSION}.x86_64.rpm ]; then
	rm ./alti-sqoop-${SQOOP_VERSION}.x86_64.rpm
fi

export DATE_STRING=$(date "+%Y%m%d%H%M")

# 2. build rpm
fpm --verbose --maintainer support@altiscale.com --vendor Altiscale --provides alti-sqoop-${SQOOP_VERSION} -n alti-sqoop-${SQOOP_VERSION} -v ${ALTISCALE_RELEASE} --iteration ${DATE_STRING} --license "Apache License v2" --after-install create_link.sh -s dir -t rpm ./build/sqoop-${SQOOP_VERSION}=/opt
