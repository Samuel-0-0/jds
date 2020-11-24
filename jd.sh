#!/usr/bin/bash

# make our folders and links
mkdir -p /config/scripts
if [ ! -d "/scripts" ]; then \
  mkdir /scripts
fi

ln -s /config/scripts /scripts

echo "User folders done"

if [ -f "/scripts/index.js" ]; then \
  cd /scripts \
  && git pull
else
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /scripts \
  && cd /scripts \
  && npm install
fi

echo "git done"

if [ -f "/config/${CRONTAB_LIST_FILE}" ]; then \
  crontab /config/${CRONTAB_LIST_FILE}
else
  crontab /scripts/docker/crontab_list_ts.sh
fi

crond

cd /scripts
node jd_bean_sign.js

echo "签到测试完成"
