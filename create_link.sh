#!/usr/bin/env bash
if [[ -L /opt/sqoop ]]; then 
  rm -f /opt/sqoop
fi
ln -s "/opt/sqoop-$1" /opt/sqoop
