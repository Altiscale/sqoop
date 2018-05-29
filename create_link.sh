#!/usr/bin/env bash
if [[ -L /opt/sqoop ]]; then 
  rm /opt/sqoop
fi
ln -s /opt/sqoop-1.4.7 /opt/sqoop
