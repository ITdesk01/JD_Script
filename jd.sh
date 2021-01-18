#!/bin/sh
#
# Copyright (C) 2020 luci-app-jd-dailybonus <jerrykuku@qq.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#
#set -x

version="1.9"
cron_file="/etc/crontabs/root"
#url=https://raw.githubusercontent.com/lxk0301/jd_scripts/master
url=https://gitee.com/lxk0301/jd_scripts/raw/master

#url=https://raw.githubusercontent.com/zy2021/JD/master


#获取当前脚本目录copy脚本之家
Source="$0"
while [ -h "$Source"  ]; do
    dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
    Source="$(readlink "$Source")"
    [[ $Source != /*  ]] && Source="$dir_file/$Source"
done
dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
dir_file_js="$dir_file/js"

node="/usr/bin/node"

red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

start_script="脚本开始运行，当前时间：`date "+%Y-%m-%d %H:%M"`"
stop_script="脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"

task() {
	cron_version="2.48"
	if [[ `grep -o "JD_Script的定时任务$cron_version" $cron_file |wc -l` == "0" ]]; then
		echo "不存在计划任务开始设置"
		task_delete
		task_add
		echo "计划任务设置完成"
	elif [[ `grep -o "JD_Script的定时任务$cron_version" $cron_file |wc -l` == "1" ]]; then
			echo "计划任务与设定一致，不做改变"
			cron_help="$green定时任务与设定一致$white"
	fi
}

task_add() {
cat >>/etc/crontabs/root <<EOF
#**********这里是JD_Script的定时任务$cron_version版本**********#
0 0 * * * $dir_file/jd.sh run_0  >/tmp/jd_run_0.log 2>&1 #0点0分执行全部脚本
*/45 2-23 * * * $dir_file/jd.sh run_045 >/tmp/jd_run_045.log 2>&1 #两个工厂
0 7-23/1 * * * $dir_file/jd.sh run_01 >/tmp/jd_run_01.log 2>&1 #种豆得豆收瓶子
50 2-22/2 * * * $dir_file/jd.sh run_02 >/tmp/jd_run_02.log 2>&1 #京东摇钱树 每两个小时收一次
10 2-22/3 * * * $dir_file/jd.sh run_03 >/tmp/jd_run_03.log 2>&1 #天天加速 3小时运行一次，打卡时间间隔是6小时
40 6-18/6 * * * $dir_file/jd.sh run_06_18 >/tmp/jd_run_06_18.log 2>&1 #不是很重要的，错开运行
35 10,15,20 * * * $dir_file/jd.sh run_10_15_20 >/tmp/jd_run_10_15_20.log 2>&1 #不是很重要的，错开运行
10 8,12,16 * * * $dir_file/jd.sh run_08_12_16 >/tmp/jd_run_08_12_16.log 2>&1 #超市旺旺兑换礼品
00 22 * * * $dir_file/jd.sh update_script >/tmp/jd_update_script.log 2>&1 #22点更新JD_Script脚本
5 22 * * * $dir_file/jd.sh update >/tmp/jd_update.log 2>&1 #22点05分更新lxk0301脚本
5 7 * * * $dir_file/jd.sh run_07 >/tmp/jd_run_07.log 2>&1 #不需要在零点运行的脚本
5 1-22/1 * * * $dir_file/jd.sh joy >/tmp/jd_joy.log 2>&1 #1-22,每一个小时运行一次joy挂机
55 23 * * * $dir_file/jd.sh kill_joy >/tmp/jd_kill_joy.log 2>&1 #23点55分关掉joy挂机
30 * * * * $dir_file/jd.sh run_030 >/tmp/jd_run_030.log 2>&1 #工业爱消除
0,1 19-21/1 $dir_file/jd.sh run_19_20_21 >/tmp/jd_run_19_20_21.log 2>&1 #直播间红包雨 1月17日-2月5日，每天19点、20点、21点
20 * $dir_file/jd.sh run_020 >/tmp/jd_run_020.log 2>&1 #京东炸年兽领爆竹
###########100##########请将其他定时任务放到底下###############
EOF

	/etc/init.d/cron restart
	cron_help="$yellow定时任务更新完成，记得看下你的定时任务$white"
}

task_delete() {
	sed -i '/JD_Script/d' /etc/crontabs/root >/dev/null 2>&1
	sed -i '/#100#/d' /etc/crontabs/root >/dev/null 2>&1
}

ds_setup() {
	echo "JD_Script删除定时任务设置"
	task_delete
	echo "JD_Script删除全局变量"
	sed -i '/JD_Script/d' /etc/profile >/dev/null 2>&1
	. /etc/profile
	echo "JD_Script定时任务和全局变量删除完成，脚本不会自动运行了"
}

update() {
	echo -e "$green update$start_script $white"
	echo -e "$green开始下载JS脚本，请稍等$white"
#cat script_name.txt | awk '{print length, $0}' | sort -rn | sed 's/^[0-9]\+ //'按照文件名长度降序：
#cat script_name.txt | awk '{print length, $0}' | sort -n | sed 's/^[0-9]\+ //' 按照文件名长度升序

cat >$dir_file/config/lxk0301_script.txt <<EOF
	jd_bean_sign.js			#京东多合一签到
	jx_sign.js			#京喜app签到长期
	jd_fruit.js			#东东农场
	jdFruitShareCodes.js		#东东农场ShareCodes
	jd_jxnc.js			#京喜农场
	jdJxncTokens.js			#京喜农场token
	jdJxncShareCodes.js		#京喜农场ShareCodes
	jd_pet.js			#东东萌宠
	jdPetShareCodes.js		#东东萌宠ShareCodes
	jd_plantBean.js			#种豆得豆
	jdPlantBeanShareCodes.js	#种豆得豆ShareCodes
	jd_superMarket.js		#东东超市
	jd_blueCoin.js			#东东超市兑换奖品
	jd_dreamFactory.js		#京喜工厂
	jdDreamFactoryShareCodes.js	#京喜工厂ShareCodes
	jd_jdfactory.js			#东东工厂
	jdFactoryShareCodes.js		#东东工厂ShareCodes
	jd_joy_feedPets.js 		#宠汪汪单独喂食
	jd_joy.js			#宠汪汪
	jd_joy_reward.js 		#宠汪汪兑换奖品
	jd_joy_steal.js			#宠汪汪偷好友狗粮与积分
	jd_crazy_joy.js			#crazyJoy任务
	jd_crazy_joy_coin.js		#crazy joy挂机领金币/宝箱专用
	jd_car_exchange.js		#京东汽车兑换，500赛点兑换500京豆
	jd_car.js			#京东汽车，签到满500赛点可兑换500京豆，一天运行一次即可
	jd_redPacket.js			#全民开红包
	jd_club_lottery.js		#摇京豆
	jd_shop.js			#进店领豆
	jd_live.js			#直播抢京豆
	jd_bean_home.js			#领京豆额外奖励
	jd_rankingList.js		#京东排行榜签到得京豆
	jd_cash.js			#签到领现金，每日2毛～5毛长期
	jd_jdzz.js			#京东赚赚长期活动
	jd_lotteryMachine.js 		#京东抽奖机
	jd_necklace.js			#点点券
	jd_syj.js			#十元街
	jd_bookshop.js			#口袋书店
	jd_family.js			#京东家庭号
	jd_kd.js			#京东快递签到 一天运行一次即可
	jd_small_home.js		#东东小窝
	jd_speed.js			#天天加速
	jd_moneyTree.js 		#摇钱树
	jd_pigPet.js			#金融养猪
	jd_daily_egg.js 		#京东金融-天天提鹅
	jd_nh.js			#京东年货节2021年1月9日-2021年2月9日
	jd_get_share_code.js		#获取jd所有助力码脚本
	jd_bean_change.js		#京豆变动通知(长期)
	jd_unbind.js			#注销京东会员卡
	jd_unsubscribe.js		#取关京东店铺和商品
	USER_AGENTS.js			#UA设置

EOF

for script_name in `cat $dir_file/config/lxk0301_script.txt | awk '{print $1}'`
do
	wget $url/$script_name -O $dir_file_js/$script_name
done

	wget https://raw.githubusercontent.com/LXK9301/jd_scripts/master/activity/jd_collectProduceScore.js -O $dir_file_js/jd_collectProduceScore.js #京东炸年兽领爆竹
	wget https://raw.githubusercontent.com/MoPoQAQ/Script/e864e3f995ac474cf2bb6dda8984b2be89e041f0/Me/jx_cfd_exchange.js -O $dir_file_js/jx_cfd.js
	wget https://raw.githubusercontent.com/799953468/Quantumult-X/master/Scripts/JD/jd_paopao.js -O $dir_file_js/jd_paopao.js
	wget https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_products_detail.js -O $dir_file_js/jx_products_detail.js
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_mh.js -O $dir_file_js/jd_mh.js #京东盲盒
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_ms.js -O $dir_file_js/jd_ms.js #京东秒秒币
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_bj.js -O $dir_file_js/jd_bj.js #宝洁美发屋
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_super_coupon.js -O $dir_file_js/jd_super_coupon.js #玩一玩-神券驾到,少于三个账号别玩
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_gyec.js -O $dir_file_js/jd_gyec.js #工业爱消除
	wget https://raw.githubusercontent.com/shylocks/Loon/main/jd_live_redrain2.js  -O $dir_file_js/jd_live_redrain2.js #直播间红包雨 1月17日-2月5日，每天19点、20点、21点
	rm -rf $dir_file_js/jdSuperMarketShareCodes.js	#东东超市ShareCodes(暂时没用)

	if [ $? -eq 0 ]; then
		echo -e ">>$green脚本下载完成$white"
	else
		clear
		echo "脚本下载没有成功，重新执行代码"
		update
	fi
	additional_settings
	echo -e "$green update$stop_script $white"

	task #更新完全部脚本顺便检查一下计划任务是否有变

}


additional_settings() {
	#京小超默认兑换20豆子(JS已经默认兑换20了)
	#sed -i "s/|| 0/|| 20/g" $dir_file_js/jd_blueCoin.js

	#取消店铺从20个改成50个(没有星推官先默认20吧)
	sed -i "s/|| 20/|| 50/g" $dir_file_js/jd_unsubscribe.js

	#宠汪汪积分兑换奖品改成兑换500豆子，个别人会兑换错误(350积分兑换20豆子，8000积分兑换500豆子要求等级16级，16000积分兑换1000京豆16级以后不能兑换)
	#sed -i "s/let joyRewardName = 20/let joyRewardName = 500/g" $dir_file_js/jd_joy_reward.js

	#京东农场
	old_fruit1="'0a74407df5df4fa99672a037eec61f7e@dbb21614667246fabcfd9685b6f448f3@6fbd26cc27ac44d6a7fed34092453f77@61ff5c624949454aa88561f2cd721bf6@56db8e7bc5874668ba7d5195230d067a@',"
	old_fruit2="'b1638a774d054a05a30a17d3b4d364b8@f92cb56c6a1349f5a35f0372aa041ea0@9c52670d52ad4e1a812f894563c746ea@8175509d82504e96828afc8b1bbb9cb3@2673c3777d4443829b2a635059953a28',"
	old_fruit3="'6fbd26cc27ac44d6a7fed34092453f77@61ff5c624949454aa88561f2cd721bf6@9c52670d52ad4e1a812f894563c746ea@8175509d82504e96828afc8b1bbb9cb3',"

	new_fruit1="6632c8135d5c4e2c9ad7f4aa964d4d11@31a2097b10db48429013103077f2f037@5aa64e466c0e43a98cbfbbafcc3ecd02@bf0cbdb0083d443499a571796af20896@9046fbd8945f48cb8e36a17fff9b0983"
	new_fruit2="d4e3080b06ed47d884e4ef9852cad568@72abb03ca91a4569933c6c8a62a5622c@ed2b2d28151a482eae49dff2e5a588f8@304b39f17d6c4dac87933882d4dec6bc"
	new_fruit3="3e6f0b7a2d054331a0b5b956f36645a9@5e54362c4a294f66853d14e777584598@f227e8bb1ea3419e9253682b60e17ae5@f0f5edad899947ac9195bf7319c18c7f@5e567ba1b9bd4389ae19fa09ca276f33"
	zuoyou_20190516_fr="367e024351fe49acaafec9ee705d3836@3040465d701c4a4d81347bc966725137@82c164278e934d5aaeb1cf19027a88a3@b167fbe380124583a36458e5045ead57@5a1448c1a7944ed78bca2fa7bfeb8440@44ba60178aa04b7895fe60c8f3b80a71@a2504cd52108495496460fc8624ae6d4@7fe23f78c77a47b0aba16b302eedbd3c@3e0769f3bb2042d993194db32513e1b9@dbd7dcdbb75940d3b81282d0f439673f"
	cainiao5_20190516_fr="2a9ccd7f32c245d7a4d6c0fe1cafdd4c"
	whiteboy__20190711_fr="dfb6b5dcc9d24281acbfce5d649924c0@319239c7aed84c1a97092ddbf2564717"
	jiu_20210110_fr="a413cb9823394d2d91eb8346d2fa4514@96721546e8fd429dbfa1351c907ea0f7"
	Javon_20201224_fr="926a1ec44ddd459ab2edc39005628bf4@dcfb05a919ff472680daca4584c832b8@0ce9d3a5f9cd40ccb9741e8f8cf5d801@54ac6b2343314f61bc4a6a24d7a2eba1@bad22aba416d4fffb18ad8534b56ea60"
	shisan_20200213_fr="cf13366e69d648ff9022e0fdce8c172a"
	JOSN_20200807_fr="2868e98772cb4fac9a04cd43e964f337"
	Jhone_Potte_20200824_fr="64304080a2714e1cac59af03b0009581@e9333dbf9c294ad6af2792dacc236fe7"
	liandao_20201010_fr="1c6474a197af4b3c8d40c26ec7f11c9e@6f7a7cc42b9342e29163588bafc3782b"
	adong_20201108_fr="3d1985319106483ba83de3366d3716d5@9e9d99a4234d45cd966236d3cb3908cf"
deng_20201120_fr="bc26d0bdc442421aa92cafcf26a1e148@57cf86ce18ca4f4987ce54fae6182bbd@521a558fcce44fbbb977c8eba4ba0d40@389f3bfe4bdc45e2b1c3e2f36e6be260@26c79946c7cc4477b56d94647d0959f2@26c79946c7cc4477b56d94647d0959f2"
	gomail_20201125_fr="31fee3cdb980491aad3b81d30d769655@0fe3938992cb49d78d4dfd6ce3d344fc"
	baijiezi_20201126_fr="09f7e5678ef44b9385eabde565c42715@ea35a3b050e64027be198e21df9eeece@62595da92a5140a3afc5bc22275bc26c@cb5af1a5db2b405fa8e9ec2e8aca8581"
	new_fruit_set="'$new_fruit1@$new_fruit2@$new_fruit3@$zuoyou_20190516_fr@$cainiao5_20190516_fr@$whiteboy__20190711_fr@$jiu_20210110_fr@$Javon_20201224_fr@$shisan_20200213_fr@$JOSN_20200807_fr@$Jhone_Potte_20200824_fr@$liandao_20201010_fr@$adong_20201108_fr@$deng_20201120_fr@$gomail_20201125_fr@$baijiezi_20201126_fr',"
	sed -i "s/$old_fruit1/$new_fruit_set/g" $dir_file_js/jd_fruit.js
	sed -i "s/$old_fruit2/$new_fruit_set/g" $dir_file_js/jd_fruit.js
	sed -i "34a $new_fruit_set" $dir_file_js/jd_fruit.js
	sed -i "35a $new_fruit_set" $dir_file_js/jd_fruit.js
	sed -i "36a $new_fruit_set" $dir_file_js/jd_fruit.js
	sed -i "37a $new_fruit_set" $dir_file_js/jd_fruit.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_fruit.js

	sed -i "s/$old_fruit1/$new_fruit_set/g" $dir_file_js/jdFruitShareCodes.js
	sed -i "s/$old_fruit3/$new_fruit_set/g" $dir_file_js/jdFruitShareCodes.js
	sed -i "11a $new_fruit_set" $dir_file_js/jdFruitShareCodes.js
	sed -i "12a $new_fruit_set" $dir_file_js/jdFruitShareCodes.js
	sed -i "13a $new_fruit_set" $dir_file_js/jdFruitShareCodes.js
	sed -i "14a $new_fruit_set" $dir_file_js/jdFruitShareCodes.js


	#萌宠
old_pet1="'MTAxODc2NTEzNTAwMDAwMDAwMjg3MDg2MA==@MTAxODc2NTEzMzAwMDAwMDAyNzUwMDA4MQ==@MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODc2NTEzNDAwMDAwMDAzMDI2MDI4MQ==@MTAxODcxOTI2NTAwMDAwMDAxOTQ3MjkzMw==',"
	old_pet2="'MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODcxOTI2NTAwMDAwMDAyNjA4ODQyMQ==@MTAxODc2NTEzOTAwMDAwMDAyNzE2MDY2NQ==@MTE1NDUyMjEwMDAwMDAwNDI0MDM2MDc=',"
	old_pet3="'MTAxODc2NTEzNTAwMDAwMDAwMjg3MDg2MA==@MTAxODc2NTEzMzAwMDAwMDAyNzUwMDA4MQ==@MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODc2NTEzNDAwMDAwMDAzMDI2MDI4MQ==',"
	old_pet4="'MTAxODc2NTEzMjAwMDAwMDAzMDI3MTMyOQ==@MTAxODcxOTI2NTAwMDAwMDAyNjA4ODQyMQ==@MTAxODc2NTEzOTAwMDAwMDAyNzE2MDY2NQ==',"

	new_pet1="MTE1NDAxNzcwMDAwMDAwMzk1OTQ4Njk==@MTE1NDQ5OTUwMDAwMDAwMzk3NDgyMDE==@MTAxODEyOTI4MDAwMDAwMDQwMTIzMzcx@MTEzMzI0OTE0NTAwMDAwMDA0MzI3NzE3MQ==@MTEzMzI0OTE0NTAwMDAwMDAzOTk5ODU1MQ==@MTAxODc2NTEzMzAwMDAwMDAxOTkzMzM1MQ=="
	new_pet2="MTAxODEyOTI4MDAwMDAwMDM5NzM3Mjk5@MTAxODc2NTEzMDAwMDAwMDAxOTcyMTM3Mw==@MTE1NDQ5MzYwMDAwMDAwMzk2NTY2MTE==@MTE1NDQ5OTUwMDAwMDAwMzk2NTY2MTk==@MTE1NDQ5OTUwMDAwMDAwNDAyNTYyMjM=="
	new_pet3="MTAxODEyOTI4MDAwMDAwMDQwNzYxOTUx@MTE1NDAxNzcwMDAwMDAwNDA4MzcyOTU==@MTE1NDQ5OTIwMDAwMDAwNDIxMDIzMzM="
	zuoyou_20190516_pet="MTEzMzI0OTE0NTAwMDAwMDAzODYzNzU1NQ==@MTE1NDAxNzgwMDAwMDAwMzg2Mzc1Nzc=@MTE1NDAxNzgwMDAwMDAwMzg4MzI1Njc=@MTAxODc2NTEzNDAwMDAwMDAyNzAxMjc1NQ==@MTAxODc2NTEzMDAwMDAwMDAyMTIzNjU5Nw==@MTAxODc2NTE0NzAwMDAwMDAyNDk1MDMwMQ==@MTAxODc2NTEzNTAwMDAwMDAyMjc1OTY1NQ==@MTEzMzI0OTE0NTAwMDAwMDA0MzQ1OTI1MQ==@MTE1NDQ5OTUwMDAwMDAwNDM3MDkyMDc="
	cainiao5_20190516_pet="MTAxODc2NTEzMzAwMDAwMDAyMTg1ODcwMQ=="
	whiteboy_20190711_pet="MTAxODc2NTEzMzAwMDAwMDAwNjU4NDU4NQ==@MTAxODc2NTE0NzAwMDAwMDAwNDI4ODExMQ=="
	jiu_20210110_pet="MTE1NDUwMTI0MDAwMDAwMDQwODg1ODg3@MTE1NDAxNzgwMDAwMDAwNDM1NjI2Mjk="
	Javon_20201224_pet="MTE1NDUyMjEwMDAwMDAwNDE2NzYzNjc=@MTE1NDAxNzgwMDAwMDAwNDI1MjkxMDU=@MTE1NDQ5OTIwMDAwMDAwNDIxMjgyNjM=@MTE1NDAxNzYwMDAwMDAwMzYwNjg0OTE=@MTE1NDQ5OTIwMDAwMDAwNDI4Nzk3NTE="
	shisan_20200213_pet="MTAxODc2NTEzMjAwMDAwMDAyMjc4OTI5OQ=="
	JOSN_20200807_pet="MTEzMzI0OTE0NTAwMDAwMDA0MTc2Njc2Nw=="
	Jhone_Potte_20200824_pet="MTE1NDAxNzcwMDAwMDAwNDE3MDkwNzE=@MTE1NDUyMjEwMDAwMDAwNDE3NDU2MjU="
	liandao_20201010_pet="MTE1NDQ5MzYwMDAwMDAwNDA3Nzk0MTc=@MTE1NDQ5OTUwMDAwMDAwNDExNjIxMDc="
	adong_20201108_pet="MTAxODc2NTEzMTAwMDAwMDAyMTIwNTc3Nw==@MTEzMzI0OTE0NTAwMDAwMDA0MjE0MjUyNQ=="
deng_20201120_pet="MTE1NDUwMTI0MDAwMDAwMDM4MzAwMTI5@MTE1NDQ5OTUwMDAwMDAwMzkxMTY3MTU=@MTE1NDQ5MzYwMDAwMDAwMzgzMzg3OTM=@MTAxODc2NTEzNTAwMDAwMDAyMzk1OTQ4OQ==@MTAxODExNDYxMTAwMDAwMDAwNDA2MjUzMTk=@MTE1NDUwMTI0MDAwMDAwMDM5MTg4MTAz"
	gomail_20201125_pet="MTE1NDQ5MzYwMDAwMDAwMzcyOTA4MDU=@MTE1NDAxNzYwMDAwMDAwNDE0MzQ4MTE="
	baijiezi_20201126_pet="MTE1NDAxNzgwMDAwMDAwNDE0NzQ3ODM=@MTE1NDUyMjEwMDAwMDAwNDA4MTg2NDE=@MTAxODc2NTEzNTAwMDAwMDAwNTI4ODM0NQ==@MTAxODc2NTEzMDAwMDAwMDAxMjM4ODExMw=="
	new_pet_set="'$new_pet1@$new_pet2@$new_pet3@$zuoyou_20190516_pet@$cainiao5_20190516_pet@$whiteboy_20190711_pet@$jiu_20210110_pet@$Javon_20201224_pet@$shisan_20200213_pet@$JOSN_20200807_pet@$Jhone_Potte_20200824_pet@$liandao_20201010_pet@$adong_20201108_pet@$deng_20201120_pet@$gomail_20201125_pet@$baijiezi_20201126_pet',"

	sed -i "s/$old_pet1/$new_pet_set/g" $dir_file_js/jd_pet.js
	sed -i "s/$old_pet2/$new_pet_set/g" $dir_file_js/jd_pet.js
	sed -i "35a $new_pet_set" $dir_file_js/jd_pet.js
	sed -i "36a $new_pet_set" $dir_file_js/jd_pet.js
	sed -i "37a $new_pet_set" $dir_file_js/jd_pet.js
	sed -i "38a $new_pet_set" $dir_file_js/jd_pet.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_pet.js

	sed -i "s/$old_pet3/$new_pet_set/g" $dir_file_js/jdPetShareCodes.js
	sed -i "s/$old_pet4/$new_pet_set/g" $dir_file_js/jdPetShareCodes.js
	sed -i "11a $new_pet_set" $dir_file_js/jdPetShareCodes.js
	sed -i "12a $new_pet_set" $dir_file_js/jdPetShareCodes.js
	sed -i "13a $new_pet_set" $dir_file_js/jdPetShareCodes.js
	sed -i "14a $new_pet_set" $dir_file_js/jdPetShareCodes.js


	#种豆
	old_plantBean1="'66j4yt3ebl5ierjljoszp7e4izzbzaqhi5k2unz2afwlyqsgnasq@olmijoxgmjutyrsovl2xalt2tbtfmg6sqldcb3q@e7lhibzb3zek27amgsvywffxx7hxgtzstrk2lba@e7lhibzb3zek32e72n4xesxmgc2m76eju62zk3y',"
	old_plantBean2="'olmijoxgmjutyx55upqaqxrblt7f3h26dgj2riy@4npkonnsy7xi3p6pjfxg6ct5gll42gmvnz7zgoy@6dygkptofggtp6ffhbowku3xgu@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy',"
	old_plantBean3="'66j4yt3ebl5ierjljoszp7e4izzbzaqhi5k2unz2afwlyqsgnasq@olmijoxgmjutyrsovl2xalt2tbtfmg6sqldcb3q@e7lhibzb3zek27amgsvywffxx7hxgtzstrk2lba@olmijoxgmjutyx55upqaqxrblt7f3h26dgj2riy',"
	old_plantBean4="'4npkonnsy7xi3p6pjfxg6ct5gll42gmvnz7zgoy@6dygkptofggtp6ffhbowku3xgu@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy@mlrdw3aw26j3wgzjipsxgonaoyr2evrdsifsziy',"

	new_plantBean1="4npkonnsy7xi3n46rivf5vyrszud7yvj7hcdr5a@mlrdw3aw26j3xeqso5asaq6zechwcl76uojnpha@nkvdrkoit5o65lgaousaj4dqrfmnij2zyntizsa@u5lnx42k5ifivyrtqhfjikhl56zsnbmk6v66uzi@3wmn5ktjfo7ukgaymbrakyuqry3h7wlwy7o5jii"
	new_plantBean2="olmijoxgmjutyy7u5s57pouxi5teo3r4r2mt36i@chcdw36mwfu6bh72u7gtvev6em@olmijoxgmjutzh77gykzjkyd6zwvkvm6oszb5ni@4npkonnsy7xi3smz2qmjorpg6ldw5otnabrmlei"
	new_plantBean3="e7lhibzb3zek2zin4gnao3gynqwqgrzjyopvbua@e7lhibzb3zek234ckc2fm2yvkj5cbsdpe7y6p2a@crydelzlvftgpeyuedndyctelq@u72q4vdn3zes24pmx6lh34pdcinjjexdfljybvi@mlrdw3aw26j3w2hy5trqwqmzn6ucqiz2ribf7na"
	zuoyou_20190516_pb="sz5infcskhz3woqbns6eertieu@mxskszygpa3kaouswi7rele2ji@4npkonnsy7xi3vk7khql3p7gkpodivnbwjoziga@mlrdw3aw26j3xizu2u66lufwmtn37juiz4xzwmi@e7lhibzb3zek35xkfdysslqi4jy7prkhfvxryma@s7ete3o7zokpafftarfntyydni@cq7ylqusen234wdwxxbkf23g6y@advwde6ogv6oya4md5eieexlfi@ubn2ft6u6wnfxwt6eyxsbcvj44@4npkonnsy7xi3tqkdk2gmzv5vdq4xk4g3cuwp7y"
	cainiao5_20190516_pb="mlrdw3aw26j3wuxtla52mzrnywbtfqzw6bzyi3y"
	whiteboy_20190711_pb="jfbrzo4erngfjdjlvmvpkpgbgie7i7c6gsw54yq@e7lhibzb3zek3uzcrgdebl2uyh3kuh7kap6cwaq"
	jiu_20210110_pb="e7lhibzb3zek3ng2hntfcceilic4hw26k24s3li@mlrdw3aw26j3wbley5cfqbdzsfdhusjessnlavi"
	Javon_20201224_pb="wpwzvgf3cyawfvqim3tlebm3evajyxv67k5fsza@qermg6jyrtndlahowraj6265fm@rug64eq6rdioosun4upct64uda5ac3f4ijdgqji@t4ahpnhib7i4hbcqqocijnecby@5a43e5atkvypfxat7paaht76zy"
	shisan_20200213_pb="mlrdw3aw26j3xzd26qnacr3cfnm4zggngukbhny"
	JOSN_20200807_pb="pmvt25o5pxfjzcquanxwokbgvu3h7wlwy7o5jii"
	Jhone_Potte_20200824_pb="olmijoxgmjutzcbkzw4njrhy3l3gwuh6g2qzsvi@olmijoxgmjuty4tpgnpbnzvu4pl6hyxp3sferqa"
	liandao_20201010_pb="nxawbkvqldtx4wdwxxbkf23g6y@l4ex6vx6yynouxxefa4hfq6z3in25fmktqqwtca"
	adong_20201108_pb="qhw4z5vauoy4gfkaybvpmxvjfi@olmijoxgmjuty6wu5iufrhoi6jmzzodszk6xgda"
deng_20201120_pb="e7lhibzb3zek3knwnjhrbaadekphavflo22jqii@olmijoxgmjutzfvkt4iu7xobmplveczy2ogou3i@f3er4cqcqgwogenz3dwsg7owhy@eupxefvqt76x2ssddhd35aysfrchgqeijzo2wdi@3en43v3ev6tvx55oefp3vb2xure67mm3kwgsm6a@nkvdrkoit5o657wm7ui35qcu2dmtir7t5h7sema"
	gomail_20201125_pb="yzhv4vq2u2tan56h4a764rocbe@4npkonnsy7xi2rducm544znpdzi2gnyg5ygrqei"
	baijiezi_20201126_pb="m6brcm36t5fvxhxnhnjzssq3fauk3bdje2jbnra@mlkc4vnryrhbob7aruocema224@vv3gwhnjzvf5scyicvcrylwldjf2yqvagsa35cy@76gkpqn3nufwjfzgfcv2mxfeimcie5fxpwtraba"
	new_plantBean_set="'$new_plantBean1@$new_plantBean2@$new_plantBean3@$zuoyou_20190516_pb@$cainiao5_20190516_pb@$whiteboy_20190711_pb@$jiu_20210110_pb@$Javon_20201224_pb@$shisan_20200213_pb@$JOSN_20200807_pb@$Jhone_Potte_20200824_pb@$@$liandao_20201010_pb@$adong_20201108_pb@$deng_20201120_pb@$gomail_20201125_pb@$baijiezi_20201126_pb',"
	sed -i "s/$old_plantBean1/$new_plantBean_set/g" $dir_file_js/jd_plantBean.js
	sed -i "s/$old_plantBean2/$new_plantBean_set/g" $dir_file_js/jd_plantBean.js
	sed -i "39a $new_plantBean_set" $dir_file_js/jd_plantBean.js
	sed -i "40a $new_plantBean_set" $dir_file_js/jd_plantBean.js
	sed -i "41a $new_plantBean_set" $dir_file_js/jd_plantBean.js
	sed -i "42a $new_plantBean_set" $dir_file_js/jd_plantBean.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_plantBean.js

	sed -i "s/$old_plantBean3/$new_plantBean_set/g" $dir_file_js/jdPlantBeanShareCodes.js
	sed -i "s/$old_plantBean4/$new_plantBean_set/g" $dir_file_js/jdPlantBeanShareCodes.js
	sed -i "11a $new_plantBean_set" $dir_file_js/jdPlantBeanShareCodes.js
	sed -i "12a $new_plantBean_set" $dir_file_js/jdPlantBeanShareCodes.js
	sed -i "13a $new_plantBean_set" $dir_file_js/jdPlantBeanShareCodes.js
	sed -i "14a $new_plantBean_set" $dir_file_js/jdPlantBeanShareCodes.js


	#京喜工厂
	old_dreamFactory="'V5LkjP4WRyjeCKR9VRwcRX0bBuTz7MEK0-E99EJ7u0k=@Bo-jnVs_m9uBvbRzraXcSA==@-OvElMzqeyeGBWazWYjI1Q==',"
	old_dreamFactory1="'1uzRU5HkaUgvy0AB5Q9VUg==@PDPM257r_KuQhil2Y7koNw==@-OvElMzqeyeGBWazWYjI1Q==',"
	new_dreamFactory="'4HL35B_v85-TsEGQbQTfFg==@q3X6tiRYVGYuAO4OD1-Fcg==@Gkf3Upy3YwQn2K3kO1hFFg==@w8B9d4EVh3e3eskOT5PR1A==@1s8ZZnxD6DVDyjdEUu-zXA==@FyYWfETygv_4XjGtnl2YSg==@us6se4fFC6cSjHDSS_ScMw==@oWcboKZa9XxTSWd28tCEPA==@sboe5PFeXgL2EWpxucrKYw==@rm-j1efPyFU50GBjacgEsw==@1rQLjMF_eWMiQ-RAWARW_w==@bHIVoTmS-fHA6G9ixqnOxfjRNGe1YfJzIbBoF-NEAOw=@6h514zWW6JNRE_Kp-L4cjA==@WFlk160B_Byd-xNNEyRPJQ==@bxUPiWroac-c9PLIPSjnNQ==@P2nGgK6JgLtCqJBeQJ0f27XXLQwYAFHrKmA2siZTuj8=@LTyKtCPGU6v0uv-n1GSwfQ==@y7KhVRopnOwB1qFo2vIefg==@WnaDbsWYwImvOD1CpkeVWA==@Y4r32JTAKNBpMoCXvBf7oA==',"
	
	sed -i "s/6S9y4sJUfA2vPQP6TLdVIQ==/4HL35B_v85-TsEGQbQTfFg==/g" $dir_file_js/jd_dreamFactory.js
	sed -i "s/"gB99tYLjvPcEFloDgamoBw==",/'gB99tYLjvPcEFloDgamoBw==',/g" $dir_file_js/jd_dreamFactory.js
	sed -i "s/'V5LkjP4WRyjeCKR9VRwcRX0bBuTz7MEK0-E99EJ7u0k=@0WtCMPNq7jekehT6d3AbFw==', 'PDPM257r_KuQhil2Y7koNw==', 'gB99tYLjvPcEFloDgamoBw==', '-OvElMzqeyeGBWazWYjI1Q==', 'GFwo6PntxDHH95ZRzZ5uAg=='/$new_dreamFactory/g" $dir_file_js/jd_dreamFactory.js

	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_dreamFactory.js

	sed -i "s/$old_dreamFactory/$new_dreamFactory/g" $dir_file_js/jdDreamFactoryShareCodes.js
	sed -i "s/$old_dreamFactory1/$new_dreamFactory/g" $dir_file_js/jdDreamFactoryShareCodes.js
	sed -i "11a $new_dreamFactory" $dir_file_js/jdDreamFactoryShareCodes.js
	sed -i "12a $new_dreamFactory" $dir_file_js/jdDreamFactoryShareCodes.js
	sed -i "13a $new_dreamFactory" $dir_file_js/jdDreamFactoryShareCodes.js
	sed -i "14a $new_dreamFactory" $dir_file_js/jdDreamFactoryShareCodes.js


	#东东工厂
	old_jdfactory="\`P04z54XCjVWnYaS5u2ak7ZCdan1Bdd2GGiWvC6_uERj\`, 'P04z54XCjVWnYaS5m9cZ2ariXVJwHf0bgkG7Uo'"
	#new_jdfactory="'P04z54XCjVWnYaS5m9cZ2f83X0Zl_Dd8CqABxo', 'P04z54XCjVWnYaS5m9cZ2Wui31Oxg3QPwI97G0', 'P04z54XCjVWnYaS5m9cZz-inDgt5gUTV9zVCg', 'P04z54XCjVWnYaS5m9cZ2T8jntInKkhvhlkIu4', 'P04z54XCjVWnYaS5m9cZ2eq2S1OxAqmz-x3vbg',"
	new_jdfactory1="'P04z54XCjVWnYaS5m9cZ2f83X0Zl_Dd8CqABxo@P04z54XCjVWnYaS5m9cZ2Wui31Oxg3QPwI97G0@P04z54XCjVWnYaS5m9cZz-inDgt5gUTV9zVCg@T0205KkcJEZAjD2vYGGG4Ip0CjVWnYaS5kRrbA@P04z54XCjVWnYaS5m9cZ2T8jntInKkhvhlkIu4@P04z54XCjVWnYaS5m9cZ2eq2S1OxAqmz-x3vbg@P04z54XCjVWnYaS5mZQUSm92H5L@P04z54XCjVWnYaS5mlKD2U@P04z54XCjVWnYaS5n1LTCj93Q@P04z54XCjVWnYaS5m9cZ2er3ylCk-4HZadagsg@T023uvp2RBcY_VHKKBn3k_MMdNwCjVWnYaS5kRrbA',"
	sed -i "s/'',/$new_jdfactory1 $new_jdfactory1 $new_jdfactory1/g" $dir_file_js/jdFactoryShareCodes.js
	sed -i "s/$old_jdfactory/$new_jdfactory1/g" $dir_file_js/jd_jdfactory.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_jdfactory.js
	if [[ -f "$dir_file/1.txt" ]]; then
		sed -i "s/let wantProduct = \`\`/let wantProduct = \`灵蛇机械键盘\`/g" $dir_file_js/jd_jdfactory.js
	elif [[ -f "$dir_file/2.txt" ]]; then
		sed -i "s/let wantProduct = \`\`/let wantProduct = \`电视\`/g" $dir_file_js/jd_jdfactory.js
	else
		echo ""
	fi

:<<'COMMENT'
	#东东超市
	sed -i '323,338d' jd_superMarket.js
	sed -i "s/eU9Ya-y2N_5z9DvXwyIV0A/eU9Ya-iyZ68kpWrRmXBFgw/g" $dir_file_js/jd_superMarket.js
	sed -i "s/aURoM7PtY_Q/eU9Ya-iyZ68kpWrRmXBFgw/g" $dir_file_js/jd_superMarket.js
	sed -i "s/eU9Ya-y2N_5z9DvXwyIV0A/eU9YabrkZ_h1-GrcmiJB0A/g" $dir_file_js/jd_superMarket.js
	sed -i "s/eU9YaeS3Z6ol8zrRmnMb1Q/eU9YabrkZ_h1-GrcmiJB0A/g" $dir_file_js/jd_superMarket.js
COMMENT

	#京东赚赚长期活动
	old_jdzz="\`ATGEC3-fsrn13aiaEqiM@AUWE5maSSnzFeDmH4iH0elA@ATGEC3-fsrn13aiaEqiM@AUWE5m6WUmDdZC2mr1XhJlQ@AUWE5m_jEzjJZDTKr3nwfkg@A06fNSRc4GIqY38pMBeLKQE2InZA@AUWE5mf7ExDZdDmH7j3wfkA@AUWE5m6jBy2cNAWX7j31Pxw@AUWE5mK2UnDddDTX61S1Mkw@AUWE5mavGyGZdWzP5iCoZwQ\`,"
	old_jdzz1="\`ATGEC3-fsrn13aiaEqiM@AUWE5maSSnzFeDmH4iH0elA@ATGEC3-fsrn13aiaEqiM@AUWE5m6WUmDdZC2mr1XhJlQ@AUWE5m_jEzjJZDTKr3nwfkg@A06fNSRc4GIqY38pMBeLKQE2InZA@AUWE5m6_BmTUPAGH42SpOkg@AUWE53NTIs3V8YBqthQMI\`"
	new_jdzz="'AUWE5mKmQzGYKXGT8j38cwA@AUWE5mvvGzDFbAWTxjC0Ykw@AUWE5wPfRiVJ7SxKOuQY0@S5KkcJEZAjD2vYGGG4Ip0@S7aUqCVsc91U@S5KkcREsZ_QXWIx31wKJZcA@S5KkcRUwe81LRIR_3xaNedw@Suvp2RBcY_VHKKBn3k_MMdNw',"
	sed -i "s/$old_jdzz/$new_jdzz/g" $dir_file_js/jd_jdzz.js
	sed -i "s/$old_jdzz1/$new_jdzz/g" $dir_file_js/jd_jdzz.js
	sed -i "48a $new_jdzz" $dir_file_js/jd_jdzz.js
	sed -i "49a $new_jdzz" $dir_file_js/jd_jdzz.js
	sed -i "50a $new_jdzz" $dir_file_js/jd_jdzz.js
	sed -i "51a $new_jdzz" $dir_file_js/jd_jdzz.js
	sed -i "s/const randomCount = 5/const randomCount = 0/g" $dir_file_js/jd_jdzz.js
	sed -i "s/helpAuthor=true/helpAuthor=false/g" $dir_file_js/jd_jdzz.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_jdzz.js

	#crazyJoy任务
	old_crazyJoy="'EdLPh8A6X5G1iWXu-uPYfA==@0gUO7F7N-4HVDh9mdQC2hg==@fUJTgR9z26fXdQgTvt_bgqt9zd5YaBeE@nCQQXQHKGjPCb7jkd8q2U-aCTjZMxL3s@2boGLV7TonMex8-nrT6EGat9zd5YaBeE',"
	old_crazyJoy1="'EdLPh8A6X5G1iWXu-uPYfA==@0gUO7F7N-4HVDh9mdQC2hg==@fUJTgR9z26fXdQgTvt_bgqt9zd5YaBeE@nCQQXQHKGjPCb7jkd8q2U-aCTjZMxL3s@2boGLV7TonMex8-nrT6EGat9zd5YaBeE'"
	new_crazyJoy="'rHYmFm9wQAUb1S9FJUrMB6t9zd5YaBeE@7P1a-YqssNzEUo2yzMjkKat9zd5YaBeE@5z24ds6URIn_QEyGetqaHg==@C5vbyHg-mOmrfc3eWGgXhA==@KgkXpuBiTwm918sV3j4cmA==@CCxsXuB_kLhf6HV1LsZZ3GXGvf5Si_Xe',"
	sed -i "s/$old_crazyJoy/$new_crazyJoy/g" $dir_file_js/jd_crazy_joy.js
	sed -i "s/$old_crazyJoy1/$new_crazyJoy/g" $dir_file_js/jd_crazy_joy.js
	sed -i "37a $new_crazyJoy" $dir_file_js/jd_crazy_joy.js
	sed -i "38a $new_crazyJoy" $dir_file_js/jd_crazy_joy.js
	sed -i "39a $new_crazyJoy" $dir_file_js/jd_crazy_joy.js
	sed -i "40a $new_crazyJoy" $dir_file_js/jd_crazy_joy.js
	sed -i "s/$.isNode() ? 10 : 5/0/g" $dir_file_js/jd_crazy_joy.js


	#口袋书店
	old_jdbook="'28a699ac78d74aa3b31f7103597f8927@2f14ee9c92954cf79829320dd482bf49@fdf827db272543d88dbb51a505c2e869'"
	new_jdbook="'d6d73edddaa64cbda1ec42dd496591d0@e50f362dbf8e4e8891c18d0a6fc9d04d@40cb5da84f0448a695dd5b9643592cfa@3ef061eb9b244b3cbdc9904a0297c3f5@99f8c73daa9f488b8cb7a2ed585aa34d',"
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_bookshop.js
	sed -i "s/$old_jdbook,/$new_jdbook/g" $dir_file_js/jd_bookshop.js
	sed -i "s/$old_jdbook/$new_jdbook/g" $dir_file_js/jd_bookshop.js
	sed -i "31a $new_jdbook" $dir_file_js/jd_bookshop.js
	sed -i "32a $new_jdbook" $dir_file_js/jd_bookshop.js
	sed -i "33a $new_jdbook" $dir_file_js/jd_bookshop.js
	sed -i "34a $new_jdbook" $dir_file_js/jd_bookshop.js
	
	#京喜农场
	old_jxnc="'22bd6fbbabbaa770a45ab2607e7a1e8a@197c6094e965fdf3d33621b47719e0b1'"
	new_jxnc="'019cffd91086ab563e91abf469634395@48f4c24ea3d01be32359cc61ba43ae7e@87c34293058a8644f73be7731a91a293@16b73e9a958c3f4636a51a17fcba28df@6cdc3a49111b7b57153a633eb6c1b1e3'"
	sed -i "s/$old_jxnc/$new_jxnc/g" $dir_file_js/jd_jxnc.js
	sed -i "s/'',/$new_jxnc/g" $dir_file_js/jdJxncShareCodes.js
	sed -i "12a $new_jxnc" $dir_file_js/jdJxncShareCodes.js
	sed -i "13a $new_jxnc" $dir_file_js/jdJxncShareCodes.js
	sed -i "14a $new_jxnc" $dir_file_js/jdJxncShareCodes.js
	sed -i "15a $new_jxnc" $dir_file_js/jdJxncShareCodes.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_jxnc.js

	#签到领现金
	old_jdcash="\`-4msulYas0O2JsRhE-2TA5XZmBQ@eU9Yar_mb_9z92_WmXNG0w@eU9YaO7jMvwh-W_VzyUX0Q\`"
	new_jdcash="'eU9Ya-iyZ68kpWrRmXBFgw@eU9YabrkZ_h1-GrcmiJB0A@eU9YM7bzIptVshyjrwlteU9YCLTrH5VesRWnvw5t@P2nGgK6JgLtCqJBeQJ0f27XXLQwYAFHrKmA2siZTuj8=@LTyKtCPGU6v0uv-n1GSwfQ==@y7KhVRopnOwB1qFo2vIefg==@WnaDbsWYwImvOD1CpkeVWA==@Y4r32JTAKNBpMoCXvBf7oA==@JuMHWNtZt4Ny_0ltvG6Ipg==',"
	sed -i "s/$old_jdcash,/$new_jdcash/g" $dir_file_js/jd_cash.js 
	sed -i "s/$old_jdcash/$new_jdcash/g" $dir_file_js/jd_cash.js 
	sed -i "33a $new_jdcash" $dir_file_js/jd_cash.js
	sed -i "34a $new_jdcash" $dir_file_js/jd_cash.js
	sed -i "35a $new_jdcash" $dir_file_js/jd_cash.js
	sed -i "36a $new_jdcash" $dir_file_js/jd_cash.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_cash.js

	#工业爱消除
	old_jdgyec="'840266@2583822@2585219@2586018@1556311@2583822@2585256@2586023@2728968',"
	new_jdgyec="'743359@2753077@2759122@2759259@2337978',"
	sed -i "s/$old_jdgyec,/$new_jdgyec/g" $dir_file_js/jd_gyec.js
	sed -i "s/$old_jdgyec/$new_jdgyec/g" $dir_file_js/jd_gyec.js
	sed -i "35a $new_jdgyec" $dir_file_js/jd_gyec.js
	sed -i "36a $new_jdgyec" $dir_file_js/jd_gyec.js
	sed -i "37a $new_jdgyec" $dir_file_js/jd_gyec.js
	sed -i "38a $new_jdgyec" $dir_file_js/jd_gyec.js
	sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/jd_gyec.js
}

update_script() {
	echo -e "$green update_script$start_script $white"
	cd $dir_file
	git fetch --all
	git reset --hard origin/main
	echo -e "$green update_script$stop_script $white"
}


run_0() {
	echo -e "$green run_0$start_script $white"
	$node $dir_file_js/cfdtx.js #财富岛提取
	$node $dir_file_js/jd_car_exchange.js #京东汽车兑换，500赛点兑换500京豆
	$node $dir_file_js/jd_car.js #京东汽车，签到满500赛点可兑换500京豆，一天运行一次即可
	$node $dir_file_js/jd_bean_sign.js #京东多合一签到
	$node $dir_file_js/jx_sign.js #京喜app签到长期
	$node $dir_file_js/jd_redPacket.js #京东全民开红包，没时间要求
	$node $dir_file_js/jd_lotteryMachine.js #京东抽奖机
	$node $dir_file_js/jd_cash.js #签到领现金，每日2毛～5毛长期
	$node $dir_file_js/jd_nh.js #京东年货节2021年1月9日-2021年2月9日
	run_08_12_16
	$node $dir_file_js/jd_small_home.js #东东小窝
	run_06_18
	run_10_15_20
	run_01
	run_02
	run_03
	run_045
	$node $dir_file_js/jd_crazy_joy.js #crazyJoy任务
	stop_notice
	echo -e "$green run_0$stop_script $white"
}

joy(){
	#crazy joy挂机领金币/宝箱专用
	kill_joy
	$node $dir_file_js/jd_crazy_joy_coin.js &
}

kill_joy() {
	pid=$(ps -ef | grep "$dir_file/js/jd_crazy_joy_coin.js" |grep -v grep |awk '{print $1}')
	if [ $(echo $pid |wc -l ) -ge 1 ];then
		echo -e "$yellow发现joy后台程序开始清理，请稍等$white"
		for i in $pid
		do
			echo "kill $i"
			kill -9 $i
			sleep 2
		done
		echo -e "$green joy后台程序清理完成$white"
	else
		echo "$green没有运行的joy后台$white"
	fi
}

run_020() {
	sed -i "s/..\/jdCookie.js/.\/jdCookie.js/g" jd_collectProduceScore.js
	$node $dir_file_js/jd_collectProduceScore.js #京东炸年兽领爆竹
}

run_030() {
	$node $dir_file_js/jd_gyec.js #工业爱消除
}

run_045() {
	echo -e "$green run_045$start_script $white"
	$node $dir_file_js/jd_dreamFactory.js #京喜工厂 45分钟运行一次
	$node $dir_file_js/jd_jdfactory.js #东东工厂，不是京喜工厂
	echo -e "$green run_045$stop_script $white"
}

run_01() {
	echo -e "$green run_01$start_script $white"
	$node $dir_file_js/jd_plantBean.js 
	$node $dir_file_js/jd_joy_feedPets.js #种豆得豆，没时间要求，一个小时收一次瓶子 & #宠汪汪喂食一个小时喂一次
	$node $dir_file_js/jd_family.js #京东家庭号
	echo -e "$green run_01$stop_script $white"
}

run_02() {
	echo -e "$green run_02$start_script $white"
	$node $dir_file_js/jd_moneyTree.js #京东摇钱树，7-9 11-13 18-20签到 每两小时收一次
	$node $dir_file_js/jd_bookshop.js #口袋书店
	echo -e "$green run_02$stop_script $white"
}

run_03() {
	echo -e "$green run_03$start_script $white"
	$node $dir_file_js/jd_speed.js #天天加速 3小时运行一次，打卡时间间隔是6小时
	echo -e "$green run_03$stop_script $white"
}


run_06_18() {
	echo -e "$green run_06_18$start_script $white"
	$node $dir_file_js/jd_shop.js #进店领豆，早点领，一天也可以执行两次以上
	$node $dir_file_js/jd_fruit.js #东东水果，6-9点 11-14点 17-21点可以领水滴
	$node $dir_file_js/jd_joy.js #jd宠汪汪，零点开始，11.30-15:00 17-21点可以领狗粮
	$node $dir_file_js/jd_pet.js #东东萌宠，跟手机商城同一时间
	$node $dir_file_js/jd_joy_steal.js #可偷好友积分，零点开始，六点再偷一波狗粮
	$node $dir_file_js/jd_daily_egg.js #天天提鹅蛋，需要有金融app，没有顶多报错问题不大
	$node $dir_file_js/jd_pigPet.js #金融养猪，需要有金融app，没有顶多报错问题不大
	$node $dir_file_js/jd_superMarket.js #东东超市,6点 18点多加两场用于收金币
	echo -e "$green run_06_18$stop_script $white"
}

run_07() {
	echo -e "$green run_07$start_script $white"
	$node $dir_file_js/jd_bean_sign.js #京东多合一签到
	$node $dir_file_js/jx_sign.js #京喜app签到长期
	$node $dir_file_js/jd_rankingList.js #京东排行榜签到领京豆
	$node $dir_file_js/jd_syj.js #十元街签到,一天一次即可，一周30豆子
	$node $dir_file_js/jd_paopao.js #京东泡泡大战,一天一次
	$node $dir_file_js/jd_kd.js #京东快递签到 一天运行一次即可
	$node $dir_file_js/jd_bean_home.js #领京豆额外奖励
	$node $dir_file_js/jd_club_lottery.js #摇京豆，没时间要求
	$node $dir_file_js/jd_live.js #直播抢京豆 （需要执行三次，不然没有18豆子）
	$node $dir_file_js/jd_live.js #直播抢京豆
	$node $dir_file_js/jd_live.js #直播抢京豆
	$node $dir_file_js/jd_jdzz.js #京东赚赚长期活动
	$node $dir_file_js/jd_jxnc.js #京喜农场
	$node $dir_file_js/jd_mh.js #京东盲盒
	$node $dir_file_js/jd_ms.js #京东秒秒币 一个号大概60秒
	$node $dir_file_js/jd_bj.js #宝洁美发屋
	$node $dir_file_js/jd_bj.js #宝洁美发屋
	$node $dir_file_js/jd_bj.js #宝洁美发屋
	$node $dir_file_js/jd_bj.js #宝洁美发屋
	$node $dir_file_js/jd_super_coupon.js #玩一玩-神券驾到,少于三个账号别玩
	$node $dir_file_js/jd_unsubscribe.js #取关店铺，没时间要求
	#$node $dir_file_js/jd_unbind.js #注销京东会员卡
	$node $dir_file_js/jd_bean_change.js #京豆变更
	echo -e "$green run_07$stop_script $white"
}

run_08_12_16() {
	echo -e "$green run_08_12_16$start_script $white"
	$node $dir_file_js/jd_blueCoin.js #东东超市兑换，有次数限制，没时间要求
	$node $dir_file_js/jd_joy_reward.js #宠汪汪积分兑换奖品，有次数限制，每日京豆库存会在0:00、8:00、16:00更新，经测试发现中午12:00也会有补发京豆
	echo -e "$green run_08_12_16$stop_script $white"
}

run_19_20_21() {
	echo -e "$green run_19_20_21$start_script $white"
	$node $dir_file_js/jd_live_redrain2.js #直播间红包雨 1月17日-2月5日，每天19点、20点、21点
	echo -e "$green run_19_20_21$stop_script $white"
}


run_10_15_20() {
	echo -e "$green run_10_15_20$start_script $white"
	$node $dir_file_js/jd_superMarket.js #东东超市,0 10 15 20四场补货加劵
	$node $dir_file_js/jd_necklace.js  #点点券 大佬0,20领一次先扔这里后面再改
	#$node $dir_file_js/jx_cfd.js #京东财富岛 有一日三餐任务
	echo -e "$green run_10_15_20$stop_script $white"
}



jx() {
	echo -e "$green 查询京喜商品生产所用时间$start_script $white"
	$node $dir_file_js/jx_products_detail.js
	echo -e "$green 查询完成$stop_script $white"
}

jd_sharecode() {
	echo -e "$green 查询京东助力码$start_script $white"
	$node $dir_file_js/jd_get_share_code.js #获取jd所有助力码脚本
	echo -e "$green 查询完成$start_script $white"
}

stop_notice() {
	#农场和萌宠提示太多次了，所用每天提示一次即可
	sed -i "s/jdNotify = false/jdNotify = true/g" $dir_file_js/jd_fruit.js
	sed -i "s/jdNotify = false/jdNotify = true/g" $dir_file_js/jd_pet.js
}

help() {
	task
	clear
	echo ----------------------------------------------------
	echo "	     JD.sh $version 使用说明"
	echo ----------------------------------------------------
	echo -e "$yellow 1.文件说明$white"
	echo -e "$green $dir_file/jdCookie.js $white 在此脚本内填写JD Cookie 脚本内有说明"
	echo -e "$green $dir_file/sendNotify.js $white 在此脚本内填写推送服务的KEY，可以不填"
	echo -e "$green $dir_file/jd.sh $white JD_Script的本体（作用就是帮忙下载js脚本，js脚本是核心）"
	echo -e "$yellow JS脚本作用请查询：$white $green https://github.com/lxk0301/jd_scripts $white"
	echo -e "$yellow 浏览器获取京东cookie教程：$white $green https://github.com/lxk0301/jd_scripts/blob/master/backUp/GetJdCookie.md $white"
	echo ""
	echo -e "$yellow 2.jd.sh脚本命令$white"
	echo -e "$green sh \$jd update $white        #下载js脚本"
	echo -e "$green sh \$jd update_script $white #更新JD_Script "
	echo -e "$green sh \$jd run_0 $white         #运行全部脚本 $yellow#第一次安装完成运行这句，前提你把jdCookie.js填完整$white"
	echo -e "$green sh \$jd run_045 $white        #运行run_045模块里的命令"
	echo -e "$green sh \$jd run_01 $white        #运行run_01模块里的命令 "
	echo -e "$green sh \$jd run_02 $white        #运行run_02模块里的命令"
	echo -e "$green sh \$jd run_03 $white        #运行run_03模块里的命令"
	echo -e "$green sh \$jd run_06_18 $white     #运行run_06_18模块里的命令"
	echo -e "$green sh \$jd run_08_12_16 $white     #运行run_08_12_16模块里的命令"
	echo -e "$green sh \$jd run_10_15_20 $white  #运行run_10_15_20模块里的命令"
	echo -e "$green sh \$jd jx $white            #查询京喜商品生产使用时间"
	echo -e "$green sh \$jd jd_sharecode $white            #查询京东所有助力码"
	echo " 如果不喜欢这样，你也可以直接cd $jd_file/js,然后用node 脚本名字.js "
	echo ""
	echo -e "$yellow 3.检测定时任务:$white $cron_help"
	echo -e "$yellow 定时任务路径:$white$green/etc/crontabs/root$white"
	echo ""
	echo -e "$yellow 4.如何排错或者你想要的互助码:$white"
	echo ""
	echo "  答1：如何排错有种东西叫更新，如sh \$jd update_script 和sh \$jd update"
	echo "  答2：如何排错有种东西叫查日志，如/tmp/里面的jd开头.log结果的日志文件"
	echo "  答3：你想要的互助码有种东西叫查日志，如/tmp/里面的jd开头.log结果的日志文件"
	echo ""
	echo "  看不懂代码又想白嫖，你还是洗洗睡吧，梦里啥都有，当然你可以用钞能力解决多数问题（你可以忽略这句，继续做梦）"
	echo ""
	echo -e "$yellow 5.检测脚本是否最新:$white $Script_status "
	echo ""
	echo -e "$yellow 6.JD_Script报错你可以反馈到这里:$white$green https://github.com/ITdesk01/JD_Script/issues$white"
	echo ""
	echo -e "本脚本基于$green x86主机测试$white，一切正常，其他的机器自行测试，满足依赖一般问题不大"
	echo ----------------------------------------------------
	echo " 		by：ITdesk"
	echo ----------------------------------------------------
}

description_if() {
	system_variable
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
	git_branch=$(git branch -v | grep -o behind )
	if [[ "$git_branch" == "behind" ]]; then
		Script_status="$red建议更新$white (可以运行$green sh \$jd update_script && sh \$jd update && sh \$jd $white更新 )"
	else
		Script_status="$green最新$white"
	fi

	help
}

system_variable() {
	if [[ ! -d "$dir_file/config" ]]; then
		mkdir  $dir_file/config
	fi
	
	if [[ ! -d "$dir_file/js" ]]; then
		mkdir  $dir_file/js
		update
	fi

	install_script="/usr/share/Install_script"
	install_script_config="/usr/share/Install_script/script_config"
	if [ "$dir_file" == "$install_script/JD_Script" ];then
		if [ ! -f "$install_script_config/jdCookie.js" ]; then
			wget $url/jdCookie.js -O $install_script_config/jdCookie.js
			rm -rf $dir_file_js/jdCookie.js #用于删除旧的链接
			ln -s $install_script_config/jdCookie.js $dir_file_js/jdCookie.js
		fi
		
		#用于升级以后恢复链接
		if [ ! -f "$dir_file_js/jdCookie.js" ]; then
			ln -s $install_script_config/jdCookie.js $dir_file_js/jdCookie.js
		fi

		if [ ! -f "$install_script_config/sendNotify.js" ]; then
			wget $url/sendNotify.js -O $install_script_config/sendNotify.js
			rm -rf $dir_file_js/sendNotify.js  #用于删除旧的链接
			ln -s $install_script_config/sendNotify.js $dir_file_js/sendNotify.js
		fi

		#用于升级以后恢复链接
		if [ ! -f "$dir_file_js/sendNotify.js" ]; then
			ln -s $install_script_config/sendNotify.js $dir_file_js/sendNotify.js
		fi

	else
		if [ ! -f "$dir_file/jdCookie.js" ]; then
			wget $url/jdCookie.js -O $dir_file/jdCookie.js
			ln -s $dir_file/jdCookie.js $dir_file_js/jdCookie.js
		fi

		if [ ! -f "$dir_file/sendNotify.js" ]; then
			wget $url/sendNotify.js -O $dir_file/sendNotify.js
			ln -s $dir_file/sendNotify.js $dir_file_js/sendNotify.js
		fi

	fi

	#判断node版本是大于10
	node_if=$(opkg list-installed | grep 'node -' | awk -F "." '{print $1}' | awk -F v '{print $2}')
	node_npm=$(opkg list-installed | grep 'node-npm' | awk -F "." '{print $1}' | awk -F v '{print $2}')
	if [ ! $node_if -ge "10" ];then
		echo "node 版本小于10，请升级以后再使用本脚本"
		exit 0
	fi

	if [ ! $node_if -ge "10" ];then
		echo "node-npm 版本小于10，请升级以后再使用本脚本"
		exit 0
	fi

	#添加系统变量
	jd_script_path=$(cat /etc/profile | grep -o jd.sh | wc -l)
	if [[ "$jd_script_path" == "0" ]]; then
		echo "export jd_file=$dir_file" >> /etc/profile
		echo "export jd=$dir_file/jd.sh" >> /etc/profile
		. /etc/profile
	fi
}

action1="$1"
action2="$2"
if [[ -z $action1 ]]; then
	description_if
else
	case "$action1" in
		system_variable|update|update_script|run_0|run_01|run_06_18|run_10_15_20|run_02|run_03|run_045|task|run_08_12_16|jx|run_07|additional_settings|joy|kill_joy|jd_sharecode|ds_setup|run_030|run_19_20_21|run_020)
		$action1
		;;
		*)
		help
		;;
	esac

	if [[ -z $action2 ]]; then
		echo ""
	else
		case "$action2" in
		system_variable|update|update_script|run_0|run_01|run_06_18|run_10_15_20|run_02|run_03|run_045|task|run_08_12_16|jx|run_07|additional_settings|joy|kill_joy|jd_sharecode|ds_setup|run_030|run_19_20_21|run_020)
		$action2
		;;
		*)
		help
		;;
	esac
	fi
fi
