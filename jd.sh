#!/bin/bash

git clone --depth=1 https://github.com/lxk0301/jd_scripts.git /scripts_tmp
[ -d /scripts_tmp ] && {
  rm -rf /jd/scripts
  mv /scripts_tmp /jd/scripts
}

cd /jd/scripts || exit 1
npm install || npm install --registry=https://registry.npm.taobao.org || exit 1

[ -f /jd/my_crontab.list ] && {
  crontab -r
  crontab /jd/my_crontab.list || {
    cp /jd/scripts/docker/crontab_list_ts.sh /jd/my_crontab.list
    crontab /jd/my_crontab.list
  }
  crontab -l
}
