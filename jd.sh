#!/bin/sh
#
# Copyright (C) 2020 luci-app-jd-dailybonus <jerrykuku@qq.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#
version="1.4"
CRON_FILE=/etc/crontabs/root
url=https://raw.githubusercontent.com/lxk0301/scripts/master
dir_file=/usr/share/jd
node=/usr/bin/node
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

update() {
wget $url/jd_xtg.js -O $dir_file/jd_xtg.js 
wget $url/jd_818.js -O $dir_file/jd_818.js 
wget $url/jd_superMarket.js -O $dir_file/jd_superMarket.js 
wget $url/jdSuperMarketShareCodes.js -O $dir_file/jdSuperMarketShareCodes.js 
wget $url/jd_blueCoin.js -O $dir_file/jd_blueCoin.js 
wget $url/jd_redPacket.js -O $dir_file/jd_redPacket.js 
wget $url/jd_moneyTree.js -O $dir_file/jd_moneyTree.js 
wget $url/jd_fruit.js -O $dir_file/jd_fruit.js 
wget $url/jdFruitShareCodes.js -O $dir_file/jdFruitShareCodes.js 
wget $url/jd_pet.js -O $dir_file/jd_pet.js 
wget $url/jdPetShareCodes.js -O $dir_file/jdPetShareCodes.js 
wget $url/jd_plantBean.js -O $dir_file/jd_plantBean.js 
wget $url/jdPlantBeanShareCodes.js -O $dir_file/jdPlantBeanShareCodes.js 
wget $url/jd_shop.js -O $dir_file/jd_shop.js 
wget $url/jd_joy.js -O $dir_file/jd_joy.js 
wget $url/jd_joy_steal.js -O $dir_file/jd_joy_steal.js 
wget $url/jd_joy_feedPets.js -O $dir_file/jd_joy_feedPets.js 
wget $url/jd_joy_reward.js -O $dir_file/jd_joy_reward.js 
wget $url/jd_club_lottery.js -O $dir_file/jd_club_lottery.js 
wget $url/jd_unsubscribe.js -O $dir_file/jd_unsubscribe.js 
sed -i "s/|| 0/|| 20/g" $dir_file/jd_blueCoin.js
}



run_0() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_xtg.js #星推官0点开搞
$node $dir_file/jd_redPacket.js #京东全民开红包，没时间要求
$node $dir_file/jd_moneyTree.js #京东摇钱树，没时间要求
$node $dir_file/jd_club_lottery.js 摇京豆，没时间要求
$node $dir_file/jd_unsubscribe.js 取关店铺，没时间要求
run_06_18
run_01
echo -e "$green脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`$white"
}

run_01() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_joy_feedPets.js #宠汪汪喂食一个小时喂一次
$node $dir_file/jd_joy_reward.js #宠汪汪积分兑换奖品，每日京豆库存会在0:00、8:00、16:00更新，经测试发现中午12:00也会有补发京豆
echo "脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"
}

run_06_18() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_818.js #手机商城 每天0/6/12/18
$node $dir_file/jd_superMarket.js #京小超，没时间要求，跟着手机商城吧
$node $dir_file/jd_blueCoin.js #京小超兑换，没时间要求
$node $dir_file/jd_fruit.js #东东水果，没时间要求，一天可以执行两次
$node $dir_file/jd_plantBean.js #种豆得豆，没时间要求，一天也可以执行两次以上
$node $dir_file/jd_shop.js #进店领豆，早点领，一天也可以执行两次以上
$node $dir_file/jd_joy.js #jd宠汪汪，零点开始，一天也可以执行两次以上
$node $dir_file/jd_pet.js #东东萌宠，跟手机商城同一时间
$node $dir_file/jd_joy_steal.js #可偷好友积分，零点开始，六点再偷一波狗粮
echo "脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"
}

help() {
clear
echo ----------------------------------------------------
echo "	     JD.sh $version 使用说明"
echo ----------------------------------------------------
echo -e "$yellow 1.首次安装依赖$white"
echo "opkg update && opkg install node"
echo "opkg install node-npm"
echo "npm install -g request got tough-cookie"
echo
echo -e "$red node版本一定要大于10$white，安装node以后可以用$green opkg list-installed | grep "node" 查看node版本$whtie"
echo 
echo -e "$yellow 2.下面命令创建脚本文件夹给予权限$white"
echo "mkdir -p $dir_file"
echo "cp $(pwd)/jd.sh  $dir_file/jd.sh && chmod 777 $dir_file/jd.sh"
echo "sh $dir_file/jd.sh update #下载js脚本"
echo "sh $dir_file/jd.sh run_01 #运行跑跑看"
echo
echo -e "$red注意：$white别忘了jdCookie.js  和sendNotify.js也要放进$dir_file，不然会报错"
echo
echo -e "$yellow 3.计划任务可以这么写（自己修改手动复制填到计划任务里去）$white"
echo "30 22 * * * $dir_file/jd.sh update >/tmp/jd_update.log 2>&1"
echo "1 0 * * * $dir_file/jd.sh run_0  >/tmp/jd_run_0.log 2>&1"
echo "10 1-23/1 * * * $dir_file/jd.sh run_01 >/tmp/jd_run_01.log 2>&1"
echo "1 6-18/6 * * * $dir_file/jd.sh run_06_18 >/tmp/jd_run_06_18.log 2>&1"
echo
echo -e "本脚本基于$green x86主机测试$white，一切正常，其他的机器自行测试，满足依赖一般问题不大"
echo ----------------------------------------------------
echo " 		by：ITdesk"
echo ----------------------------------------------------
}

action1="$1"

case "$action1" in
		update)
		update
		;;
		run_0)
		run_0
		;;
		run_01)
		run_01
		;;
		run_06_18)
		run_06_18
		;;
		*)
		help
		;;
esac
