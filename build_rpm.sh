#!/usr/bin/env bash

# 1. build sources
ant tar

# rename target directory
mv ./build/sqoop-1.4.7.bin__hadoop-2.6.0 ./build/sqoop-1.4.7

# delete shell scripts that have been copied in build
rm ./build/sqoop-1.4.7/build_scoop.sh ./build/sqoop-1.4.7/build_rpm.sh ./build/sqoop-1.4.7/launch_docker_build_rpm.sh

# delete rpm if exists
if [ -f ./alti-sqoop-1.4.7-1.x86_64.rpm ]; then
	rm ./alti-sqoop-1.4.7-1.x86_64.rpm
fi

# 2. build rpm
fpm --verbose --maintainer support@altiscale.com --vendor Altiscale --provides alti-sqoop -n alti-sqoop -v 1.4.7 --license "Apache License v2" --after-install create_link.sh -s dir -t rpm ./build/sqoop-1.4.7=/opt
