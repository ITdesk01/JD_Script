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
dir_file_js=/usr/share/JD_Script/js
node=/usr/bin/node
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

start_script="echo -e "$green开始运行脚本，当前时间：`date "+%Y-%m-%d %H:%M"`$white""
stop_script="echo -e "$green脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`$white""



update() {
rm -rf $dir_file_js/jd_xtg.js
rm -rf $dir_file_js/jd_818.js
wget $url/jd_superMarket.js -O $dir_file_js/jd_superMarket.js 
wget $url/jdSuperMarketShareCodes.js -O $dir_file_js/jdSuperMarketShareCodes.js 
wget $url/jd_blueCoin.js -O $dir_file_js/jd_blueCoin.js 
wget $url/jd_redPacket.js -O $dir_file_js/jd_redPacket.js 
wget $url/jd_moneyTree.js -O $dir_file_js/jd_moneyTree.js 
wget $url/jd_fruit.js -O $dir_file_js/jd_fruit.js 
wget $url/jdFruitShareCodes.js -O $dir_file_js/jdFruitShareCodes.js 
wget $url/jd_pet.js -O $dir_file_js/jd_pet.js 
wget $url/jdPetShareCodes.js -O $dir_file_js/jdPetShareCodes.js 
wget $url/jd_plantBean.js -O $dir_file_js/jd_plantBean.js 
wget $url/jdPlantBeanShareCodes.js -O $dir_file_js/jdPlantBeanShareCodes.js 
wget $url/jd_shop.js -O $dir_file_js/jd_shop.js 
wget $url/jd_joy.js -O $dir_file_js/jd_joy.js 
wget $url/jd_joy_steal.js -O $dir_file_js/jd_joy_steal.js 
wget $url/jd_joy_feedPets.js -O $dir_file_js/jd_joy_feedPets.js 
wget $url/jd_joy_reward.js -O $dir_file_js/jd_joy_reward.js 
wget $url/jd_club_lottery.js -O $dir_file_js/jd_club_lottery.js 
wget $url/jd_unsubscribe.js -O $dir_file_js/jd_unsubscribe.js 
rm -rf $dir_file_js/jd_collectProduceScore.js
wget $url/jd_lotteryMachine.js -O $dir_file_js/jd_lotteryMachine.js
wget $url/jd_rankingList.js -O $dir_file_js/jd_rankingList.js
wget $url/jd_speed.js -O $dir_file_js/jd_speed.js
#wget $url/jd_dreamFactory.js -O $dir_file_js/jd_dreamFactory.js 京东京喜工厂未完成
wget $url/jd_daily_egg.js -O $dir_file_js/jd_daily_egg.js
wget $url/jd_pigPet.js -O $dir_file_js/jd_pigPet.js

sed -i "s/|| 0/|| 20/g" $dir_file_js/jd_blueCoin.js
sed -i "s/|| 20/|| 50/g" $dir_file_js/jd_unsubscribe.js

#水果
old_fruit1="0a74407df5df4fa99672a037eec61f7e@dbb21614667246fabcfd9685b6f448f3@6fbd26cc27ac44d6a7fed34092453f77@61ff5c624949454aa88561f2cd721bf6"
old_fruit2="b1638a774d054a05a30a17d3b4d364b8@f92cb56c6a1349f5a35f0372aa041ea0@9c52670d52ad4e1a812f894563c746ea@8175509d82504e96828afc8b1bbb9cb3"
old_fruit3="6fbd26cc27ac44d6a7fed34092453f77@61ff5c624949454aa88561f2cd721bf6@9c52670d52ad4e1a812f894563c746ea@8175509d82504e96828afc8b1bbb9cb3"
new_fruit="6632c8135d5c4e2c9ad7f4aa964d4d11@31a2097b10db48429013103077f2f037@5aa64e466c0e43a98cbfbbafcc3ecd02@9046fbd8945f48cb8e36a17fff9b0983@d4e3080b06ed47d884e4ef9852cad568@72abb03ca91a4569933c6c8a62a5622c@ed2b2d28151a482eae49dff2e5a588f8@304b39f17d6c4dac87933882d4dec6bc@3e6f0b7a2d054331a0b5b956f36645a9@5e54362c4a294f66853d14e777584598"
sed -i "s/$old_fruit1/$new_fruit/g" $dir_file_js/jd_fruit.js
sed -i "s/$old_fruit2/$new_fruit/g" $dir_file_js/jd_fruit.js
sed -i "s/$old_fruit1/$new_fruit/g" $dir_file_js/jdFruitShareCodes.js
sed -i "s/$old_fruit3/$new_fruit/g" $dir_file_js/jdFruitShareCodes.js
sed -i "s/randomCount = 20/randomCount = 0/g" $dir_file_js/jd_fruit.js


#萌宠
old_pet1="MTAxODc2NTEzNTAwMDAwMDAwMjg3MDg2MA==@MTAxODc2NTEzMzAwMDAwMDAyNzUwMDA4MQ==@MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODc2NTEzNDAwMDAwMDAzMDI2MDI4MQ==@MTAxODcxOTI2NTAwMDAwMDAxOTQ3MjkzMw=="
old_pet2="MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODcxOTI2NTAwMDAwMDAyNjA4ODQyMQ==@MTAxODc2NTEzOTAwMDAwMDAyNzE2MDY2NQ=="
old_pet3="MTAxODc2NTEzNTAwMDAwMDAwMjg3MDg2MA==@MTAxODc2NTEzMzAwMDAwMDAyNzUwMDA4MQ==@MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODc2NTEzNDAwMDAwMDAzMDI2MDI4MQ=="
new_pet="MTE1NDAxNzcwMDAwMDAwMzk1OTQ4Njk==@MTE1NDQ5OTUwMDAwMDAwMzk3NDgyMDE==@MTAxODEyOTI4MDAwMDAwMDQwMTIzMzcx==@MTEzMzI0OTE0NTAwMDAwMDAzOTk5ODU1MQ==@MTAxODc2NTEzMzAwMDAwMDAxOTkzMzM1MQ==@MTAxODEyOTI4MDAwMDAwMDM5NzM3Mjk5==@MTAxODc2NTEzMDAwMDAwMDAxOTcyMTM3Mw==@MTE1NDQ5MzYwMDAwMDAwMzk2NTY2MTE==@MTE1NDQ5OTUwMDAwMDAwMzk2NTY2MTk==@MTE1NDQ5OTUwMDAwMDAwNDAyNTYyMjM=="
sed -i "s/$old_pet1/$new_pet/g" $dir_file_js/jd_pet.js
sed -i "s/$old_pet2/$new_pet/g" $dir_file_js/jd_pet.js
sed -i "s/$old_pet2/$new_pet/g" $dir_file_js/jdPetShareCodes.js
sed -i "s/$old_pet3/$new_pet/g" $dir_file_js/jdPetShareCodes.js
sed -i "s/randomCount = 20/randomCount = 0/g" $dir_file_js/jd_pet.js

#种豆
old_plantBean1="66j4yt3ebl5ierjljoszp7e4izzbzaqhi5k2unz2afwlyqsgnasq@olmijoxgmjutyrsovl2xalt2tbtfmg6sqldcb3q@e7lhibzb3zek27amgsvywffxx7hxgtzstrk2lba@e7lhibzb3zek32e72n4xesxmgc2m76eju62zk3y"
old_plantBean2="4npkonnsy7xi3p6pjfxg6ct5gll42gmvnz7zgoy@6dygkptofggtp6ffhbowku3xgu@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy"
old_plantBean3="66j4yt3ebl5ierjljoszp7e4izzbzaqhi5k2unz2afwlyqsgnasq@olmijoxgmjutyrsovl2xalt2tbtfmg6sqldcb3q@e7lhibzb3zek27amgsvywffxx7hxgtzstrk2lba"
old_plantBean4="4npkonnsy7xi3p6pjfxg6ct5gll42gmvnz7zgoy@6dygkptofggtp6ffhbowku3xgu@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy"
new_plantBean="4npkonnsy7xi3n46rivf5vyrszud7yvj7hcdr5a@mlrdw3aw26j3xeqso5asaq6zechwcl76uojnpha@nkvdrkoit5o65lgaousaj4dqrfmnij2zyntizsa@3wmn5ktjfo7ukgaymbrakyuqry3h7wlwy7o5jii@olmijoxgmjutyy7u5s57pouxi5teo3r4r2mt36i@chcdw36mwfu6bh72u7gtvev6em@olmijoxgmjutzh77gykzjkyd6zwvkvm6oszb5ni@4npkonnsy7xi3smz2qmjorpg6ldw5otnabrmlei@e7lhibzb3zek2zin4gnao3gynqwqgrzjyopvbua@e7lhibzb3zek234ckc2fm2yvkj5cbsdpe7y6p2a"
sed -i "s/$old_plantBean1/$new_plantBean/g" $dir_file_js/jd_plantBean.js
sed -i "s/$old_plantBean2/$new_plantBean/g" $dir_file_js/jd_plantBean.js
sed -i "s/$old_plantBean3/$new_plantBean/g" $dir_file_js/jdPlantBeanShareCodes.js
sed -i "s/$old_plantBean4/$new_plantBean/g" $dir_file_js/jdPlantBeanShareCodes.js
sed -i "s/randomCount = 20/randomCount = 0/g" $dir_file_js/jd_plantBean.js

}

update_script() {
$start_script
cd $dir_file && git pull
$stop_script
}


run_0() {
$start_script
$node $dir_file_js/jd_redPacket.js #京东全民开红包，没时间要求
$node $dir_file_js/jd_moneyTree.js #京东摇钱树，没时间要求
$node $dir_file_js/jd_club_lottery.js #摇京豆，没时间要求
$node $dir_file_js/jd_lotteryMachine.js #京东抽奖机
$node $dir_file_js/jd_rankingList.js #京东排行榜签到领京豆
$node $dir_file_js/jd_blueCoin.js #京小超兑换，有次数限制，没时间要求
$node $dir_file_js/jd_joy_reward.js #宠汪汪积分兑换奖品，有次数限制，每日京豆库存会在0:00、8:00、16:00更新，经测试发现中午12:00也会有补发京豆
run_10_15_20
run_06_18
run_01
run_03
$node $dir_file_js/jd_daily_egg.js #天天提鹅蛋，需要有金融app，没有顶多报错问题不大
$node $dir_file_js/jd_pigPet.js #金融养猪，需要有金融app，没有顶多报错问题不大
$node $dir_file_js/jd_unsubscribe.js #取关店铺，没时间要求
$stop_script
}

run_01() {
$start_script
$node $dir_file_js/jd_joy_feedPets.js #宠汪汪喂食一个小时喂一次
#$node $dir_file_js/jd_dreamFactory.js 京东京喜工厂未完成
$stop_script
}

run_02() {
$start_script
$node $dir_file_js/jd_plantBean.js #种豆得豆，没时间要求，三个小时收一次瓶子
$stop_script
}

run_06_18() {
$start_script
$node $dir_file_js/jd_fruit.js #东东水果，6-9点 11-14点 17-21点可以领水滴
$node $dir_file_js/jd_shop.js #进店领豆，早点领，一天也可以执行两次以上
$node $dir_file_js/jd_joy.js #jd宠汪汪，零点开始，11.30-15:00 17-21点可以领狗粮
$node $dir_file_js/jd_pet.js #东东萌宠，跟手机商城同一时间
$node $dir_file_js/jd_joy_steal.js #可偷好友积分，零点开始，六点再偷一波狗粮
$stop_script
}

run_10_15_20() {
$start_script
$node $dir_file_js/jd_superMarket.js #京小超,0 10 15 20四场补货加劵
$stop_script
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
echo -e "$yellow JS脚本作用请查询：https://github.com/lxk0301/jd_scripts $white"
echo ""
echo -e "$yellow 2.jd.sh脚本命令$white"
echo -e "$green sh \$jd update #下载js脚本"
echo -e "$green sh \$jd update_script $white #更新JD_Script "
echo -e "$green sh \$jd run_0 $white         #运行run_0模块里的命令 $yellow#第一次安装完成运行这句，前提你把jdCookie.js填完整$white"
echo -e "$green sh \$jd run_01 $white        #运行run_01模块里的命令 "
echo -e "$green sh \$jd run_02 $white        #运行run_02模块里的命令"
echo -e "$green sh \$jd run_06_18 $white     #运行run_06_18模块里的命令"
echo -e "$green sh \$jd run_10_15_20 $white  #运行run_10_15_20模块里的命令"
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
echo " 40 2-22/2 * * * $jd run_02 >/tmp/jd_run_02.log 2>&1"
echo
echo "检测脚本是否最新： $Script_status "
echo ""
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
	
	if [[ ! -d "$dir_file/js" ]]; then
		echo -e "$green开始下载JS脚本，请稍等$white"
		mkdir -p $dir_file/js
		update
	fi
	
	if [[ -f "/usr/share/JD_Script/jdCookie.js" ]]; then
		echo "jdCookie.js存在"
	else 
		wget $url/jdCookie.js -O $dir_file/jdCookie.js
		ln -s $dir_file/jdCookie.js $dir_file_js/jdCookie.js
	fi

	if [[ -f "/usr/share/JD_Script/sendNotify.js" ]]; then
		echo "sendNotify.js存在"
	else
		wget $url/sendNotify.js -O $dir_file/sendNotify.js	
		ln -s $dir_file/sendNotify.js $dir_file_js/sendNotify.js
	fi

	echo "稍等一下，正在取回远端脚本源码，用于比较现在脚本源码，速度看你网络"
	cd $dir_file_js
	git fetch
	if [[ $? -eq 0 ]]; then
		echo ""
	else
		echo -e "$red>> 取回分支没有成功，重新执行代码$white"
		description_if
	fi
	clear
	git_branch=$(git branch -v | grep -o 落后 )
	if [[ "$git_branch" == "落后" ]]; then
		Script_status=`echo -e "$red建议更新$white"`
	else
		Script_status=`echo -e "$green最新$white"`
	fi

	#添加系统变量
	jd_script_path=$(cat /etc/profile | grep -o jd.sh | wc -l)
	if [[ "$jd_script_path" == "0" ]]; then
		echo "export jd_file=/usr/share/JD_Script" |  tee -a /etc/profile
		echo "export jd=/usr/share/JD_Script/jd.sh" |  tee -a /etc/profile
		echo "-----------------------------------------------------------------------"
		echo ""
		echo -e "$green添加jd变量成功,重启系统以后无论在那个目录输入 bash \$jd 都可以运行脚本$white"
		echo ""
		echo ""
		echo -e "          $green直接回车会重启你的系统!!!，如果不需要马上重启ctrl+c取消$white"
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
			run_10_15_20)
			run_10_15_20
			;;
			run_03)
			run_03
			;;
			*)
			help
			;;
esac
fi
