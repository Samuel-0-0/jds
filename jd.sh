#!/usr/bin/bash

if [ -f "/scripts/index.js" ]; then
  cd /scripts \
  && git pull \
  && echo "\n pull done \n"
  npm install || npm install --registry=https://registry.npm.taobao.org
else
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /config/scripts
  cd /config/scripts
  npm install || npm install --registry=https://registry.npm.taobao.org
  echo "\n new clone done \n"
  ln -s /config/scripts /scripts \
  && echo "links /config/scripts /scripts done"
fi

echo "git done"

if [ -f "/config/${CRONTAB_LIST_FILE}" ]; then
  crontab /config/${CRONTAB_LIST_FILE} \
  && crontab -l
else
  crontab /scripts/docker/crontab_list_ts.sh \
  && crontab -l
fi

crond && echo "\n crond done \n"

mkdir /config/logs \
&& ln -s /config/logs /scripts/logs \
&& echo "links /config/logs /scripts/logs done"

cd /scripts && node jd_bean_sign.js |ts >> /scripts/logs/jd_bean_sign.log 2>&1 && echo "\n 签到测试完成 \n"

tail -f /dev/null
