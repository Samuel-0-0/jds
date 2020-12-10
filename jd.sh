#!/usr/bin/bash

echo -e "\n#################### 开始npm更新 ####################\n"
npm install -g npm \
&& echo -e "\n#################### npm更新完成 ####################\n" \
|| echo -e "\n#################### npm更新出错 ####################\n"

if [[ ! -d "/scripts" ]] && [[ -f "/config/scripts/index.js" ]]; then
  ln -s /config/scripts /scripts
  cd /scripts
  echo -e "\n#################### 开始拉取git更新 ####################\n" \
  && git pull \
  && echo -e "\n#################### 拉取git更新完成 ####################\n" \
  || echo -e "\n#################### 拉取git更新出错 ####################\n" \
  && echo -e "\n#################### 脚本已停止 ####################" && exit 1
  npm cache clear --force
  npm install --registry=https://registry.npm.taobao.org
fi

if [[ -d "/config/scripts" ]] && [[ ! -f "/config/scripts/index.js" ]]; then
  rm -rf /config/scripts \
  && echo -e "\n#################### 文件夹有问题删除重建 ####################\n"
fi

if [[ ! -d "/config/scripts" ]]; then
  echo -e "\n#################### 开始git克隆 ####################\n"
  git clone -b master --depth=1 https://github.com/lxk0301/jd_scripts.git /config/scripts \
  && echo -e "\n#################### git克隆完成 ####################\n" \
  || echo -e "\n#################### git克隆出错 ####################\n" \
  && echo -e "\n#################### 脚本已停止 ####################" && exit 1
  cd /config/scripts
  echo -e "\n#################### 安装JD脚本 ####################\n" \
  && npm install --registry=https://registry.npm.taobao.org \
  && echo -e "\n#################### 安装JD脚本完成 ####################\n" \
  || echo -e "\n#################### 安装JD脚本失败 ####################\n" \
  && echo -e "\n#################### 脚本已停止 ####################" && exit 1
  echo -e "\n#####  创建软链接 /config/scripts → /scripts  #####\n" \
  && ln -s /config/scripts /scripts \
  || echo -e "\n#################### 创建软链接失败 ####################\n" \
  && echo -e "\n#################### 脚本已停止 ####################" && exit 1
fi


if [[ -f "/config/${MY_CRONTAB_LIST_FILE}" ]]; then
  echo -e "\n#################### 使用自定义的计划任务 ####################\n"
  crontab /config/${MY_CRONTAB_LIST_FILE} \
  && crontab -l
else
  echo -e "\n#################### 使用默认的计划任务 ####################\n"
  crontab /scripts/docker/${CRONTAB_LIST_FILE} \
  && crontab -l
fi

crond && echo -e "\n####################  成功开启计划任务  ####################\n" \
|| echo -e "\n#################### 开启计划任务失败 ####################\n" \
&& echo -e "\n#################### 脚本已停止 ####################" && exit 1

if [[ ! -d "/config/logs" ]]; then
  mkdir /config/logs
fi

if [[ ! -d "/scripts/logs" ]]; then
  echo -e "\n#####  创建软链接 /config/logs → /scripts/logs  #####\n" \
  ln -s /config/logs /scripts/logs \
  || echo -e "\n#################### 创建软链接失败 ####################\n" \
  && echo -e "\n#################### 脚本已停止 ####################" && exit 1
fi

echo -e "\n####################  开始签到测试  ####################\n"
cd /scripts && node jd_bean_sign.js \
&& echo -e "\n####################  签到测试完成  ####################\n"

tail -f /dev/null
