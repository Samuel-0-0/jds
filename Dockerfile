FROM node:slim

MAINTAINER Samuel Wang <imhsaw@gmail.com>

RUN apk update && apk upgrade\
    && apk add --no-cache tzdata moreutils git\
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

# 互助码用@分割不要用&

ENV JD_COOKIE=""\
    PUSH_KEY=""\
    BARK_PUSH=""\
    BARK_SOUND=""\
    TG_BOT_TOKEN=""\
    TG_USER_ID=""\
    DD_BOT_TOKEN=""\
    DD_BOT_SECRET=""\
    PET_NOTIFY_CONTROL=true\
    FRUIT_NOTIFY_CONTROL=true\
    JD_JOY_REWARD_NOTIFY=false\
    MARKET_REWARD_NOTIFY=false\
    JOY_FEED_COUNT=20\
    JOY_RUN_FLAG=false\
    JOY_HELP_FEED=false\
    MARKET_COIN_TO_BEANS=20\
    SUPERMARKET_UPGRADE=false\
    BUSINESS_CIRCLE_JUMP=false\
    SUPERMARKET_LOTTERY=false\
    FRUIT_BEAN_CARD=false\
    FRUITSHARECODES=""\
    PETSHARECODES=""\
    PLANT_BEAN_SHARECODES=""\
    SUPERMARKET_SHARECODES=""\

WORKDIR /scripts
COPY jd.sh /jd.sh
RUN bash /jd.sh
CMD crontab -l && cron -f
