#!/usr/bin/bash

npm install -g npm \
&& echo "#################### \
npm已更新 \
####################"

if [ ! -d "/scripts" ] && [ -f "/config/scripts/index.js" ]; then
  ln -s /config/scripts /scripts
  cd /scripts \
  && git pull \
  && echo "#################### \
  拉取git更新完成 \
  ####################"
  npm cache clear --force
  npm install --registry=https://registry.npm.taobao.org
elif [ ! -d "/config/scripts" ]; then
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /config/scripts
  cd /config/scripts
  npm install --registry=https://registry.npm.taobao.org
  echo "#################### \
  git克隆完成 \
  ####################"
  ln -s /config/scripts /scripts \
  && echo "###  创建软链接 /config/scripts /scripts 完成  ###"
fi


if [ -f "/config/${MY_CRONTAB_LIST_FILE}" ]; then
  echo "#################### \
  使用自定义的计划任务 \
  ####################"
  crontab /config/${MY_CRONTAB_LIST_FILE} \
  && crontab -l
else
  echo "#################### \
  使用默认的计划任务 \
  ####################"
  crontab /scripts/docker/crontab_list_ts.sh \
  && crontab -l
fi

crond && echo "###  开启计划任务  ###"

if [ ! -d "/config/logs" ]; then
  mkdir /config/logs
fi
if [ ! -d "/scripts/logs" ]; then
  ln -s /config/logs /scripts/logs \
  && echo "###  创建软链接 /config/logs /scripts/logs 完成  ###"
fi

cd /scripts && node jd_bean_sign.js |ts >> /scripts/logs/jd_bean_sign.log 2>&1 && echo "###  签到测试完成  ###"

tail -f /dev/null
