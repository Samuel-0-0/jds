#!/usr/bin/bash

# make our folders and links
if [ ! -d "/config/scripts" ]; then
  mkdir -p /config/scripts
  echo "mkdir -p /config/scripts"
fi

if [ ! -d "/scripts" ]; then
  mkdir /scripts
  echo "mkdir /scripts"
fi

ln -s /config/scripts /scripts

echo "User folders done"

if [ -f "/scripts/index.js" ]; then
  cd /scripts
  git pull
  npm install --registry=https://registry.npm.taobao.org
  echo "pull done"
else
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /scripts  && cd /scripts \
  npm install --registry=https://registry.npm.taobao.org
  echo "new clone done"
fi

if [ -f "/config/${CRONTAB_LIST_FILE}" ]; then
  crontab /config/${CRONTAB_LIST_FILE}
  crontab -l
else
  crontab /scripts/docker/crontab_list_ts.sh
  crontab -l
fi

crond

cd /scripts
node jd_bean_sign.js

echo "签到测试完成"

tail -f /dev/null
