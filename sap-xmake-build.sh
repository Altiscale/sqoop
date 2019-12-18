#!/bin/bash -l

# find this script and establish base directory
SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
cd "$SCRIPT_DIR" &> /dev/null
MY_DIR="$(pwd)"
echo "[INFO] Executing in ${MY_DIR}"

# PATH does not contain ant in this login shell
export M2_HOME=/opt/mvn3
export JAVA_HOME=/opt/sapjvm_7
export PATH=$M2_HOME/bin:$JAVA_HOME/bin:/opt/apache-ant/bin:$PATH

curl -s 'https://issues.apache.org/jira/si/jira.issueviews:issue-xml/SQOOP-3149/SQOOP-3149.xml?field=key&field=type&field=parent'

pip install -i http://nexus.wdf.sap.corp:8081/nexus/content/groups/build.releases.pypi/simple/ --trusted-host nexus.wdf.sap.corp elementpath

#------------------------------------------------------------------------------
#
#  ***** compile and package pig *****
#
#------------------------------------------------------------------------------

SQOOP_VERSION="${SQOOP_VERSION:-${XMAKE_PROJECT_VERSION}}"
export ARTIFACT_VERSION="$SQOOP_VERSION"

ant -Dhadoopversion=200 -Dskip-real-docs=true -Dbin.artifact.name=sqoop-${ARTIFACT_VERSION} clean tar

#------------------------------------------------------------------------------
#
#  ***** setup the environment generating RPM via fpm *****
#
#------------------------------------------------------------------------------

ALTISCALE_RELEASE="${ALTISCALE_RELEASE:-5.0.0}"
DATE_STRING=`date +%Y%m%d%H%M%S`
GIT_REPO="https://github.com/Altiscale/sqoop"

INSTALL_DIR="$MY_DIR/sqooprpmbuild"
mkdir --mode=0755 -p ${INSTALL_DIR}

export RPM_NAME=`echo alti-sqoop-${ARTIFACT_VERSION}`
export RPM_DESCRIPTION="Apache Sqoop ${ARTIFACT_VERSION}\n\n${DESCRIPTION}"
export RPM_DIR="${RPM_DIR:-"${INSTALL_DIR}/sqoop-artifact/"}"
mkdir --mode=0755 -p ${RPM_DIR}

echo "Packaging sqoop rpm with name ${RPM_NAME} with version ${ALTISCALE_RELEASE}-${DATE_STRING}"

export RPM_BUILD_DIR=${INSTALL_DIR}/opt
mkdir --mode=0755 -p ${RPM_BUILD_DIR}

export RPM_CONFIG_DIR=${INSTALL_DIR}/etc/sqoop-${ARTIFACT_VERSION}
mkdir --mode=0755 -p ${RPM_CONFIG_DIR}

cd ${RPM_BUILD_DIR}
tar -xvzpf ${MY_DIR}/build/sqoop-${ARTIFACT_VERSION}.tar.gz

cd ${RPM_DIR}
fpm --verbose \
--maintainer ops@verticloud.com \
--vendor Altiscale \
--provides ${RPM_NAME} \
--description "${DESCRIPTION}" \
--replaces vcc-sqoop-${ARTIFACT_VERSION} \
--replaces vcc-sqoop \
--license "Apache License v2" \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${ALTISCALE_RELEASE} \
--iteration ${DATE_STRING} \
--rpm-user root \
--rpm-group root \
-C ${INSTALL_DIR} \
opt etc

mv "${RPM_DIR}${RPM_NAME}-${ALTISCALE_RELEASE}-${DATE_STRING}.x86_64.rpm" "${RPM_DIR}alti-sqoop-${XMAKE_PROJECT_VERSION}.rpm"

exit 0