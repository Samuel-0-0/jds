#!/usr/bin/bash

npm install -g npm && echo "npm updated"

if [ ! -d "/scripts" ] && [ -f "/config/scripts/index.js" ]; then
  ln -s /config/scripts /scripts
  cd /scripts \
  && git pull \
  && echo " pull done "
  npm cache clear --force
  npm install --registry=https://registry.npm.taobao.org
elif [ ! -d "/config/scripts" ]; then
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /config/scripts
  cd /config/scripts
  npm install --registry=https://registry.npm.taobao.org
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

if [ ! -d "/scripts/logs" ] && [ ! -d "/config/logs" ]; then
  mkdir /config/logs \
  && ln -s /config/logs /scripts/logs \
  && echo "links /config/logs /scripts/logs done"
elif [ ! -d "/scripts/logs" ] && [ -d "/config/logs" ]; then
  ln -s /config/logs /scripts/logs \
  && echo "links /config/logs /scripts/logs done"
fi

cd /scripts && node jd_bean_sign.js |ts >> /scripts/logs/jd_bean_sign.log 2>&1 && echo "\n 签到测试完成 \n"

tail -f /dev/null
