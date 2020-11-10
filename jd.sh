#!/bin/sh
#
# Copyright (C) 2020 luci-app-jd-dailybonus <jerrykuku@qq.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#
version="1.5"
CRON_FILE=/etc/crontabs/root
url=https://raw.githubusercontent.com/lxk0301/jd_scripts/master
dir_file=/usr/share/JD_Script
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
wget $url/jd_collectProduceScore.js -O $dir_file/jd_collectProduceScore.js
wget $url/jd_lotteryMachine.js -O $dir_file/jd_lotteryMachine.js
wget $url/jd_rankingList.js -O $dir_file/jd_rankingList.js
wget $url/jd_speed.js -O $dir_file/jd_speed.js
#wget $url/jd_dreamFactory.js -O $dir_file/jd_dreamFactory.js 京东京喜工厂未完成
sed -i "s/|| 0/|| 20/g" $dir_file/jd_blueCoin.js
sed -i "s/|| 20/|| 50/g" $dir_file/jd_unsubscribe.js
}

update_script() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
cd $dir_file && git pull
echo -e "$green脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`$white"
}


run_0() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_xtg.js #星推官0点开搞
$node $dir_file/jd_redPacket.js #京东全民开红包，没时间要求
$node $dir_file/jd_moneyTree.js #京东摇钱树，没时间要求
$node $dir_file/jd_club_lottery.js #摇京豆，没时间要求
$node $dir_file/jd_unsubscribe.js #取关店铺，没时间要求
$node $dir_file/jd_lotteryMachine.js #京东抽奖机
$node $dir_file/jd_rankingList.js #京东排行榜签到领京豆
$node $dir_file/jd_blueCoin.js #京小超兑换，有次数限制，没时间要求
$node $dir_file/jd_joy_reward.js #宠汪汪积分兑换奖品，有次数限制，每日京豆库存会在0:00、8:00、16:00更新，经测试发现中午12:00也会有补发京豆
run_10_15_20
run_06_18
run_01
echo -e "$green脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`$white"
}

run_01() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_joy_feedPets.js #宠汪汪喂食一个小时喂一次
$node $dir_file/jd_collectProduceScore.js #京东全民营业一个小时领金币
#$node $dir_file/jd_dreamFactory.js 京东京喜工厂未完成
echo "脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"
}

run_06_18() {
echo "开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`"
$node $dir_file/jd_818.js #手机商城 每天0/6/12/18
$node $dir_file/jd_fruit.js #东东水果，没时间要求，一天可以执行两次
$node $dir_file/jd_plantBean.js #种豆得豆，没时间要求，一天也可以执行两次以上
$node $dir_file/jd_shop.js #进店领豆，早点领，一天也可以执行两次以上
$node $dir_file/jd_joy.js #jd宠汪汪，零点开始，一天也可以执行两次以上
$node $dir_file/jd_pet.js #东东萌宠，跟手机商城同一时间
$node $dir_file/jd_joy_steal.js #可偷好友积分，零点开始，六点再偷一波狗粮
echo "脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"
}

run_10_15_20() {
$node $dir_file/jd_superMarket.js #京小超,0 10 15 20四场补货加劵
}

help() {
clear
echo ----------------------------------------------------
echo "	     JD.sh $version 使用说明"
echo ----------------------------------------------------
echo -e "$yellow 1.文件说明$white"
echo -e "$green jdCookie.js $white 在此脚本内填写JD Cookie 脚本内有说明"
echo -e "$green sendNotify.js $white 在此脚本内填写推送服务的KEY，也可以不填"
echo -e "$green jd.sh $white JD_Script的本体（作用就是帮忙下载js脚本，js脚本是核心）"
echo ""
echo -e "$yellow JS脚本作用请查询：https://github.com/lxk0301/scripts $white"
echo ""
echo -e "$yellow 2.jd.sh脚本命令$white"
echo -e "$green sh \$jd.sh update #下载js脚本 $yellow#第一次安装运行这个，然后运行$green sh \$jd.sh run_0 $white$white"
echo -e "$green sh \$jd.sh update_script $white #更新JD_Script"
echo -e "$green sh \$jd.sh run_0 $white #运行run_0模块里的命令"
echo -e "$green sh \$jd.sh run_01 $white #运行run_01模块里的命令"
echo -e "$green sh \$jd.sh run_06_18 $white #运行run_06_18模块里的命令"
echo -e "$green sh \$jd.sh run_10_15_20 $white #运行run_10_15_20模块里的命令"
echo ""
echo " 如果不喜欢这样，你也可以直接cd $jd_file,然后用node 脚本名字.js "
echo ""
echo -e "$yellow 3.计划任务可以这么写（自己修改手动复制填到计划任务里去）$white"
echo " 00 22 * * * $jd update_script >/tmp/jd_update_script.log 2>&1"
echo " 30 22 * * * $jd update >/tmp/jd_update.log 2>&1"
echo " 1 0 * * * $jd run_0  >/tmp/jd_run_0.log 2>&1"
echo " 10 2-23/1 * * * $jd run_01 >/tmp/jd_run_01.log 2>&1"
echo " 1 6-18/6 * * * $jd run_06_18 >/tmp/jd_run_06_18.log 2>&1"
echo " 5 10,15,20 * * * $jd run_10_15_20 >/tmp/jd_run_10_15_20.log 2>&1"
echo
echo -e "$yellow 4.JD_Script报错你可以反馈到这里：https://github.com/ITdesk01/JD_Script/issues (描述清楚问题或者上图片，不然可能没有人理)$white"
echo ""
echo -e "本脚本基于$green x86主机测试$white，一切正常，其他的机器自行测试，满足依赖一般问题不大"
echo ----------------------------------------------------
echo " 		by：ITdesk"
echo ----------------------------------------------------
}

description_if() {
	if [[ ! -d "$dir_file" ]]; then
		cp -r $(pwd)  $dir_file && chmod 777 $dir_file/jd.sh
	fi
	
	if [[ -f "/usr/share/JD_Script/jdCookie.js" ]]; then
		echo "jdCookie.js存在"
	else 
		wget $url/jdCookie.js -O $dir_file/jdCookie.js 
		wget $url/sendNotify.js -O $dir_file/sendNotify.js	
	fi
	#添加系统变量
	openwrt_script_path=$(cat /etc/profile | grep -o jd.sh | wc -l)
	if [[ "$jd_script_path" == "0" ]]; then
		echo "export jd_file=/usr/share/JD_Script" |  tee -a /etc/profile
		echo "export jd=/usr/share/JD_Script/jd.sh" |  tee -a /etc/profile
		echo "-----------------------------------------------------------------------"
		echo ""
		echo -e "$green添加jd变量成功,重启系统以后无论在那个目录输入 bash \$jd 都可以运行脚本$white"
		echo ""
		echo ""
		echo -e "                    $green回车重启你的操作系统!!!$white"
		echo "-----------------------------------------------------------------------"
		read a
		reboot	
	else
			echo "变量已经添加"
	fi
	help
}

action1="$1"
if [[ -z $action1 ]]; then
	description_if
else
	case "$action1" in
			update)
			update
			;;
			update_script)
			update_script
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
fi
