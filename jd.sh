#!/usr/bin/bash

npm install -g npm \
&& echo -e "\n#################### npm已更新 ####################\n"

if [ ! -d "/scripts" ] && [ -f "/config/scripts/index.js" ]; then
  ln -s /config/scripts /scripts
  cd /scripts \
  && git pull \
  && echo -e "\n#################### 拉取git更新完成 ####################\n"
  npm cache clear --force
  npm install --registry=https://registry.npm.taobao.org
fi

if [ ! -d "/config/scripts" ]; then
  git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /config/scripts
  cd /config/scripts
  npm install --registry=https://registry.npm.taobao.org
  echo -e "\n#################### git克隆完成 ####################\n"
  ln -s /config/scripts /scripts \
  && echo -e "\n#####  创建软链接 /config/scripts → /scripts 完成  #####\n"
fi


if [ -f "/config/${MY_CRONTAB_LIST_FILE}" ]; then
  echo -e "\n#################### 使用自定义的计划任务 ####################\n"
  crontab /config/${MY_CRONTAB_LIST_FILE} \
  && crontab -l
else
  echo -e "\n#################### 使用默认的计划任务 ####################\n"
  crontab /scripts/docker/${CRONTAB_LIST_FILE} \
  && crontab -l
fi

crond && echo -e "\n#####  开启计划任务  #####\n"

if [ ! -d "/config/logs" ]; then
  mkdir /config/logs
fi

if [ ! -d "/scripts/logs" ]; then
  ln -s /config/logs /scripts/logs \
  && echo -e "\n#####  创建软链接 /config/logs → /scripts/logs 完成  #####\n"
fi

cd /scripts && node jd_bean_sign.js |ts >> /scripts/logs/jd_bean_sign.log 2>&1 \
&& echo -e "\n#####  签到测试完成  #####\n"

tail -f /dev/null
