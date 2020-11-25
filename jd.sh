#!/usr/bin/bash

if [ -f "/scripts/index.js" ]; then
  cd /scripts \
  && git pull \
  && npm install || npm install --registry=https://registry.npm.taobao.org \
  && echo "pull done"
else
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /scripts \
  && cd /scripts \
  && npm install || npm install --registry=https://registry.npm.taobao.org \
  && echo "new clone done"
fi
cd ..
echo "git done"

mv /scripts /config/scripts

# make our folders and links
ln -s /config/scripts /scripts

if [ -f "/config/${CRONTAB_LIST_FILE}" ]; then
  crontab /config/${CRONTAB_LIST_FILE} \
  && crontab -l
else
  crontab /scripts/docker/crontab_list_ts.sh \
  && crontab -l
fi

crond && echo "crond done"

mkdir /config/logs
ln -s /config/logs /scripts/logs

cd /scripts && node jd_bean_sign.js |ts >> /scripts/logs/jd_bean_sign.log 2>&1 && echo "签到测试完成"

tail -f /dev/null
