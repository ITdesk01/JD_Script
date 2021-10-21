#!/bin/sh
#
#by:ITdesk
#
#Github:https://github.com/ITdesk01/JD_Script/tree/main
#
#如果你魔改我的脚本，请魔改的彻底一点，不要留我的qq群，没时间处理一堆不用我库的人，决定魔改那就自己维护，你好我也好。

#set -x


red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

#获取当前脚本目录copy脚本之家
Source="$0"
while [ -h "$Source"  ]; do
    dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
    Source="$(readlink "$Source")"
    [[ $Source != /*  ]] && Source="$dir_file/$Source"
done
dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
dir_file_js="$dir_file/js"

#检测当前位置
if [ "$dir_file" == "/usr/share/jd_openwrt_script/JD_Script" ];then
	openwrt_script="/usr/share/jd_openwrt_script"
	openwrt_script_config="/usr/share/jd_openwrt_script/script_config"
else
	clear
	echo -e "$red检测到你使用本地安装方式安装脚本，不再支持本地模式！！！，请按github：https://github.com/ITdesk01/jd_openwrt_script 重新编译插件$white"
	exit 0
fi

ccr_js_file="$dir_file/ccr_js"
run_sleep=$(sleep 1)

version="2.2"
cron_file="/etc/crontabs/root"
node="/usr/bin/node"
tsnode="/usr/bin/ts-node"
python3="/usr/bin/python3"
sys_model=$(cat /tmp/sysinfo/model | awk -v i="+" '{print $1i$2i$3i$4}')
uname_version=$(uname -a | awk -v i="+" '{print $1i $2i $3}')

#给强迫症的福利
wan_ip=$(cat /etc/config/network | grep "wan" | wc -l)
if [ ! $wan_ip ];then
	wan_ip="找不到Wan IP"
else
	wan_ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
fi

#Server酱
wrap="%0D%0A%0D%0A" #Server酱换行
wrap_tab="     "
line="%0D%0A%0D%0A---%0D%0A%0D%0A"
current_time=$(date +"%Y-%m-%d")
by="#### 脚本仓库地址:https://github.com/ITdesk01/JD_Script/tree/main 核心JS采用lxk0301开源JS脚本"

if [ ! -f $openwrt_script_config/Checkjs_Sckey.txt ];then
	echo >$openwrt_script_config/Checkjs_Sckey.txt
else
	echo >$dir_file/Checkjs_Sckey.txt
fi

if [ "$dir_file" == "/usr/share/jd_openwrt_script/JD_Script" ];then
	SCKEY=$(grep "let SCKEY" $openwrt_script_config/sendNotify.js  | awk -F "'" '{print $2}')
	if [ ! $SCKEY ];then
		SCKEY=$(cat $openwrt_script_config/Checkjs_Sckey.txt)
	fi
else
	SCKEY=$(cat $dir_file/Checkjs_Sckey.txt)
fi

#企业微信
weixin_line="------------------------------------------------"

start_script_time="脚本开始运行，当前时间：`date "+%Y-%m-%d %H:%M"`"
stop_script_time="脚本结束，当前时间：`date "+%Y-%m-%d %H:%M"`"
script_read=$(cat $dir_file/script_read.txt | grep "我已经阅读脚本说明"  | wc -l)

export JD_JOY_REWARD_NAME="500"

#开卡变量
export guaopencard_All="true"
export guaopencard_addSku_All="true"
export guaopencardRun_All="true"
export guaopencard_draw="true"

export FS_LEVEL="card开卡+加购"

task() {
	cron_version="3.66"
	if [[ `grep -o "JD_Script的定时任务$cron_version" $cron_file |wc -l` == "0" ]]; then
		echo "不存在计划任务开始设置"
		task_delete
		task_add
		echo "计划任务设置完成"
	else
			echo "计划任务与设定一致，不做改变"
			cron_help="$green定时任务与设定一致$white"
	fi
}

task_add() {
cat >>/etc/crontabs/root <<EOF
#**********这里是JD_Script的定时任务$cron_version版本#100#**********#
0 0 * * * $dir_file/jd.sh run_0  >/tmp/jd_run_0.log 2>&1 #0点0分执行全部脚本#100#
0 2-23/1 * * * $dir_file/jd.sh run_01 >/tmp/jd_run_01.log 2>&1 #种豆得豆收瓶子#100#
0 2-23/2 * * * $dir_file/jd.sh run_02 >/tmp/jd_run_02.log 2>&1 #摇钱树#100#
*/30 2-23 * * * $dir_file/jd.sh run_030 >/tmp/jd_run_030.log 2>&1 #两个工厂#100#
10 2-22/3 * * * $dir_file/jd.sh run_03 >/tmp/jd_run_03.log 2>&1 #天天加速 3小时运行一次，打卡时间间隔是6小时#100#
40 6-18/6 * * * $dir_file/jd.sh run_06_18 >/tmp/jd_run_06_18.log 2>&1 #不是很重要的，错开运行#100#
5 7 * * * $dir_file/jd.sh run_07 >/tmp/jd_run_07.log 2>&1 #不需要在零点运行的脚本#100#
35 10,15,20 * * * $dir_file/jd.sh run_10_15_20 >/tmp/jd_run_10_15_20.log 2>&1 #不是很重要的，错开运行#100#
10 8,12,16 * * * $dir_file/jd.sh run_08_12_16 >/tmp/jd_run_08_12_16.log 2>&1 #宠汪汪兑换礼品#100#
20 12,22 * * * $dir_file/jd.sh update_script that_day >/tmp/jd_update_script.log 2>&1 #22点20更新JD_Script脚本#100#
00 10 */7 * * $dir_file/jd.sh check_cookie_push >/tmp/check_cookie_push.log 2>&1 #每个7天推送cookie相关信息#100#
5 11,19,22 * * * $dir_file/jd.sh update >/tmp/jd_update.log 2>&1 && source /etc/profile #9,11,19,22点05分更新lxk0301脚本#100#
0 9 28 */1 * $node $dir_file_js/jd_all_bean_change.js >/tmp/jd_all_bean_change.log #每个月28号推送当月京豆资产变化#100#
10-20/5 10,12 * * * $node $dir_file_js/jd_live.js	>/tmp/jd_live.log #京东直播#100#
0 0,7 * * * $node $dir_file_js/jd_bean_sign.js >/tmp/jd_bean_sign.log #京东多合一签到#100#
0 0 * * * $node $dir_file_js/star_dreamFactory_tuan.js	>/tmp/star_dreamFactory_tuan.log	#京喜开团#100#
0 10 */7 * * $node $dir_file_js/jd_price.js	>/tmp/jd_price.log	#价保脚本#100#
0 0 * * * $python3 $dir_file/git_clone/curtinlv_script/getFollowGifts/jd_getFollowGift.py >/tmp/jd_getFollowGift.log #关注有礼#100#
0 8,15 * * * $python3 $dir_file/git_clone/curtinlv_script/OpenCard/jd_OpenCard.py  >/tmp/jd_OpenCard.log #开卡程序#100#
#0 1 * * * $python3 $dir_file/git_clone/curtinlv_script/jd_qjd.py >/tmp/jd_qjd.log #抢京豆#100#
59 23 * * 0,1,2,5,6 sleep 57 && $dir_file/jd.sh run_jd_cash >/tmp/jd_cash_exchange.log	#签到领现金兑换#100#
59 23 * * * sleep 50 && $dir_file/jd.sh run_jd_blueCoin >/tmp/jd_jd_blueCoin.log	#京东超市兑换#100#
59 23,7,15 * * * sleep 50 && $dir_file/jd.sh run_jd_joy_reward >/tmp/jd_joy_reward.log	#汪汪兑换积分#100#
45 23 * * * $dir_file/jd.sh kill_ccr #杀掉所有并发进程，为零点准备#100#
46 23 * * * rm -rf /tmp/*.log #删掉所有log文件，为零点准备#100#
20 * * * * $dir_file/jd.sh ss_if >/tmp/ss_if.log #每20分钟检测一下github#100#
###########100##########请将其他定时任务放到底下###############
#**********这里是backnas定时任务#100#******************************#
45 11,20 * * * $dir_file/jd.sh backnas  >/tmp/jd_backnas.log 2>&1 #每4个小时备份一次script,如果没有填写参数不会运行#100#
############100###########请将其他定时任务放到底下###############
EOF
	/etc/init.d/cron restart
	cron_help="$yellow定时任务更新完成，记得看下你的定时任务$white"
}

task_delete() {
        sed -i '/#100#/d' /etc/crontabs/root >/dev/null 2>&1
}

ds_setup() {
	echo "JD_Script删除定时任务设置"
	task_delete
	echo "JD_Script删除全局变量"
	sed -i '/JD_Script/d' /etc/profile >/dev/null 2>&1
	source /etc/profile
	echo "JD_Script定时任务和全局变量删除完成，脚本彻底不会自动运行了"
}

update() {
	cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | grep -v "//'" |grep -v "// '" > $openwrt_script_config/js_cookie.txt

	if [ ! -d $dir_file/git_clone ];then
		mkdir $dir_file/git_clone
	fi

	if [ ! -d $dir_file/git_clone/lxk0301_back ];then
		echo ""
		#git clone -b master git@gitee.com:lxk0301/jd_scripts.git $dir_file/git_clone/lxk0301
		git clone https://github.com/ITdesk01/script_back.git $dir_file/git_clone/lxk0301_back
	else
		cd $dir_file/git_clone/lxk0301_back
		git fetch --all
		git reset --hard origin/main
	fi

	if [ ! -d $dir_file/git_clone/JDHelloWorld ];then
		echo ""
		git clone https://github.com/JDHelloWorld/jd_scripts.git $dir_file/git_clone/JDHelloWorld

	else
		cd $dir_file/git_clone/JDHelloWorld
		git fetch --all
		git reset --hard origin/main
	fi

	if [ ! -d $dir_file/git_clone/curtinlv_script ];then
		echo ""
		git clone https://github.com/curtinlv/JD-Script.git $dir_file/git_clone/curtinlv_script
		curtinlv_script_setup
	else
		cd $dir_file/git_clone/curtinlv_script
		git fetch --all
		git reset --hard origin/main
		curtinlv_script_setup
	fi

	echo -e "$green update$start_script_time $white"
	echo -e "$green开始下载JS脚本，请稍等$white"
#cat script_name.txt | awk '{print length, $0}' | sort -rn | sed 's/^[0-9]\+ //'按照文件名长度降序：
#cat script_name.txt | awk '{print length, $0}' | sort -n | sed 's/^[0-9]\+ //' 按照文件名长度升序

rm -rf $dir_file/config/tmp/*

#lxk0301_back
cat >$dir_file/config/tmp/lxk0301_script.txt <<EOF
	jd_fruit.js			#东东农场
	jd_pet.js			#东东萌宠
	jd_dreamFactory.js		#京喜工厂
	jd_jdfactory.js			#东东工厂
	jd_car.js			#京东汽车，签到满500赛点可兑换500京豆，一天运行一次即可
	jd_club_lottery.js		#摇京豆
	jd_shop.js			#进店领豆
	jd_syj.js			#赚京豆
	jd_kd.js			#京东快递签到 一天运行一次即可
	jd_small_home.js		#东东小窝
	jd_speed.js			#天天加速
	jd_pigPet.js			#金融养猪
	jd_daily_egg.js 		#京东金融-天天提鹅
	jd_sgmh.js			#闪购盲盒长期活动
	jd_ms.js			#京东秒秒币
	jd_speed_sign.js		#京东极速版签到+赚现金任务
	jd_speed_redpocke.js		#极速版红包
	jd_delCoupon.js			#删除优惠券（默认不运行，有需要手动运行）
	#jd_live.js			#京东直播
	jd_moneyTree.js 		#摇钱树
	jd_market_lottery.js 		#幸运大转盘
	jd_health.js			#健康社区
	jd_health_collect.js		#健康社区-收能量
	jd_gold_creator.js		#金榜创造营
	jd_cleancart.js			#清空购物车（默认不执行）
	#jd_get_share_code.js		#获取jd所有助力码脚本
	jd_unsubscribe.js		#取关京东店铺和商品
EOF

for script_name in `cat $dir_file/config/tmp/lxk0301_script.txt | grep -v "#.*js" | awk '{print $1}'`
do
	echo -e "$yellow copy $green$script_name$white"
	cp  $dir_file/git_clone/lxk0301_back/$script_name  $dir_file_js/$script_name
done

#JDHelloWorld
cat >$dir_file/config/tmp/JDHelloWorld_script.txt <<EOF
	jd_joy_new.js			#宠汪汪二代目
EOF

for script_name in `cat $dir_file/config/tmp/JDHelloWorld_script.txt | grep -v "#.*js" | awk '{print $1}'`
do
	echo -e "$yellow copy $green$script_name$white"
	cp  $dir_file/git_clone/JDHelloWorld/$script_name  $dir_file_js/$script_name
done


sleep 5

#longzhuzhu
longzhuzhu_url="https://raw.githubusercontent.com/longzhuzhu/nianyu/main/qx"
cat >$dir_file/config/tmp/longzhuzhu_qx.txt <<EOF
	long_half_redrain.js		#半点红包雨
	long_super_redrain.js 		#整点红包雨
EOF

for script_name in `cat $dir_file/config/tmp/longzhuzhu_qx.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$longzhuzhu_url"
	#wget $nianyuguai_url/$script_name -O $dir_file_js/$script_name
	#update_if
done

#smiek2221
smiek2221_url="https://raw.githubusercontent.com/smiek2221/scripts/master"
cat >$dir_file/config/tmp/smiek2221_url.txt <<EOF
	jd_joy_steal.js			#宠汪汪偷好友积分与狗粮
	gua_MMdou.js                    #赚京豆MM豆
	gua_opencard39.js		#开卡默认不运行
	gua_opencard43.js		#开卡默认不运行
	gua_opencard44.js		#开卡默认不运行
	gua_opencard45.js		#开卡默认不运行
	gua_opencard46.js		#开卡默认不运行
	gua_opencard47.js		#开卡默认不运行
	gua_opencard48.js		#开卡默认不运行
	gua_UnknownTask3.js		#寻找内容鉴赏官
EOF

for script_name in `cat $dir_file/config/tmp/smiek2221_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
{
	url="$smiek2221_url"
	wget $smiek2221_url/$script_name -O $dir_file_js/$script_name
	update_if
}&
done

#cdle
cdle_url="https://raw.githubusercontent.com/cdle/jd_study/main"
cat >$dir_file/config/tmp/cdle_url.txt <<EOF
	jd_morningSc.js			#早起赢现金
	jd_angryKoi.js			#愤怒的锦鲤
	jd_goodMorning.js		#早起福利
	jd_joy_park_help.js 		#汪汪乐园助力
	jd_cash_exchange.js		#签到领现金兑换
EOF

for script_name in `cat $dir_file/config/tmp/cdle_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$cdle_url"
	#wget $cdle_url/$script_name -O $dir_file_js/$script_name
	#update_if
done

#zero205
zero205_url="https://raw.githubusercontent.com/zero205/JD_tencent_scf/main"
cat >$dir_file/config/tmp/zero205_url.txt <<EOF
	jd_jxlhb.js			#京喜领红包
	jd_joy.js			#宠汪汪
	sign_graphics_validate.js
	jd_sign_graphics.js		#京东签到图形验证
	JDJRValidator_Smiek.js
	jd_dpqd.js			#店铺签到
	jd_bean_sign.js			#京东多合一签到
	JDSignValidator.js		#京东多合一签到依赖1
	JDJRValidator_Aaron.js		#京东多合一签到依赖2
	jd_joy_park_newtask.js		# 汪汪乐园过新手任务，有火爆账号的可以手动运行一次（默认不运行）
	jd_superMarket.js		#东东超市
	jd_unsubscriLive.js		#取关主播
	jd_try.js 			#京东试用（默认不启用）
	jd_nzmh.js			#新一期女装盲盒
	jd_qqxing.js			#QQ星系牧场
	jd_get_share_code.js		#获取jd所有助力码脚本
	jd_ttpt.js			#天天拼图
EOF

for script_name in `cat $dir_file/config/tmp/zero205_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
{
	url="$zero205_url"
	wget $zero205_url/$script_name -O $dir_file_js/$script_name
	update_if
}&
done

#Wenmoux
Wenmoux_url="https://raw.githubusercontent.com/Wenmoux/scripts/wen/jd"
cat >$dir_file/config/tmp/Wenmoux_url.txt <<EOF
	jd_ddnc_farmpark.js		#东东乐园 Wenmoux脚本
EOF

for script_name in `cat $dir_file/config/tmp/Wenmoux_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$Wenmoux_url"
	#wget $Wenmoux_url/$script_name -O $dir_file_js/$script_name
	#update_if
done

#Aaron
Aaron_url="https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts"
cat >$dir_file/config/tmp/Aaron_url.txt <<EOF
	jd_mohe.js			#5G超级盲盒
	jd_ccSign.js			#领券中心签到
	jd_cash.js			#签到领现金，每日2毛～5毛长期
	jd_jdzz.js			#京东赚赚长期活动
	jd_cfd_mooncake.js		#京喜财富岛合成月饼
	jd_connoisseur.js		#内容鉴赏官
	jd_joy_reward.js		#宠汪汪积分兑换奖品脚本
	jd_ddworld.js			#东东世界
	jd_redPacket.js			#京东全民开红包(活动入口：京东APP首页-领券-锦鲤红包)
	jd_live.js			#京东直播
	jd_mf.js			#集魔方
	jd_price.js		        #价保脚本
	jd_ys.js			#预售福利机
EOF

for script_name in `cat $dir_file/config/tmp/Aaron_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$Aaron_url"
	wget $Aaron_url/$script_name -O $dir_file_js/$script_name
	update_if
done

#yuannian1112
yuannian1112_url="https://raw.githubusercontent.com/yuannian1112/jd_scripts/main"
cat >$dir_file/config/tmp/yuannian1112_url.txt <<EOF
	jd_plantBean.js			#种豆得豆
	jd_dwapp.js			#积分换话费
EOF

for script_name in `cat $dir_file/config/tmp/yuannian1112_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
{
	url="$yuannian1112_url"
	wget $yuannian1112_url/$script_name -O $dir_file_js/$script_name
	update_if
}&
done

#star261
star261_url="https://raw.githubusercontent.com/star261/jd/main/scripts"
cat >$dir_file/config/tmp/star261_url.txt <<EOF
	jd_jxmc.js			#惊喜牧场(先将新手任务做完，再执行本脚本，不然会出现未知错误)
EOF

for script_name in `cat $dir_file/config/tmp/star261_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$star261_url"
	wget $star261_url/$script_name -O $dir_file_js/$script_name
	update_if
done

#X1a0He
X1a0He_url="https://raw.githubusercontent.com/X1a0He/jd_scripts_fixed/main"
cat >$dir_file/config/tmp/X1a0He_url.txt <<EOF
	jd_car_exchange_xh.js		#京东汽车兑换
	jd_jin_tie_xh.js  		#领金贴
	jd_ljd_xh.js			#领京豆
EOF

for script_name in `cat $dir_file/config/tmp/X1a0He_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$X1a0He_url"
	wget $X1a0He_url/$script_name -O $dir_file_js/$script_name
	update_if
done

#ccwav
ccwav_url="https://raw.githubusercontent.com/ccwav/QLScript2/main"
cat >$dir_file/config/tmp/ccwav_url.txt <<EOF
	jd_bean_change.js		#资产变化强化版by-ccwav
EOF

for script_name in `cat $dir_file/config/tmp/ccwav_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$ccwav_url"
	wget $ccwav_url/$script_name -O $dir_file_js/$script_name
	update_if
done

#Tsukasa007
Tsukasa007_url="https://raw.githubusercontent.com/Tsukasa007/my_script/master"
cat >$dir_file/config/tmp/Tsukasa007_url.txt <<EOF
	#空.js
EOF

for script_name in `cat $dir_file/config/tmp/Tsukasa007_url.txt | grep -v "#.*js" | awk '{print $1}'`
do
	url="$Tsukasa007_url"
	#wget $Tsukasa007_url/$script_name -O $dir_file_js/$script_name
	#update_if
done

	wget https://raw.githubusercontent.com/jiulan/platypus/main/scripts/jd_all_bean_change.js -O $dir_file_js/jd_all_bean_change.js #京东月资产变动通知
	wget https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_products_detail.js -O $dir_file_js/jx_products_detail.js #京喜工厂商品列表详情
	wget https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts/utils/JDJRValidator_Pure.js -O $dir_file_js/JDJRValidator_Pure.js

#将所有文本汇总
echo > $dir_file/config/collect_script.txt
for i in `ls  $dir_file/config/tmp`
do
	cat $dir_file/config/tmp/$i >> $dir_file/config/collect_script.txt
done

cat >>$dir_file/config/collect_script.txt <<EOF
	jd_fission.js			#东东超市限时抢京豆
	gua_city.js			#城城分现金
	gua_UnknownTask2.js		#关注频道、抽奖(默认不运行)
	jd_dianjing.js			#电竞经理
	star_dreamFactory_tuan.js 	#京喜开团　star261脚本
	jd_OpenCard.py 			#开卡程序
	jd_getFollowGift.py 		#关注有礼
	jd_all_bean_change.js 		#京东月资产变动通知
	jd_check_cookie.js		#检测cookie是否存活（暂时不能看到还有几天到期）
	getJDCookie.js			#扫二维码获取cookie有效时间可以90天
	jx_products_detail.js		#京喜工厂商品列表详情
	jdDreamFactoryShareCodes.js	#京喜工厂ShareCodes
	jdFruitShareCodes.js		#东东农场ShareCodes
	jdPetShareCodes.js		#东东萌宠ShareCodes
	jdPlantBeanShareCodes.js	#种豆得豆ShareCodes
	jdFactoryShareCodes.js		#东东工厂ShareCodes
	jdJxncShareCodes.js		#京喜农场ShareCodes
EOF

#删掉过期脚本
cat >/tmp/del_js.txt <<EOF
	jd_qycl.js			#企有此礼
	jd_superBrand.js		#特物Z|万物皆可国创
	gua_opencard41.js		#开卡默认不运行
	gua_opencard42.js
EOF

for script_name in `cat /tmp/del_js.txt | grep -v "#.*js" | awk '{print $1}'`
do
	rm -rf $dir_file_js/$script_name
done


	if [ $? -eq 0 ]; then
		echo -e ">>$green脚本下载完成$white"
	else
		clear
		echo "脚本下载没有成功，重新执行代码"
		update
	fi
	chmod 755 $dir_file_js/*
	kill_index
	index_js
	additional_settings
	concurrent_js_update
	source /etc/profile
	echo -e "$green update$stop_script_time $white"
	task #更新完全部脚本顺便检查一下计划任务是否有变

}

update_if() {
	if [ $? -eq 0 ]; then
			echo -e ""
	else
		num="1"
		eeror_num="1"
		while [[ ${num} -gt 0 ]]; do
			wget $url/$script_name -O $dir_file_js/$script_name
			if [ $? -eq 0 ]; then
				num=$(expr $num - 1)
			else
				if [ $eeror_num -ge 5 ];then
					echo ">> $yellow$script_name$white下载$eeror_num次都失败，跳过这个下载"
					num=$(expr $num - 1)
				else
					echo -e ">> $yellow$script_name$white下载失败,尝试第$eeror_num次下载"
					eeror_num=$(expr $eeror_num + 1)
				fi
			fi
		done
	fi
}

update_script() {
	echo -e "$green update_script$start_script_time $white"
	cd $dir_file
	git fetch --all
	git reset --hard origin/main
	echo -e "$green update_script$stop_script_time $white"
}

ccr_run() {
#这里有的就不要加到concurrent_js_run_07
cat >/tmp/jd_tmp/ccr_run <<EOF
	jd_connoisseur.js		#内容鉴赏官
	gua_UnknownTask3.js		#寻找内容鉴赏官
	jd_jdzz.js			#京东赚赚长期活动
	jd_cfd_mooncake.js		#京喜财富岛合成月饼
	jd_ddworld.js			#东东世界
	jd_fission.js			#东东超市限时抢京豆
	jd_fission.js			#东东超市限时抢京豆(多加一次领奖励)
EOF
	for i in `cat /tmp/jd_tmp/ccr_run | grep -v "#.*js" | awk '{print $1}'`
	do
	{
		$node $openwrt_script/JD_Script/js/$i
		$run_sleep
	}&
	done
}

concurrent_js_run_07() {
#这里的也不会并发
cat >/tmp/jd_tmp/concurrent_js_run_07 <<EOF
        jd_jxlhb.js			#京喜领红包
	jd_redPacket.js			#京东全民开红包(活动入口：京东APP首页-领券-锦鲤红包)
	jd_dreamFactory.js 		#京喜工厂
	gua_city.js			#城城分现金
EOF
	for i in `cat /tmp/jd_tmp/concurrent_js_run_07 | grep -v "#.*js" | awk '{print $1}'`
	do
	{
		$node $openwrt_script/JD_Script/js/$i
		$run_sleep
	}&
	done
	wait
	$node $openwrt_script/JD_Script/js/jd_bean_change.js 	#资产变动强化版
	checklog #检测log日志是否有错误并推送
}


run_0() {
cat >/tmp/jd_tmp/run_0 <<EOF
	jd_car.js 			#京东汽车，签到满500赛点可兑换500京豆，一天运行一次即可
	jd_cash.js 			#签到领现金，每日2毛～5毛长期
	jd_sgmh.js 			#闪购盲盒长期活动
	jd_syj.js 			#十元街签到,一天一次即可，一周30豆子
	jd_market_lottery.js 		#幸运大转盘
	jd_jin_tie_xh.js  		#领金贴
	jd_dreamFactory.js 		#京喜工厂
	jd_ddnc_farmpark.js		#东东乐园
	jd_sign_graphics.js		#京东签到图形验证
	jd_dpqd.js			#店铺签到
	jd_ccSign.js			#领券中心签到
	jd_unsubscribe.js 		#取关店铺，没时间要求
	jd_ljd_xh.js			#领京豆
EOF
	echo -e "$green run_0$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_0 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done
	run_08_12_16
	run_06_18
	run_10_15_20
	run_03
	run_030
	run_01
	echo -e "$green run_0$stop_script_time $white"
}

run_020() {
	echo -e "$green run_020$start_script_time $white"
	echo "run_020暂时没有东西"
	echo -e "$green run_020$stop_script_time $white"
}

run_030() {
cat >/tmp/jd_tmp/run_030 <<EOF
	gua_wealth_island.js 		#财富岛新版
	jd_jdfactory.js 		#东东工厂，不是京喜工厂
	jd_jxmc.js			#惊喜牧场
	jd_health_collect.js		#健康社区-收能量
	long_half_redrain.js		#半点红包雨
	jd_dreamFactory.js 		#京喜工厂
EOF
	echo -e "$green run_030$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_030 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done

	echo -e "$green run_030$stop_script_time $white"
}

opencard() {
cat >/tmp/jd_tmp/opencard <<EOF
	gua_opencard24.js		#开卡默认不运行
	gua_opencard25.js		#开卡默认不运行
EOF

	echo -e "$green opencard$start_script_time $white"

	for i in `cat /tmp/jd_tmp/opencard | grep -v "#.*js" | awk '{print $1}'`
	do
	{
		$node $dir_file_js/$i
		$run_sleep
	}&
	done
	wait

	echo -e "$green opencard$stop_script_time $white"
}

run_01() {
cat >/tmp/jd_tmp/run_01 <<EOF
	jd_plantBean.js 		#种豆得豆，没时间要求，一个小时收一次瓶子
	long_super_redrain.js		#整点红包雨
	jd_cfd_mooncake.js		#京喜财富岛合成月饼
EOF
	echo -e "$green run_01$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_01 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done

	echo -e "$green run_01$stop_script_time $white"
}

run_02() {
cat >/tmp/jd_tmp/run_02 <<EOF
	jd_joy.js			#宠汪汪
	jd_moneyTree.js 		#摇钱树
EOF
	echo -e "$green run_02$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_02 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done

	echo -e "$green run_02$stop_script_time $white"
}

run_03() {
#这里不会并发
cat >/tmp/jd_tmp/run_03 <<EOF
	jd_joy_new.js 			#jd宠汪汪，零点开始，11.30-15:00 17-21点可以领狗粮
	jd_speed.js 			#天天加速 3小时运行一次，打卡时间间隔是6小时
	jd_health.js			#健康社区
	jd_mohe.js			#5G超级盲盒
	jd_dianjing.js			#电竞经理
	jd_joy_park_help.js 		#汪汪乐园助力
	jd_qqxing.js			#QQ星系牧场
EOF
	echo -e "$green run_03$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_03 | grep -v "#.*js" | awk '{print $1}'`
	do
	{
		$node $dir_file_js/$i
		$run_sleep
	}&
	done
	wait

	echo -e "$green run_03$stop_script_time $white"
}


run_06_18() {
cat >/tmp/jd_tmp/run_06_18 <<EOF
	jd_shop.js 			#进店领豆，早点领，一天也可以执行两次以上
	jd_fruit.js 			#东东水果，6-9点 11-14点 17-21点可以领水滴
	jd_pet.js 			#东东萌宠，跟手机商城同一时间
	#jd_joy_steal.js 		#可偷好友积分，零点开始，六点再偷一波狗粮
	jd_superMarket.js 		#东东超市,6点 18点多加两场用于收金币
	jd_gold_creator.js		#金榜创造营
	jd_goodMorning.js		#早起福利
	jd_nzmh.js			#新一期女装盲盒
	jd_dwapp.js			#积分换话费
	jd_mf.js			#集魔方
	jd_ttpt.js			#天天拼图
	jd_ys.js			#预售福利机
EOF
	echo -e "$green run_06_18$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_06_18 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done

	echo -e "$green run_06_18$stop_script_time $white"
}

run_07() {
cat >/tmp/jd_tmp/run_07 <<EOF
	jd_morningSc.js			#早起赢现金
	jd_ddnc_farmpark.js		#东东乐园
	jd_kd.js 			#京东快递签到 一天运行一次即可
	jd_club_lottery.js 		#摇京豆，没时间要求
	jd_jdzz.js 			#京东赚赚长期活动
	jd_ms.js 			#京东秒秒币 一个号大概60
	jd_sgmh.js 			#闪购盲盒长期活动
	jd_speed_sign.js 		#京东极速版签到+赚现金任务
	jd_speed_redpocke.js		#极速版红包
	jd_cash.js 			#签到领现金，每日2毛～5毛长期
	jd_jin_tie_xh.js  		#领金贴
	jd_unsubscribe.js 		#取关店铺，没时间要求
        gua_MMdou.js                    #赚京豆MM豆
	jd_unsubscriLive.js		#取关主播
EOF
	echo -e "$green run_07$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_07 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done
	echo -e "$green run_07$stop_script_time $white"
}


run_08_12_16() {
cat >/tmp/jd_tmp/run_08_12_16 <<EOF
	jd_syj.js 			#赚京豆
EOF
	echo -e "$green run_08_12_16$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_08_12_16 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done

	echo -e "$green run_08_12_16$stop_script_time $white"
}

run_10_15_20() {
cat >/tmp/jd_tmp/run_10_15_20 <<EOF
	jd_superMarket.js 		#东东超市,0 10 15 20四场补货加劵
	jd_speed_sign.js 		#京东极速版签到+赚现金任务
	jd_speed_redpocke.js		#极速版红包
EOF

	echo -e "$green run_10_15_20$start_script_time $white"

	for i in `cat /tmp/jd_tmp/run_10_15_20 | grep -v "#.*js" | awk '{print $1}'`
	do
		$node $dir_file_js/$i
		$run_sleep
	done
	echo -e "$green run_10_15_20$stop_script_time $white"
}

run_jd_cash() {
cat >/tmp/jd_tmp/run_jd_cash <<EOF
	jd_cash_exchange.js #领现金兑换
	jd_car_exchange_xh.js #京东汽车兑换
EOF
	jd_cash_num="30"
	while [[ ${jd_cash_num} -gt 0 ]]; do
		$node $dir_file_js/jd_cash_exchange.js &
		sleep 1
		jd_cash_num=$(($jd_cash_num - 1))
	done
}

run_jd_joy_reward() {
cat >/tmp/jd_tmp/run_jd_joy_reward <<EOF
	jd_joy_reward.js		#宠汪汪积分兑换奖品脚本
EOF
	jd_joy_reward_num="5"
	while [[ ${jd_joy_reward_num} -gt 0 ]]; do
		$node $dir_file_js/jd_joy_reward.js &
		sleep 2
		jd_joy_reward_num=$(($jd_joy_reward_num - 1))
	done
}


run_jd_blueCoin() {
cat >/tmp/jd_tmp/run_jd_blueCoin <<EOF
	jd_blueCoin.py	#东东超市兑换
EOF
	jd_blueCoin_num="30"
	while [[ ${jd_blueCoin_num} -gt 0 ]]; do
		$python3 $dir_file_js/jd_blueCoin.py &
		sleep 1
		jd_blueCoin_num=$(($jd_blueCoin_num - 1))
	done
}





curtinlv_script_setup() {
	#开卡
	curtinlv_cookie=$(cat $openwrt_script_config/jdCookie.js | grep "pt_key" | grep -v "pt_key=xxx" | awk -F "'," '{print $1}' | sed "s/'//g" | sed "s/$/\&/" | sed 's/[[:space:]]//g' | sed ':t;N;s/\n//;b t' | sed "s/&$//" )
	sed -i "/JD_COOKIE = ''/d" $dir_file/git_clone/curtinlv_script/OpenCard/OpenCardConfig.ini
	sed -i "3a \JD_COOKIE = '$curtinlv_cookie'" $dir_file/git_clone/curtinlv_script/OpenCard/OpenCardConfig.ini
	sed -i "s/sleepNum = 0/sleepNum = 0.5/g" $dir_file/git_clone/curtinlv_script/OpenCard/OpenCardConfig.ini
	if [ ! -L "$dir_file_js/jd_OpenCard.py" ]; then
		rm -rf $dir_file_js/jd_OpenCard.py
		ln -s $dir_file/git_clone/curtinlv_script/OpenCard/jd_OpenCard.py $dir_file_js/jd_OpenCard.py
	fi

	if [ ! -L "$dir_file_js/OpenCardConfig.ini" ]; then
		rm -rf $dir_file_js/OpenCardConfig.ini
		ln -s $dir_file/git_clone/curtinlv_script/OpenCard/OpenCardConfig.ini $dir_file_js/OpenCardConfig.ini
	fi

	#关注有礼
	cat $openwrt_script_config/js_cookie.txt > $dir_file/git_clone/curtinlv_script/getFollowGifts/JDCookies.txt
	if [ ! -L "$dir_file_js/jd_getFollowGift.py" ]; then
		rm -rf $dir_file_js/jd_getFollowGift.py
		ln -s $dir_file/git_clone/curtinlv_script/getFollowGifts/jd_getFollowGift.py  $dir_file_js/jd_getFollowGift.py
	fi

	#抢京豆
	cat $openwrt_script_config/js_cookie.txt > $dir_file/git_clone/curtinlv_script/JDCookies.txt
	if [ ! -L "$dir_file_js/jd_qjd.py" ]; then
		rm -rf $dir_file_js/jd_qjd.py
		ln -s $dir_file/git_clone/curtinlv_script/jd_qjd.py  $dir_file_js/jd_qjd.py
	fi

	#软连接
	if [ ! -L "$dir_file_js/JDCookies.txt" ]; then
		rm -rf $dir_file_js/JDCookies.txt
		ln -s $dir_file/git_clone/curtinlv_script/JDCookies.txt  $dir_file_js/JDCookies.txt
	fi


	#东东超市商品兑换
	cp $dir_file/git_clone/curtinlv_script/jd_blueCoin.py $dir_file_js/jd_blueCoin.py
}

script_name() {
	clear
	echo -e "$green 显示所有JS脚本名称与作用$white"
	cat $dir_file/config/collect_script.txt
}


jx() {
	echo -e "$green 查询京喜商品生产所用时间$start_script_time $white"
	$node $dir_file_js/jx_products_detail.js
	echo -e "$green 查询完成$stop_script_time $white"
}

jd_sharecode() {
	echo -e "$green 查询京东助力码$start_script_time $white"
	$node $dir_file_js/jd_get_share_code.js #获取jd所有助力码脚本
	echo -e "$green查询完成$start_script_time $white"
	echo ""
	jd_sharecode_if
}
jd_sharecode_if() {
	echo -e "$green============是否生成提交助力码格式，方便提交助力码，1.生成 2.不生成============$white"
	read -p "请输入：" code_Decide
	if [ "$code_Decide" == "1" ];then
		jd_sharecode_generate
	elif [ "$code_Decide" == "2" ];then
		echo "不做任何操作"
	else
		echo "请不要随便乱输！！！"
		jd_sharecode_if
	fi

}
jd_sharecode_generate() {
read -p "请输入你的名字和进群时间（例子：zhangsan_20210314，注意zhangsan是个例子，请写自己的名字～～～）：" you_name
echo -e "$green请稍等，号越多生成会比较慢。。。$white"
$node $dir_file_js/jd_get_share_code.js >/tmp/get_share_code

cat > /tmp/code_name <<EOF
京东农场 fr
京东萌宠 pet
种豆得豆 pb
京喜工厂 df
京东赚赚 jdzz
签到领现金 jdcash
闪购盲盒 jdsgmh
财富岛 cfd
EOF


code_number="0"
echo -e "$green============整理$you_name的Code============$white"

for i in `cat /tmp/code_name | awk '{print $1}'`
do
	code_number=$(expr $code_number + 1)
	o=$(cat /tmp/get_share_code | grep  "$i" | wc -l)
	p=$(cat /tmp/code_name | awk -v  a="$code_number" -v b="$you_name"  -v c="_" 'NR==a{print b c$2}')
	echo ""
	cat /tmp/get_share_code | grep  "$i" | awk -F '】' '{print $2}' | sed ':t;N;s/\n/@/;b t'  | sed "s/$/\"/" | sed "s/^/$i有$o个\Code：$p=\"/"
	echo ""
done
echo -e "$green============整理完成，可以提交了（没加群的忽略）======$white"

}


jd_try() {
cat >/tmp/jd_tmp/jd_try_variable <<EOF
	JD_TRY_TITLEFILTERS
	JD_TRY_WHITELIST
	JD_TRY_PRICE
	JD_TRY_MINSUPPLYNUM
	JD_TRY_TABID
	JD_TRY_PLOG
	JD_TRY_MAXLENGTH
	JD_TRY_APPLYNUMFILTER
	JD_TRY_TRIALPRICE
EOF

	for i in `cat /tmp/jd_tmp/jd_try_variable | grep -v "#.*js" | awk '{print $1}'`
	do
		export $i=$(cat $openwrt_script_config/jd_openwrt_script_config.txt | grep "$i" | awk -F "\"" '{print $2}')
	done

	JD_TRY=$(cat $openwrt_script_config/jd_openwrt_script_config.txt | grep "JD_TRY=" | awk -F "\"" '{print $2}')
	if [ $JD_TRY == "true" ];then
		export JD_TRY="true"
		echo -e "$green >> 开始执行试用脚本$white"
		for i in `ls $dir_file/jd_try_file/tmp | grep "jd_try"`
		do
		{
			echo -e "$green >> 开始跑$i$white"
			$node $dir_file/jd_try_file/tmp/$i
		} &
		done
		wait
	else
		echo -e "$red >> 试用脚本开关没有打开$white"
	fi
}

concurrent_js_update() {
	if [ "$ccr_if" == "yes" ];then
		js_amount=$(cat $openwrt_script_config/js_cookie.txt |wc -l)
		echo -e "$green>> 你有$js_amount个ck要创建并发文件夹$white"
		start_date=$(date +%s)
		for i in `ls $ccr_js_file | grep -E "^js"`
		do
			rm -rf $ccr_js_file/$i
		done

		for ck_num in `seq 1 $js_amount`
		do
		{
			mkdir $ccr_js_file/js_$ck_num
			cp $openwrt_script_config/jdCookie.js $ccr_js_file/js_$ck_num/jdCookie.js

			if [ ! -L "$ccr_js_file/js_$ck_num/sendNotify.js" ]; then
				rm -rf $$ccr_js_file/js_$ck_num/sendNotify.js
				ln -s $openwrt_script_config/sendNotify.js $ccr_js_file/js_$ck_num/sendNotify.js
			fi

			js_cookie_obtain=$(sed -n $ck_num\p "$openwrt_script_config/js_cookie.txt") #获取pt
			sed -i '/pt_pin/d' $ccr_js_file/js_$ck_num/jdCookie.js >/dev/null 2>&1
			sed -i "5a $js_cookie_obtain" $ccr_js_file/js_$ck_num/jdCookie.js

			for i in `ls $dir_file_js | grep -v 'jdCookie.js\|sendNotify.js\|jddj_cookie.js\|log'`
			do
				cp -r $dir_file_js/$i $ccr_js_file/js_$ck_num/$i
			done
		} &
		done
		#wait
		sleep 3

		ps_cp=$(ps -ww | grep "cp -r" | grep -v grep | wc -l)
		while [ $ps_cp -gt 0 ];do
			sleep 1
			ps_cp=$(ps -ww | grep "cp -r" | grep -v grep| wc -l)
		done
		end_date=$(date +%s)
		result_date=$(( $start_date - $end_date ))
		echo -e "$yellow 耗时:$green$result_date秒$white"
		echo -e "$green>> 创建$js_amount个并发文件夹完成$white"
	else
		echo -e "$yellow>> 并发开关没有打开$white"
	fi

}

concurrent_js_clean(){
		if [ "$ccr_if" == "yes" ];then
			echo -e "$yellow收尾一下$white"
			for i in `ps -ww | grep "$action" | grep -v 'grep\|kill_ccr' | awk '{print $1}'`
			do
				echo "开始kill $i"
				kill -9 $i
			done
		fi
}

kill_ccr() {
	if [ "$ccr_if" == "yes" ];then
		echo -e "$green>>终止并发程序启动。请稍等。。。。$white"
		if [ `ps -ww | grep "js$" | grep "JD_Script"| grep -v 'grep\|index.js\|jd_try.js\|ssrplus' | awk '{print $1}' |wc -l` == "0" ];then
			sleep 2
			echo ""
			echo -e "$green我曾经跨过山和大海，也穿过人山人海。。。$white"
			sleep 2
			echo -e "$green直到来到你这里。。。$white"
			sleep 2
			echo -e "$green逛了一圈空空如也，你确定不是在消遣我？？？$white"
			sleep 2
			echo -e "$green后台都没有进程妹子，散了散了。。。$white"
		else
			for i in `ps -ww | grep "js$" | grep "JD_Script"| grep -v 'grep\|index.js\|jd_try.js\|ssrplus' | awk '{print $1}'`
			do
				kill -9 $i
				echo "kill $i"
			done
			concurrent_js_clean
			clear
			echo -e "$green再次检测一下并发程序是否还有存在$white"
			if [ `ps -ww | grep "js$" | grep "JD_Script"| grep -v 'grep\|index.js\|jd_try.js\|ssrplus' | awk '{print $1}' |wc -l` == "0" ];then
				echo -e "$yellow>>并发程序已经全部结束$white"
			else
				echo -e "$yellow！！！检测到并发程序还有存在，再继续杀，请稍等。。。$white"
				sleep 1
				kill_ccr
			fi
		fi
	else
		echo -e "$green>>你并发开关都没有打开，我终止啥？？？$white"
	fi
}

if_ps() {
	ps_if=$(ps -ww | grep "js$" | grep "JD_Script"| grep -v 'grep\|index.js\|jd_try.js\|ssrplus' | awk '{print $1}' |wc -l)
	num1="20"

	echo -e "$green>> $action并发程序还有$yellow$ps_if$green进程在后台，等待($num1秒)，后再检测一下$white"
	echo -ne "\r"
	sleep $num1

	echo ""
	if [ "$ps_if" == "0" ];then
		echo -e "$yellow>>并发程序已经结束$white"
	else
		sleep $num1
		echo -ne ">> $action并发程序还有$yellow$ps_if$green进程在后台，等待($num1秒)，后再检测一下$white"
		echo -ne "\r"
		if_ps
	fi
	#for i in `ps -ww | grep "jd.sh run_" | grep -v grep | awk '{print $1}'`;do kill -9 $i ;done
}

concurrent_js() {
	if [ $(ls $ccr_js_file/ | wc -l ) -gt "0" ];then
		for i in `ls $ccr_js_file/`
		do
			dir_file_js="$ccr_js_file/$i"
			$action &
		done
	else
		echo -e "$green>>并发文件夹为空开始下载$white"
			update
			concurrent_js_if
	fi
}

concurrent_js_if() {
	if [ "$ccr_if" == "yes" ];then
		echo -e "$green>>检测到开启了账号并发模式$white"
		case "$action1" in
		run_0)
			action="$action1"
			ccr_run
			concurrent_js && if_ps
			if [ ! $action2 ];then
				if_ps
				concurrent_js_clean
			else
				case "$action2" in
				run_07)
					action="$action2"
					ccr_run
					concurrent_js && if_ps
					concurrent_js_run_07 && if_ps
					concurrent_js_clean
				;;
				esac
			fi
		;;
		run_07)
			action="$action1"
			ccr_run
			concurrent_js && if_ps
			concurrent_js_run_07 && if_ps
			concurrent_js_clean
		;;
		run_03)
			run_03
		;;
		run_030)
			action="$action1"
			concurrent_js
			if_ps
			concurrent_js_clean
		;;
		run_01|run_02|opencard|run_08_12_16|run_020|run_10_15_20|run_06_18)
			action="$action1"
			concurrent_js
			if_ps
			concurrent_js_clean
		;;
		esac
	else
		case "$action1" in
			run_0)
			ccr_run
			$action1
			;;
			run_07)
			ccr_run
			$action1
			concurrent_js_run_07
			;;
			run_01|run_06_18|run_10_15_20|run_03|run_02|opencard|run_08_12_16|run_07|run_030|run_020)
			$action1
			;;
		esac

		if [[ -z $action2 ]]; then
			echo ""
		else
			case "$action2" in
			run_0)
			ccr_run
			$action2
			;;
			run_07)
			ccr_run
			$action2
			concurrent_js_run_07
			;;
			run_01|run_06_18|run_10_15_20|run_03|run_02|opencard|run_08_12_16|run_07|run_020)
			$action2
			;;
		esac
		fi
	fi
}


checktool() {
	i=1
	while [ 100 -ge 0 ];do
		ps_check=$(ps -ww |grep "JD_Script" | grep -v "grep" |awk '{print $1}' | wc -l )
		echo "---------------------------------------------------------------------------"
		echo -e  "		检测者工具第$green$i$white次循环输出(ctrl+c终止)"
		echo "---------------------------------------------------------------------------"
		echo "负载情况：`uptime`"
		echo ""
		echo "进程状态："
		if [ "$ps_check" == "0"  ];then
			echo ""
			echo "	没有检测到并发进程"
		else
			ps -ww | grep "JD_Script" |grep -v 'grep\|checktool'
		fi
		sleep 2
		clear
		i=`expr $i + 1`
	done
}

getcookie() {
	#彻底完成感谢echowxsy大力支持
	echo ""
	echo -e "$yellow 温馨提示，如果你已经有cookie，不想扫码直接添加，可以用$green sh \$jd addcookie$white 增加cookie $green sh \$jd delcookie$white 删除cookie"
	$node $dir_file_js/getJDCookie.js && addcookie && addcookie_wait
}

addcookie() {
	
	if [ `cat /tmp/getcookie.txt | wc -l` == "1"  ];then
		clear
		you_cookie=$(cat /tmp/getcookie.txt)
		if [[ -z $you_cookie ]]; then
			echo -e "$red cookie为空值，不做其他操作。。。$white"
			exit 0
		else
			echo -e "\n$green已经获取到cookie，稍等。。。$white"
			sleep 1
		fi
	else
		clear
		echo "---------------------------------------------------------------------------"
		echo -e "		新增cookie或者更新cookie"
		echo "---------------------------------------------------------------------------"
		echo ""
		echo -e "$yellow单账号例子：$white"
		echo ""
		echo -e "pt_key=xxxxxx;pt_pin=jd_xxxxxx; //二狗子"
		echo ""
		echo -e "$yellow多账号例子：（用＆分割账号）$white"
		echo ""
		echo -e "pt_key=xxxxxx;pt_pin=jd_xxxxxx; //二狗子&pt_key=xxxxxx;pt_pin=jd_xxxxxx; //雪糕兄"
		echo ""
		echo -e "$yellow pt_key=$green密码  $yellow pt_pin=$green 账号  $yellow// 二狗子 $green(备注这个账号是谁的)$white"
		echo ""
		echo -e "$yellow 请不要乱输，如果输错了可以用$green sh \$jd delcookie$yellow删除,\n 或者你手动去$green$openwrt_script_config/jdCookie.js$yellow删除也行\n$white"
		echo "---------------------------------------------------------------------------"
		read -p "请填写你获取到的cookie(一次只能一个cookie,多个cookie要用＆连接起来)：" you_cookie
		if [[ -z $you_cookie ]]; then
			echo -e "$red请不要输入空值。。。$white"
			exit 0
		fi

	fi

	echo "$you_cookie" > /tmp/you_cookie.txt
	sed -i "s/&/\n/g" /tmp/you_cookie.txt
	echo -e "$yellow\n开始为你查找是否存在这个cookie，有就更新，没有就新增。。。$white\n"
	sleep 2
	if_you_cookie=$(cat /tmp/you_cookie.txt | wc -l)
	if [ $if_you_cookie == "1" ];then
		you_cookie=$(cat /tmp/you_cookie.txt)
		new_pt=$(echo $you_cookie)
		pt_pin=$(echo $you_cookie | awk -F "pt_pin=" '{print $2}' | awk -F ";" '{print $1}')
		pt_key=$(echo $you_cookie | awk -F "pt_key=" '{print $2}' | awk -F ";" '{print $1}')
		if [ `echo "$pt_pin" | wc -l` == "1"  ] && [ `echo "$pt_key" | wc -l` == "1" ];then
			addcookie_replace
		else
			echo "$pt_pin $pt_key　$red异常$white"
			sleep 2
		fi
	else
		num="1"
		while [ $if_you_cookie -ge $num ];do
			clear
			echo  "------------------------------------------------------------------------------"
			echo -e "你一共输入了$yellow$if_you_cookie$white条cookie现在开始替换第$green$num$white条cookie"
			you_cookie=$(sed -n "$num p" /tmp/you_cookie.txt)
			new_pt=$(echo $you_cookie)
			pt_pin=$(echo $you_cookie | awk -F "pt_pin=" '{print $2}' | awk -F ";" '{print $1}')
			pt_key=$(echo $you_cookie | awk -F "pt_key=" '{print $2}' | awk -F ";" '{print $1}')

			if [ `echo "$pt_pin" | wc -l` == "1"  ] && [ `echo "$pt_key" | wc -l` == "1" ];then
				addcookie_replace
				sleep 2
			else
				echo -e "$pt_pin $pt_key　$red异常$white"
				sleep 2
			fi
			num=$(( $num + 1))
		done

	fi
	del_expired_cookie
}

addcookie_replace(){
	if [ `cat $openwrt_script_config/jdCookie.js | grep "$pt_pin" | wc -l` == "1" ];then
		echo -e "$green检测到 $yellow${pt_pin}$white 已经存在，开始更新cookie。。$white\n"
		sleep 2
		old_pt=$(cat $openwrt_script_config/jdCookie.js | grep "$pt_pin" | sed -e "s/',//g" -e "s/'//g")
		old_pt_key=$(cat $openwrt_script_config/jdCookie.js | grep "$pt_pin" | awk -F "pt_key=" '{print $2}' | awk -F ";" '{print $1}')
		sed -i "s/$old_pt_key/$pt_key/g" $openwrt_script_config/jdCookie.js
		echo -e "$green 旧cookie：$yellow${old_pt}$white\n\n$green更新为$white\n\n$green   新cookie：$yellow${new_pt}$white\n"
		echo  "------------------------------------------------------------------------------"
	else
		echo -e "$green检测到 $yellow${pt_pin}$white 不存在，开始新增cookie。。$white\n"
		sleep 2
		cookie_quantity=$( cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | wc -l)
		i=$(expr $cookie_quantity + 5)
		if [ $i == "5" ];then
			sed -i "5a \  '$you_cookie\'," $openwrt_script_config/jdCookie.js
		else
			sed -i "$i a\  '$you_cookie\'," $openwrt_script_config/jdCookie.js
		fi
		echo -e "\n已将新cookie：$green${you_cookie}$white\n\n插入到$yellow$openwrt_script_config/jdCookie.js$white 第$i行\n"
		cookie_quantity1=$( cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | wc -l)
		echo  "------------------------------------------------------------------------------"
		echo -e "$yellow你增加了账号：$green${pt_pin}$white$yellow 现在cookie一共有$cookie_quantity1个，具体以下：$white"
		cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | sed -e "s/',//g" -e "s/'//g"
		echo  "------------------------------------------------------------------------------"
	fi

	check_cooike
	sed -n  '1p' $openwrt_script_config/check_cookie.txt
	grep "$pt_pin" $openwrt_script_config/check_cookie.txt
	rm -rf /tmp/getcookie.txt
}

addcookie_wait(){
	echo ""
	read -p "是否需要继续获取cookie（1.需要  2.不需要 ）：" cookie_continue
	if [ "$cookie_continue" == "1" ];then
		echo "请稍等。。。"
		sleep 1
		clear
		getcookie
	elif [ "$cookie_continue" == "2" ];then
		echo "退出脚本。。。"
		exit 0
	else
		echo "请不要乱输，退出脚本。。。"
		exit 0
	fi

}

del_expired_cookie() {
	echo -e "$green整理一下check_cookie.txt,删掉一些过期的信息$white"
	for i in `cat $openwrt_script_config/check_cookie.txt | awk '{print $2}'| grep -v "Cookie"`
	do
		jd_cookie=$(grep "$i" $openwrt_script_config/jdCookie.js | awk -F "pt_pin=" '{print $2}' | awk -F ";" '{print $1}')
		if [ ! $jd_cookie ];then
			echo -e "$red$i$white在$openwrt_script_config/jdCookie.js找不到"
		else
			if [ "$jd_cookie" == "$i" ];then
				echo -e "$green$i$white在$openwrt_script_config/jdCookie.js正常存在"
				echo ""
			else
				sed -i "/$i/d" $openwrt_script_config/check_cookie.txt
			fi
		fi
	done
}

delcookie() {
	cookie_quantity=$(cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | wc -l)
	if [ `cat $openwrt_script_config/jdCookie.js | grep "$pt_pin" | wc -l` -ge "1" ];then
		echo "---------------------------------------------------------------------------"
		echo -e "		删除cookie"
		echo "---------------------------------------------------------------------------"
		echo -e "$green例子：$white"
		echo ""
		echo -e "$green pt_key=jd_10086jd_10086jd_10086jd_10086jd_10086jd_10086jd_10086;pt_pin=jd_10086; //二狗子$white"
		echo ""
		echo -e "$yellow 请填写你要删除的cookie（// 备注 或者pt_pin 名都行）：$green二狗子 $white"
		echo -e "$yellow 请填写你要删除的cookie（// 备注 或者pt_pin 名都行）：$green jd_10086$white "
		echo "---------------------------------------------------------------------------"
		echo -e "$yellow你的cookie有$cookie_quantity个，具体如下：$white"
		cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | sed -e "s/',//g" -e "s/'//g"
		echo "---------------------------------------------------------------------------"
		echo ""
		read -p "请填写你要删除的cookie（// 备注 或者pt_pin 名都行）：" you_cookie
		if [[ -z $you_cookie ]]; then
			echo -e "$red请不要输入空值。。。$white"
			exit 0
		fi
	
		sed -i "/$you_cookie/d" $openwrt_script_config/jdCookie.js
		clear
		echo "---------------------------------------------------------------------------"
		echo -e "$yellow你删除账号或者备注：$green${you_cookie}$white$yellow 现在cookie还有`cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | wc -l`个，具体以下：$white"
		cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | sed -e "s/',//g" -e "s/'//g"
		echo "---------------------------------------------------------------------------"
		echo ""
		read -p "是否需要删除cookie（1.需要  2.不需要 ）：" cookie_continue
		if [ "$cookie_continue" == "1" ];then
			echo "请稍等。。。"
			delcookie
		elif [ "$cookie_continue" == "2" ];then
			echo "退出脚本。。。"
			exit 0
		else
			echo "请不要乱输，退出脚本。。。"
			exit 0
		fi
	else
		echo -e "$yellow你的cookie空空如也，比地板都干净，你想删啥。。。。。$white"
	fi

}

check_cooike() {
#将cookie获取时间导入文本
	if [ ! -f $openwrt_script_config/check_cookie.txt  ];then
		echo "备注      Cookie             添加时间      预计到期时间(不保证百分百准确)" > $openwrt_script_config/check_cookie.txt
	fi
	sed -i "/添加时间/d" $openwrt_script_config/check_cookie.txt
	sed -i "1i\备注      Cookie             添加时间      预计到期时间(不保证百分百准确)" $openwrt_script_config/check_cookie.txt
	Current_date=$(date +%Y-%m-%d)
	Current_date_m=$(echo $Current_date | awk -F "-" '{print $2}')
	if [ "$Current_date_m" == "12"  ];then
		Expiration_date="01"
	else
		m=$(expr $Current_date_m + 1)
		Expiration_date=$(date +%Y-$m-%d)
		#$这个不要改动，没有写错
	fi
	sed -i "/$pt_pin/d" $openwrt_script_config/check_cookie.txt
	remark=$(grep "$pt_pin" $openwrt_script_config/jdCookie.js | awk -F "," '{print $2$3}'|sed "s/\/\///g")
	echo "$remark      $pt_pin   $Current_date      $Expiration_date" >> $openwrt_script_config/check_cookie.txt
}

check_cookie_push() {
	echo "----------------------------------------------"
	cat $openwrt_script_config/check_cookie.txt
	echo "----------------------------------------------"
	echo "$line#### cookie数量:`cat $openwrt_script_config/jdCookie.js | sed -e "s/pt_key=XXX;pt_pin=XXX//g" -e "s/pt_pin=(//g" -e "s/pt_key=xxx;pt_pin=xxx//g"| grep "pt_pin" | wc -l`$line" >/tmp/jd_check_cookie.txt
	cat $openwrt_script_config/check_cookie.txt |sed "s/备注/$wrap$wrap_tab\# 备注/"  >>/tmp/jd_check_cookie.txt
	$node $dir_file_js/jd_check_cookie1.js | grep "京东账号" >/tmp/jd_check_cookie_sort.txt

	effective_cookie=$(cat /tmp/jd_check_cookie_sort.txt | grep "有效" )
	Invalid_cookie=$(cat /tmp/jd_check_cookie_sort.txt | grep "失效" )
	echo "$line#### cookie有效数量:`cat /tmp/jd_check_cookie_sort.txt | grep "有效"| wc -l`$line" >>/tmp/jd_check_cookie.txt

	echo "$effective_cookie"　>>/tmp/jd_check_cookie.txt

	if [ `echo $Invalid_cookie | wc -l` -ge "1" ];then
		echo "$line#### cookie失效数量:`cat /tmp/jd_check_cookie_sort.txt | grep "失效"| wc -l`$line" >>/tmp/jd_check_cookie.txt
		echo "$Invalid_cookie"　>>/tmp/jd_check_cookie.txt
	else
		echo "没有失效cookie"
	fi

	cookie_content=$(cat /tmp/jd_check_cookie.txt |sed "s/ /+/g"| sed "s/$/$wrap$wrap_tab/g" |  sed ':t;N;s/\n//;b t' )

	server_content=$(echo "${cookie_content}${by}" | sed "s/$wrap_tab####/####/g" )

	weixin_content_sort=$(cat /tmp/jd_check_cookie.txt |sed "s/####/<b>/g"   |sed "s/$line/<hr\/><\/b>/g" |sed "s/$wrap$wrap_tab/<br>/g" |sed "s/<br>#//g"  | sed "s/$/<br>/" |sed "s/<hr\/><\/b><br>/<hr\/><\/b>/g" |  sed ':t;N;s/\n//;b t' )
	weixin_content=$(echo "$weixin_content_sort<br><b>$by")
	weixin_desp=$(echo "$weixin_content" | sed "s/<hr\/><\/b><b>/$weixin_line\n/g" |sed "s/<hr\/><\/b>/\n$weixin_line\n/g"| sed "s/<b>/\n/g"| sed "s/<br>/\n/g" | sed "s/<br><br>/\n/g" | sed "s/#/\n/g" )

	title="JD Cookie状态"
	push_menu
}


push_menu() {
case "$push_if" in
		0)
			#server酱和微信同时推送
			server_push
			weixin_push
			push_if="3"
			weixin_push
		;;
		1)
			#server酱推送
			server_push
		;;
		2)
			#微信推送
			weixin_push
		;;
		3)
			#将shell模块检测推送到另外一个小程序上（举个例子，一个企业号，两个小程序，小程序１填到sendNotify.js,这样子js就会推送到哪里，小程序２填写到jd_openwrt_config这样jd.sh写的模块就会推送到小程序2
			weixin_push
		;;
		*)
			echo -e "$green jd_openwrt_script_config.txt$white的$yellow push_if参数$white$red填写错误，不进行推送$white"
		;;
	esac

}

server_push() {

if [ ! $SCKEY ];then
	echo "没找到Server酱key不做操作"
else
	echo -e "$green server酱开始推送$title$white"
	curl -s "http://sc.ftqq.com/$SCKEY.send?text=$title++`date +%Y-%m-%d`++`date +%H:%M`" -d "&desp=$server_content" >/dev/null 2>&1

	if [[ $? -eq 0 ]]; then
		echo -e "$green server酱推送完成$white"
	else
		echo -e "$red server酱推送失败。请检查报错代码$title$white"
	fi
fi

}

weixin_push() {
current_time=$(date +%s)
expireTime="7200"
if [ $push_if == "3" ];then
	weixinkey=$(grep "weixin2" $openwrt_script_config/jd_openwrt_script_config.txt | awk -F "'" '{print $2}')
else
	weixinkey=$(grep "let QYWX_AM" $openwrt_script_config/sendNotify.js | awk -F "'" '{print $2}')
fi

#企业名
corpid=$(echo $weixinkey | awk -F "," '{print $1}')
#自建应用，单独的secret
corpsecret=$(echo $weixinkey | awk -F "," '{print $2}')
# 接收者用户名,@all 全体成员
touser=$(echo $weixinkey | awk -F "," '{print $3}')
#应用ID
agentid=$(echo $weixinkey | awk -F "," '{print $4}')
#图片id
media_id=$(echo $weixinkey | awk -F "," '{print $5}')

weixin_file="$openwrt_script_config/weixin_token.txt"
time_before=$(cat $weixin_file |grep "$corpsecret" | awk '{print $4}')


if [ ! $time_before ];then
	#获取access_token
	access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}" | sed "s/,/\n/g" | grep "access_token" | awk -F ":" '{print $2}' | sed "s/\"//g")
	sed -i "/$corpsecret/d" $weixin_file
	echo "$corpid $corpsecret $access_token `date +%s`" >> $weixin_file
	echo ">>>刷新access_token成功<<<"
else
	if [ $(($current_time - $time_before)) -gt "$expireTime" ];then
		#获取access_token
		access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}" | sed "s/,/\n/g" | grep "access_token" | awk -F ":" '{print $2}' | sed "s/\"//g")
		sed -i "/$corpsecret/d" $weixin_file
		echo "$corpid $corpsecret $access_token `date +%s`" >>$weixin_file
		echo ">>>刷新access_token成功<<<"
	else
		echo "access_token 还没有过期，继续用旧的"
		access_token=$(cat $weixin_file |grep "$corpsecret" | awk '{print  $3}')
	fi
fi

if [ ! $media_id ];then
	msg_body="{\"touser\":\"$touser\",\"agentid\":$agentid,\"msgtype\":\"text\",\"text\":{\"content\":\"$title\n$weixin_desp\"}}"
	curl -s "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$access_token" -d "$msg_body"
else
	msg_body="{\"touser\":\"$touser\",\"agentid\":$agentid,\"msgtype\":\"mpnews\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$media_id\",\"content\":\"$weixin_content\",\"digest\":\"$weixin_desp\"}]}}"
fi
	echo -e "$green 企业微信开始推送$title$white"
	curl -s "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$access_token" -d "$msg_body"

	if [[ $? -eq 0 ]]; then
		echo -e "$green 企业微信推送成功$title$white"
	else
		echo -e "$red 企业微信推送失败。请检查报错代码$title$white"
	fi

}

checklog() {
	log1="checklog_jd.log" #用来查看tmp有多少jd log文件
	log2="checklog_jd_error.log" #筛选jd log 里面有几个是带错误的
	log3="checklog_jd_error_detailed.log" #将错误的都输出在这里

	cd /tmp
	rm -rf $log3

	#用来查看tmp有多少jd log文件
	ls ./ | grep -E "^j" | grep -v "jd_price.log" | sort >$log1

	#筛选jd log 里面有几个是带错误的
	echo -e "$line#### Model：$sys_model\n#### Wan+IP地址：+$wan_ip\n#### 系统版本:++$uname_version\n$line" >>$log3
	echo "#### $current_time+检测到错误日志的文件" >>$log3
	for i in `cat $log1`
	do
		grep -Elrn  "错误|失败" $i  >> $log2
		grep -Elrn  "错误|失败" $i  >> $log3
	done

	cat_log=$(cat $log2 | wc -l)
	if [ $cat_log -ge "1" ];then
		num="JD_Script发现有$cat_log个日志包含错误信息"
	else
		num="no_error"
	fi

	#将详细错误信息输出log3
	for i in `cat $log2`
	do
		echo "#### ${i}详细的错误" >> $log3
		grep -E  "错误|失败|module" $i | grep -v '京东天天\|京东商城\|京东拍拍\|京东现金\|京东秒杀\|京东日历\|京东金融\|京东金贴\|金融京豆\|检测\|参加团主\|参团失败\|node_modules\|sgmodule\|无助力机会\|不可以为自己助力\|助力次数耗尽\|礼包已抢完\|限流严重\|不能去好友工厂打工啦\|验证失败\|提现失败\|助力失败' | sort -u >> $log3
	done

	if [ $num = "no_error" ]; then
		echo "**********************************************"
		echo -e "$green log日志没有发现错误，一切风平浪静$white"
		echo "**********************************************"
	else
		log_sort=$(cat ${log3} | sed "s/&//g" | sed "s/$/$wrap$wrap_tab$sort_log/g" |  sed ':t;N;s/\n//;b t' )
		server_content=$(echo "${log_sort}${by}" | sed "s/$wrap_tab####/####/g" )

		weixin_content_sort=$(cat ${log3} |sed "s/}//g" | sed "s/{//g"| sed "s/####/<hr\/><b>/g"   |sed "s/$line/<hr\/><\/b>/g" |sed "s/$wrap$wrap_tab/<br>/g" |sed "s/<br>#//g"  | sed "s/$/<br>/" |sed "s/<hr\/><\/b><br>/<hr\/><\/b>/g"| sed "s/详细的错误<br>/详细的错误<b\/><hr\/><br>/g" | sed "s/错误日志的文件/错误日志的文件<b\/><hr\/>/g"| sed "s/<hr\/><b> Wan/<b> Wan/g" | sed "s/<hr\/><b> Model/<b> Model/g" | sed "s/<hr\/><b> 系统版本/<b> 系统版本/g"| sed "s/\"//g"  | sed "s/+/ /g" |  sed ':t;N;s/\n//;b t' | sed "s/<br><hr\/><\/b><hr\/><b>/<br><\/b><hr\/><b>/g")
		weixin_content=$(echo "$weixin_content_sort<br><b>$by")
		weixin_desp=$(echo "$weixin_content" | sed "s/<hr\/><\/b><b>/$weixin_line\n/g" |sed "s/<hr\/><\/b>/\n$weixin_line\n/g"| sed "s/<b>/\n/g"| sed "s/<br>/\n/g" | sed "s/<br><br>/\n/g" | sed "s/#/\n/g" | sed "s/<hr\/>//g" | sed "s/<b\/><hr\/>//g" | sed "s/<b\/>//g" | sed "s/<\/b>/$weixin_line\n/g" )

		title="$num"
		push_menu
	fi

	rm -rf $log1
	rm -rf $log2
}

#检测当天更新情况并推送
that_day() {
	wget https://raw.githubusercontent.com/ITdesk01/JD_Script/master/README.md -O /tmp/test_README.md
	if [[ $? -eq 0 ]]; then
		cd $dir_file
		git fetch
		if [[ $? -eq 0 ]]; then
			echo ""
		else
			echo "请检查你的网络，github更新失败，建议科学上网"
		fi
	else
		echo "请检查你的网络，github更新失败，建议科学上网"
	fi
	clear
	git_branch=$(git branch -v | grep -o behind )
	if [[ "$git_branch" == "behind" ]]; then
		Script_status="建议更新"
	else
		Script_status="最新"
	fi

	if [ ! -d $dir_file/git_log ];then
		mkdir 	$dir_file/git_log
	fi

	echo > $dir_file/git_log/${current_time}.log


	git_log=$(git log --format=format:"%ai %an %s" --since="$current_time 00:00:00" --before="$current_time 23:59:59" | sed "s/+0800//g" | sed "s/$current_time //g" | sed "s/ /+/g")
	echo $git_log >/tmp/git_log_if.log
	git_log_if=$(grep -Eo "Zhang|ITdesk" /tmp/git_log_if.log | sort -u | wc -l )
	if [ $git_log_if -ge 1  ];then
		echo -e "$line#### Model：$sys_model\n#### Wan+IP地址：+$wan_ip\n#### 系统版本:++$uname_version\n$line\n#### $current_time+`date +%H:%M`点+更新日志\n" >> $dir_file/git_log/${current_time}.log
		echo "  时间       +作者          +操作" >> $dir_file/git_log/${current_time}.log
		echo "$git_log" >> $dir_file/git_log/${current_time}.log
		echo "#### 当前脚本是否最新：$Script_status" >>$dir_file/git_log/${current_time}.log
	else
		echo -e "$line#### Model：$sys_model\n#### Wan+IP地址：+$wan_ip\n#### 系统版本:++$uname_version\n$line\n#### $current_time+更新日志\n" >> $dir_file/git_log/${current_time}.log
		echo "作者泡妹子或者干饭去了$wrap$wrap_tab今天没有任何更新$wrap$wrap_tab不要催佛系玩。。。" >>$dir_file/git_log/${current_time}.log
		echo "\n" >>$dir_file/git_log/${current_time}.log
		echo "#### 当前脚本是否最新：$Script_status" >>$dir_file/git_log/${current_time}.log
	fi

	log_sort=$(cat  $dir_file/git_log/${current_time}.log |sed "s/$/$wrap$wrap_tab/" | sed ':t;N;s/\n//;b t' | sed "s/$wrap_tab####/####/g")
	server_content=$(echo "${log_sort}${by}" | sed "s/$wrap_tab####/####/g" )

	weixin_content_sort=$(echo  $log_sort |sed "s/####/<b>/g"   |sed "s/$line/<hr\/><\/b>/g" |sed "s/$wrap/<br>/g" |sed "s/<br>#//g"  | sed "s/$/<br>/" |sed "s/<hr\/><\/b><br>/<hr\/><\/b>/g" |sed "s/+/ /g"| sed "s/<br> <br>/<br>/g"|  sed ':t;N;s/\n//;b t' )
	weixin_content=$(echo "$weixin_content_sort<br><b>$by")
	weixin_desp=$(echo "$weixin_content" | sed "s/<hr\/><\/b><b>/$weixin_line\n/g" |sed "s/<hr\/><\/b>/\n$weixin_line\n/g"| sed "s/<b>/\n/g"| sed "s/<br>/\n/g" | sed "s/<br><br>/\n/g" | sed "s/#/\n/g" )

	title="JD_Script仓库状态"
	push_menu
}

backnas() {
	date_time=$(date +%Y-%m-%d-%H:%M | sed "s/:/_/")
	back_file_name="script_${date_time}.tar.gz"
	#判断所在文件夹
	if [ "$dir_file" == "$openwrt_script/JD_Script" ];then
		backnas_config_file="$openwrt_script_config/backnas_config.txt"
		back_file_patch="$openwrt_script"
		if [ ! -f "$openwrt_script_config/backnas_config.txt" ]; then
			backnas_config
		fi
	else
		backnas_config_file="$dir_file/config/backnas_config.txt"
		back_file_patch="$dir_file"
		if [ ! -f "$dir_file/config/backnas_config.txt" ]; then
			backnas_config
		fi
	fi

	#判断config文件
	backnas_config_version="1.0"
	if [ `grep -o "backnas_config版本$backnas_config_version" $backnas_config_file |wc -l` == "0" ]; then
		echo "backnas_config有变，开始更新"
		backnas_config
		echo "backnas计划任务设置完成"
	fi
	clear

	#判断依赖
	sshpass_if=$(opkg list-installed | grep 'sshpass' |awk '{print $1}')
	if [ ! $sshpass_if ];then
		echo "未检测到sshpass依赖，开始安装"
		opkg update
		opkg install sshpass
	fi

	#开始传递参数
	nas_user=$(grep "user" $backnas_config_file | awk -F "'" '{print $2}')
	nas_secret_key=$(grep "secret_key" $backnas_config_file | awk -F "'" '{print $2}')
	nas_pass=$(grep "password" $backnas_config_file | awk -F "'" '{print $2}')
	nas_ip=$(grep "nas_ip" $backnas_config_file | awk -F "'" '{print $2}')
	nas_file=$(grep "nas_file" $backnas_config_file | awk -F "'" '{print $2}')
	nas_prot=$(grep "port" $backnas_config_file | awk -F "'" '{print $2}')

	echo "#########################################"
	echo "       backnas $backnas_version版本"
	echo "#########################################"
	#判断用户名
	if [ ! $nas_user ];then
		echo -e "$yellow 用户名:$red    空 $white"
		echo "空" >/tmp/backnas_if.log
	else
		echo -e "$yellow 用户名：$green $nas_user $white"
		echo "正常" >/tmp/backnas_if.log
	fi

	#判断密码
	if [ ! $nas_pass ];then
		echo -e "$yellow 密码：$red     空 $white"
		echo "空" >>/tmp/backnas_if.log
	else
		echo -e "$yellow 密码：$green这是机密不显示给你看 $white"
		echo "正常" >>/tmp/backnas_if.log
	fi

	#判断密钥
	if [ ! $nas_secret_key ];then
		echo -e "$yellow NAS 密钥：$green 空(可以为空)$white"
	else
		echo -e "$yellow NAS 密钥：$green $nas_secret_key $white"
		echo "正常" >>/tmp/backnas_if.log
	fi

	#判断IP
	if [ ! $nas_ip ];then
		echo -e "$yellow NAS IP:$red    空 $white"
		echo "空" >>/tmp/backnas_if.log
	else
		echo -e "$yellow NAS IP：$green$nas_ip $white"
		echo "正常" >>/tmp/backnas_if.log
	fi

	#判断NAS文件夹
	if [ ! $nas_file ];then
		echo -e "$yellow NAS文件夹:$red 空 $white"
		echo "空" >>/tmp/backnas_if.log
	else
		echo -e "$yellow NAS备份目录：$green $nas_file $white"
		echo "正常" >>/tmp/backnas_if.log
	fi

	#判断端口
	if [ ! $nas_prot ];then
		echo -e "$yellow NAS 端口:$red   空 $white"
	else
		echo -e "$yellow NAS 端口：$green $nas_prot $white"
	fi

	echo -e "$yellow 使用协议：$green SCP$white"
	echo ""
	echo -e "$yellow 参数填写$green$backnas_config_file$white"
	echo "#########################################"

	back_if=$(cat /tmp/backnas_if.log | sort -u )
	if [ $back_if == "空" ];then
		echo ""
		echo -e "$red重要参数为空 不执行备份操作，需要备份的，把参数填好,$white填好以后运行$green sh \$jd backnas $white测试一下是否正常$white"
		exit 0
	fi

	echo -e "$green >>先杀掉一下后台脚本，然后方便打包文件$white"
	kill_ccr
	sleep 5
	echo -e "$green>> 开始备份到nas$white"
	sleep 5

	echo -e "$green>> 打包前处理，删除ccr_js文件"
	rm -rf $back_file_patch/JD_Script/ccr_js/*
	echo -e "$green>> 删除完成$white"
	sleep 5

	echo -e "$green>> 开始打包文件$white"
	tar -zcvf /tmp/$back_file_name $back_file_patch
	sleep 5

	echo -e "$green>> 开始恢复ccr_js文件夹$white"
	update
	echo "$green>>  恢复完成$white"

	clear
	echo -e "$green>> 开始上传文件 $white"
	echo -e "$yellow注意事项: 首次连接NAS的ssh会遇见$green Do you want to continue connecting?$white然后你输入y卡住不动"
	echo -e "$yellow解决办法:ctrl+c ，然后$green ssh -p $nas_prot $nas_user@$nas_ip $white连接成功以后输$green logout$white退出NAS，重新执行$green sh \$jd backnas$white"
	echo ""
	echo -e "$green>> 上传文件中，请稍等。。。。 $white"

	if [ ! $nas_secret_key ];then
		if [ ! $nas_pass ];then
			echo -e "$red 密码：为空 $white参数填写$green$backnas_config_file$white"
			read a
			backnas
		else
			sshpass -p "$nas_pass" scp -P $nas_prot -r /tmp/$back_file_name $nas_user@$nas_ip:$nas_file
		fi
	else
		scp -P $nas_prot -i $nas_secret_key -r /tmp/$back_file_name $nas_user@$nas_ip:$nas_file
	fi

	if [ $? -eq 0 ]; then
		sleep 5
		echo -e "$green>> 上传文件完成 $white"
		echo ""
		echo "#############################################################################"
		echo ""
		echo -e "$green $date_time将$back_file_name上传到$nas_ip 的$nas_file目录$white"
		echo ""
		echo "#############################################################################"
	else
		echo -e "$red>> 上传文件失败，请检查你的参数是否正确$white"
	fi
	echo ""
	echo -e "$green>> 清理tmp文件 $white"
	rm -rf /tmp/*.tar.gz
	sleep 5
}

backnas_config() {
cat >$backnas_config_file <<EOF
################################################################
                 backnas_config版本$backnas_config_version
用于备份JD_script 到NAS 采用scp传输，请确保你的nas，ssh端口有打开
################################################################
#填入你的nas账号(必填)
user=''

#填入你nas的密码(密码和密钥必须填一个)
password=''

#填入你nas的密钥位置(可以留空)(密钥 > 密码,有密钥的情况优先使用密钥而不是密码)
secret_key=''

#填入nas IP地址可以是域名(必填)
nas_ip=''

#填入nas保存路径(必填)
nas_file=''

#端口(默认即可，ssh端口有变填这里)
port='22'
EOF
}

script_black() {
	#不是很完美，但也能用，后面再想想办法，grep无法处理$node 这种这样我无法判断是否禁用了，只能删除掉一了百了
	black_version="黑名单版本1.2"
	#判断所在文件夹
	if [ "$dir_file" == "$openwrt_script/JD_Script" ];then
		script_black_file="$openwrt_script_config/Script_blacklist.txt"
		if [ ! -f "$script_black_file" ]; then
			script_black_Description
		fi
		#script_black用于升级以后恢复链接
		if [ ! -f "$dir_file/config/Script_blacklist.txt" ]; then
			ln -s $script_black_file $dir_file/config/Script_blacklist.txt
		fi
	else
		script_black_file="$dir_file/config/Script_blacklist.txt"
		if [ ! -f "$script_black_file" ]; then
			script_black_Description
		fi
	fi

	if_script_black=$(grep "$black_version" $script_black_file | wc -l)
	if [  $if_script_black == "0" ];then
		echo "更新一下黑名单"
		rm -rf $dir_file/config/Script_blacklist.txt
		sed -i '/*/d' $script_black_file >/dev/null 2>&1
		sed -i '/jd_ceshi/d' $script_black_file >/dev/null 2>&1
		sed -i "s/ //g"  $script_black_file >/dev/null 2>&1
		echo "" >> $script_black_file >/dev/null 2>&1
		ln -s $script_black_file $dir_file/config/Script_blacklist.txt
		script_black_Description
	fi

	script_list=$(cat $script_black_file | sed  "/*/d"  | sed "/jd_ceshi/d" | sed "s/ //g" | awk '{print $1}')
	if [ ! $script_list ];then
		echo -e "$green 黑名单没有任何需要禁用的脚本，不做任何处理$white"
	else
		for i in `echo "$script_list"`
		do
			if [ `grep "dir_file_js\/$i" $dir_file/jd.sh  | wc -l` -gt 0 ];then
				echo "开始删除关于$i脚本的代码，后面需要的话看黑名单描述处理"
				sed -i "/$i/d" $dir_file/jd.sh
			else
				echo "黑名单脚本已经全部禁用了"
			fi
		done
	fi
	clear
}

cd $dir_file && git remote -v | awk -F "/JD_Script"  '{print $1}' | awk -F "github.com/" '{print $2}' | sort -u >/tmp/github.txt

script_black_Description() {
cat >> $script_black_file <<EOF
******************************不要删使用说明，$black_version*********************************************************************
*
*这是脚本黑名单功能，作用就是你跑脚本黑活动了，你只需要把脚本名字放底下，跑脚本的时候（全部账号）就不会跑这个脚本了
*但你可以通过node  脚本名字来单独跑（只是不会自动跑了而已）
*PS：（彻底解开的办法就是删除这里的脚本名称，然后更新脚本）
*例子
*
* 	jd_ceshi1.js #禁用的脚本1
* 	jd_ceshi2.js #禁用的脚本2
*
*按这样排列下去（一行一个脚本名字）
*每个脚本应的文件可以用 sh \$jd script_name                    #显示所有JS脚本名称与作用
*
*
***********************要禁用的脚本不要写这里面，不要删除这里的任何字符，也不要动里面的，往下面写随便你********************************
EOF
}

stop_script() {
	echo -e "$green 删掉定时任务，这样就不会定时运行脚本了$white"
	task_delete
	sleep 3
	killall -9 node 
	echo -e "$green处理完成，需要重新启用，重新跑脚本sh \$jd 就会添加定时任务了$white"
}


help() {
	#检查脚本是否最新
	echo "稍等一下，正在取回远端脚本源码，用于比较现在脚本源码，速度看你网络"
	cd $dir_file
	git fetch
	if [[ $? -eq 0 ]]; then
		echo ""
	else
		echo -e "$red>> 取回分支没有成功，重新执行代码$white"
		system_variable
	fi
	clear
	git_branch=$(git branch -v | grep -o behind )
	if [[ "$git_branch" == "behind" ]]; then
		Script_status="$red建议更新$white (可以运行$green sh \$jd update_script && sh \$jd update && source /etc/profile && sh \$jd $white更新 )"
	else
		Script_status="$green最新$white"
	fi
	task
	clear
	echo ----------------------------------------------------
	echo "	     JD.sh $version 使用说明"
	echo ----------------------------------------------------
	echo -e "$yellow 1.文件说明$white"
	echo ""
	echo -e "$green  $openwrt_script_config/jdCookie.js $white 在此脚本内填写JD Cookie 脚本内有说明"
	echo -e "$green  $openwrt_script_config/sendNotify.js $white 在此脚本内填写推送服务的KEY，可以不填"
	echo -e "$green  $openwrt_script_config/USER_AGENTS.js $white 京东UA文件可以自定义也可以默认"
	echo -e "$green  $openwrt_script_config/JS_USER_AGENTS.js $white 京东极速版UA文件可以自定义也可以默认"
	echo -e "$green  $openwrt_script_config/Script_blacklist.txt $white 脚本黑名单，用法去看这个文件"
	echo ""
	echo -e "$yellow JS脚本活动列表：$green $dir_file/git_clone/lxk0301_back/README.md $white"
	echo -e "$yellow 浏览器获取京东cookie教程：$green $dir_file/git_clone/lxk0301_back/backUp/GetJdCookie.md $white"
	echo -e "$yellow 脚本获取京东cookie：$green sh \$jd getcookie $white"
	echo ""
	echo -e "$red 注意：$white请停掉你之前运行的其他jd脚本，然后把$green JS脚本活动列表$white的活动全部手动点开一次，不知活动入口的，$dir_file_js/你要的js脚本里有写"
	echo ""
	echo -e "$yellow 2.jd.sh脚本命令$white"
	echo ""
	echo -e "$green  sh \$jd run_0  run_07			#运行全部脚本(除个别脚本不运行)$white"
	echo ""
	echo -e "$yellow个别脚本有以下："
	echo ""
	echo -e "$green  sh \$jd npm_install $white  			#安装 npm 模块"
	echo ""
	echo -e "$green  sh \$jd opencard $white  			#开卡(默认不执行，你可以执行这句跑)"
	echo ""
	echo -e "$green  sh \$jd jx $white 				#查询京喜商品生产使用时间"
	echo ""
	echo -e "$green  sh \$jd jd_sharecode $white 			#查询京东所有助力码"
	echo ""
	echo -e "$green  sh \$jd checklog $white  			#检测log日志是否有错误并推送"
	echo ""
	echo -e "$green  sh \$jd that_day $white  			#检测JD_script仓库今天更新了什么"
	echo ""
	echo -e "$green  sh \$jd check_cookie_push $white  		#推送cookie大概到期时间和是否有效"
	echo ""
	echo -e "$green  sh \$jd script_name $white  			#显示所有JS脚本名称与作用"
	echo ""
	echo -e "$green  sh \$jd backnas $white  			#备份脚本到NAS存档"
	echo ""
	echo -e "$green  sh \$jd stop_script $white  			#删除定时任务停用所用脚本"
	echo ""
	echo -e "$green  sh \$jd kill_ccr $white  			#终止并发"
	echo ""
	echo -e "$green  sh \$jd checktool $white  			#检测后台进程，方便排除问题"
	echo ""
	echo -e " 如果不喜欢这样，你也可以直接$green cd \$jd_file/js$white,然后用$green node 脚本名字.js$white "
	echo ""
	echo -e "$yellow 3.检测定时任务:$white $cron_help"
	echo -e "$yellow   定时任务路径:$white$green/etc/crontabs/root$white"
	echo ""
	echo -e "$yellow 4.如何排错或者你想要的互助码:$white"
	echo ""
	echo "  答1：如何排错有种东西叫更新，如sh \$jd update_script 和sh \$jd update"
	echo "  答2：如何排错有种东西叫查日志，如/tmp/里面的jd开头.log结果的日志文件"
	echo "  答3：你想要的互助码 sh \$jd jd_sharecode"
	echo ""
	echo "  看不懂代码又想白嫖，你还是洗洗睡吧，梦里啥都有，当然你可以用钞能力解决多数问题（你可以忽略这句，继续做梦）"
	echo ""
	echo -e "$yellow 5.检测脚本是否最新:$white $Script_status "
	echo ""
	echo -e "$yellow 6.个性化配置：$white $jd_config_version"
	echo ""
	echo -e "$yellow 7.JD_Script报错你可以反馈到这里:$white$green https://github.com/ITdesk01/JD_Script/issues$white"
	echo ""
	echo -e "$index_num"
	echo ""
	echo ""
	echo -e "本脚本基于$green x86主机测试$white，一切正常，其他的机器自行测试，满足依赖一般问题不大"
	echo ----------------------------------------------------
	echo " 		by：ITdesk"
	echo ----------------------------------------------------

	time &
}


additional_settings() {

	for i in `cat $dir_file/config/collect_script.txt | grep -v "#.*js" | awk '{print $1}'`
	do
		sed -i "s/$.isNode() ? 20 : 5/0/g" $dir_file_js/$i
	done

	for i in `cat $dir_file/config/collect_script.txt | grep -v "#.*js" | awk '{print $1}'`
	do
		sed -i "s/$.isNode() ? 10 : 5/0/g" $dir_file_js/$i
	done

	for i in `cat $dir_file/config/collect_script.txt | grep -v "#.*js" | awk '{print $1}'`
	do
		sed -i "s/helpAu = true/helpAu = false/g" $dir_file_js/$i
	done

	for i in `cat $dir_file/config/collect_script.txt | grep -v "#.*js" | awk '{print $1}'`
	do
		sed -i "s/helpAuthor=true/helpAuthor=false/g" $dir_file_js/$i
	done

	#东东超市兑换豆子
	sed -i "s/coinToBeans = ''/coinToBeans = '超值京豆包'/g" $dir_file_js/jd_blueCoin.py
	sed -i "s/blueCoin_Cc = False/blueCoin_Cc = True/g" $dir_file_js/jd_blueCoin.py

	#宠汪汪兑换
	sed -i "s/..\/USER_AGENTS.js/.\/USER_AGENTS.js/g" $dir_file_js/JDJRValidator_Pure.js
	sed -i "s/.\/utils\/JDJRValidator_Pure/.\/JDJRValidator_Pure/g" $dir_file_js/jd_joy_reward.js
	sed -i "s/joyRewardName = 0/joyRewardName = $jd_joy_reward/g" $dir_file_js/jd_joy_reward.js



	#取消店铺从20个改成50个(没有星推官先默认20吧)
	sed -i "s/|| 20/|| $jd_unsubscribe/g" $dir_file_js/jd_unsubscribe.js

	if [ `cat $openwrt_script_config/sendNotify.js | grep "采用lxk0301开源JS脚本" | wc -l` == "0" ];then
	sed -i "s/本脚本开源免费使用 By：https:\/\/gitee.com\/lxk0301\/jd_docker/#### 脚本仓库地址:https:\/\/github.com\/ITdesk01\/JD_Script\/tree\/main 核心JS采用lxk0301开源JS脚本/g" $openwrt_script_config/sendNotify.js
	sed -i "s/本脚本开源免费使用 By：https:\/\/github.com\/LXK0301\/jd_scripts/#### 脚本仓库地址:https:\/\/github.com\/ITdesk01\/JD_Script\/tree\/main 核心JS采用lxk0301开源JS脚本/g" $openwrt_script_config/sendNotify.js
	fi
	
	sed -i '/FRUITSHARECODES/d' /etc/profile >/dev/null 2>&1
	sed -i '/PETSHARECODES/d' /etc/profile >/dev/null 2>&1
	sed -i '/PETSHARECODES/d' /etc/profile >/dev/null 2>&1
	sed -i '/DREAM_FACTORY_SHARE_CODES/d' /etc/profile >/dev/null 2>&1
	

	#东东农场
	new_fruit1="6632c8135d5c4e2c9ad7f4aa964d4d11@f0319fde539a485abcf782197b1b919c@31a2097b10db48429013103077f2f037@5aa64e466c0e43a98cbfbbafcc3ecd02@bf0cbdb0083d443499a571796af20896@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@4a75d8a6233344b1965857ae23831ce7@392acd7b14d9476bb48ebf2ac171cffc@690009b0d5674e85b751838b2fa6241e@5f952ad609b1440b94599eaec41d853f@fc95d5c2679e47b493691d8b49f92446@4c4fb3384aed4199a045c6985a931fb2"
	zuoyou_20190516_fr="367e024351fe49acaafec9ee705d3836@3040465d701c4a4d81347bc966725137@82c164278e934d5aaeb1cf19027a88a3@a2504cd52108495496460fc8624ae6d4@4eb7542e28714d6e86739151f8aadc6e@983be1208879492fa692c1b89a30fc15@ba02bdbac56a4b9c967443eae04bc8fa@3e3080883ea346d0a653afaeac74b357@e8bd1e69ccc24d65a4e183dcfb025606@ce0c26cd3375486c8ad41c4e1f61c449"
	Javon_20201224_fr="926a1ec44ddd459ab2edc39005628bf4@d535648ffa3b45d79ff66b997ec8b629"
	Javon_random_fr="b2921984328744d7bc4302738235a4a8@8ac8cb7c9ded4a17b8057e27ed458104@e65a8b0cd1cc433a87bfd5925778fadc@669e5763877c4f97ab4ea64cd90c57fa@86ab77a88a574651827141e1e8c0b4c6@8ac8cb7c9ded4a17b8057e27ed458104@33b778b454a64b1e91add835e635256c@c9bb7ca2a80d4c8ab2cae6216d7a9fe6@dcfb05a919ff472680daca4584c832b8@0ce9d3a5f9cd40ccb9741e8f8cf5d801@54ac6b2343314f61bc4a6a24d7a2eba1@bad22aba416d4fffb18ad8534b56ea60@e5a87df07c914457b855cbb2f115d0a4@9a4370f99abb4eda8fa61d08be81c1d7@d535648ffa3b45d79ff66b997ec8b629@8b8b4872ab9d489896391cc5798a56e2"
	chiyu_fr="f227e8bb1ea3419e9253682b60e17ae5"
	ashou_20210516_fr="9046fbd8945f48cb8e36a17fff9b0983@72abb03ca91a4569933c6c8a62a5622c@5e567ba1b9bd4389ae19fa09ca276f33@82b1494663f9484baa176589298ca4b3@616382e94efa476c90f241c1897742f1@d4e3080b06ed47d884e4ef9852cad568@ed2b2d28151a482eae49dff2e5a588f8@a8b204ae2a7541a18e54f5bfb7dcb04b"
	xiaodengzi_20190516_fr="e24edc5de45341dd98f352533e23f83a@8284c080686b45c89a6c6f7d1ea7baac@8dda5802f0d54f38af48c4059c591007"
	xiaodengzi_random_20190516_fr="e004a4244e244863b14d7210f8513113@f69821dde34540d39f95315c5290eb88@5e753c671d0644c7bb418523d3452975@c6f859ec57d74dda9dafc6b3c2af0a0f	"
	jidiyangguang_20190516_fr="3e6f0b7a2d054331a0b5b956f36645a9@304b39f17d6c4dac87933882d4dec6bc"

	#比白人
	wjq_20190516_fr="9aac4df8839742b6abae13606ad696cc@10828079c5ca49a1b2b56a9a3fe39671@2ce1c53010dc4f7ebb5e4803701220d3@a0927fb98a854126a045dbe1f320898c@2a21ddfb16ee4effb2c642044aaccbc3@9892ac896b694629a6c3dc9c67619313@d9f70f10475b47ccb93f6fffcb63d314@246026e20a224e2a8065f8fa06360cf2@58a1ef4cc89c49ec9e1e735be5247545@4443ce027b3641b9808ca63b73298d35@c935c581e91545e083153340a37c46cf@6d23338f57044edf882afcbeae8e36a4@87f88cb405f24686a708a08755b43089@73a9d5d24ce94ae6a8a4cd808a7c10ba"

	#南山忆只狸
	NanshanFox_20210303_fr="466c4a6b914f4639ac3b2f8b62473365@e3f644b3337d4bbabe45630dd6ad8702@7b688aadeb0448b8b1a2b2e85555ecb7@90d6fcb0843f45deb49575a7d7cb667c@5403258f288242efbe4e81d5f2ebb23b@80f21f968821456f886e10677d4b6874@8186b1fa4a78472095040db665bfb7a5@36f43e0dcb5e4b50b81388e9d1f4f6b5@fe199a2aeb894cee844aff3c7fbf8a84@fc335b5bc7854ee0a13679a9e6410b5b@ccf8e0ec661940c8a1e882b3bbf236fb@4e8439f1e9a14338ba90688b45d4958e@39e9e204c5cc473c967bd06031b94df9@43258bb57e464c268edc40148017fe73@bfec14f3156c41baa92b2c36ed9fb459@ac75cc510aaa475fbf1d08ef8973b462@7c98182e8d2a456381cc1f935dccaf61@c98bc75f96b7422b84388a90767fde2b@776e6ab6b0d04262b47ef1bd0db7dc55@7e96ed05c5f14c8bbf2a5b8bd083b79d@227baadbae854ce480e6e85f9ce4330c@6f9e47f94e844521bcd824f38ab64c66@248006afe4f04c9cb2b7b9d56e9c9288@23d728e8b9a449f18559b8ff29eebc0f@7bc93226f43e46b0aa9fb101b28ca55c@9b8d09eac9c14b19a06f61403b76fa80@8c44f316463a493fb207d928a3f4bf4d@7bc5b4abd4284849bf5adb44378cb637@da52dc3af6384ffdadecd68c6519645a@58477f92546843e48570cf11ef3c6784"

	#Lili
	Lili_20210121_fr="48651377d7544f6bbf32cbd7ef50be30"
	
	#己巳
	jisi_20201211_fr="df3ae0b59ca74e7a8567cdfb8c383f02@917de51d75414ddda4a1bbb863b8bf8a@e3ec63e3ba65424881469526d8964657@9b9e10d0aab44cfcb579ac6e76bb29c5"
	
	#Luckies
	Luckies_20210205_fr="9c091f728d54497ba7bb814c0d9c241e@90c3664de385425fb44c7db2e40b6061"
	
	#余生一个浪
	yushengyigelang_2021017_fr="0d03ac05fdec4d729f81fb3d7bb54088@ddc79232c6e74725950ee42fde939483@61f21ef708c948568854ec50c3627085@2a9165ab1c4f44edbbeb40ab7c8742e8@72dd4d3e2245472986f729953c5be146@13be2ecb23344d86ada656a3d8a6cf92@8625e8d64171463d9269c238af18c5bf@9555bb8dbc074812b6584ded84707fad@79a631eaa1ab4278af48b828624ea226"
	
	#游戏真好玩
	youxizhenhaowan_20201229_fr="99a9841c61f94408beecd446ff9075f1@287ccad61f0249dab7426db9f019e5e1@b2ed38d653c945e18a5c38b73fae0a4e@b80e6b7cc7e146a885c8b604d9e2a4fa@355b53b076e84a3b9c2a98577b342d94"

	#谈何容易
	tanherongyi_20210121_fr="24156b43b0664cff955e2bedea49e2b5@1cf02b657b524b90b882e45414893abe@5ec06e692aa8412db93acb3b4ec47a58@9875e6c9ea2e4cd2a89adeea15383315"

	#无聊
	wuliao_20210214_fr="6b8689615bdc4831a9f9b96d8842e06e@85da7dbfa1b749efb3f7b1ffa7e6d018"

	#whiteboy
	whiteboy__20190711_fr="dfb6b5dcc9d24281acbfce5d649924c0@319239c7aed84c1a97092ddbf2564717@45e193df45704b8bb25e04ea86c650bf@49fefaa873c84b398882218588b0647a"

	#阿东
	adong_20201108_fr="3d1985319106483ba83de3366d3716d5@9e9d99a4234d45cd966236d3cb3908cf"

	#一路向北
	superbei666_20201124_fr="599451cd6e5843a4b8045ba8963171c5@8cce0e4cb54b433c9eebd251753088fd"
	
	#dream
	dreamer_20200524_fr="c79929afc3554d6fa91291914be2e59c@ab1b407c39174ddeaddb6395a141746a@acd4a50eb3a942c4995420f0354d5ad2@b57495d0746b49ea94c9a08f689829c3@3cc3388a207f4fd28e7cc9f3746e167a"

	#傻子
	cainiao5_20201209_fr="2a9ccd7f32c245d7a4d6c0fe1cafdd4c"

	#小草
	xiacao_20210102_fr="3aaa13bec82041d59e566d35cebb3bc9@cdbbe169f8d04263a635d694f528f6ed@d3c0f10518744f57bc698639b4dc6f8f@9414a20f17bd4dd181602663ffdae9e4@f3752560b0224d9a8bacc1c89647426f"

	#法外狂徒张三
	fwkgzs_20210522_fr="0133373a5e7a4468883abfe2332c9ca9@6432a076b39a4fcb8c52d9ed2c223e4d@e33cccab69914acd94f50af48216e047@3f67b8f4a53641ad992c2f0584cdf46d"

	#屌大话事
	ddhs_20210603_fr="f3b80f8d7c8d46e0a635567a2c39289b@05b680249f7a4f0da2dfd1792d22cbb2@73402e0b2c7940909c84d7fc1012e4ae"

	#男人的肩膀
	nrdjb__20210410_fr="6d35cebe56bf497aa2bb9f594d83ca4f@7ece4d2e655845ceaaf8e62736e82139@0feb8d1d1cfb4a2484e600fb770cd740@fe950194a5a046f69d0abb88af5db23f@42ee60bf30a841cd90a6bd417d1bbc8c@57df60b68aef4aabb2deb603b925a26c@0f5b398f3c8a4fc3915c7334d3e1f19d@2e0b1d2ff0714ffd9d183be1816a881e@b456a1a6093343e38ddd6e714ea680da@af4c0ce042bc438fb7ff097e88f4dd6f@059d422bc7df431996c113cb346153d4@a16ca3b6f39345acbe973bb11470a55c@7dd26a15bce64b91820a41ca4df331e0@4c1951196a28497296187edf707d0172@6fc000a5542c4411936df6430302b1b5@0c2beeba8c964e9aa2e8010076d5c9cf@dc0b7c93ce824bfa8263b5b8b072980a@00d5a8c28c754c57b08d68d94568dd36@f0f841bc50ad4b5f8a7c61998667b8ae@34bd3fca2f1b4bf2bfa8c6972ff0c766"

	#白嫖怪
	bpg_20210101_fr="e99f7b50c1ec4dce9267f70e59638c90"

	#苏酒
	sujiu_20200213_fr="cf13366e69d648ff9022e0fdce8c172a@cedfefd072434e57afcd95bed69a5f5c@be8f0aed655747588792d694cc027ca7@801796d51ec04d80a0899c2e044dca63@638bd160c6534f548c6d79cb557be79a@e3353eec3c7f460aa983b2335c11e936@d467a4aa1e9844978a4d64caf6a1111f"
	
	random_fruit="$dreamer_20200524_fr@$adong_20201108_fr@$whiteboy__20190711_fr@$wuliao_20210214_fr@$tanherongyi_20210121_fr@$wjq_20190516_fr@$NanshanFox_20210303_fr@$Lili_20210121_fr@$jisi_20201211_fr@$Luckies_20210205_fr@$yushengyigelang_2021017_fr@$youxizhenhaowan_20201229_fr@$superbei666_20201124_fr@$cainiao5_20201209_fr@$xiacao_20210102_fr@$fwkgzs_20210522_fr@$ddhs_20210603_fr@$nrdjb__20210410_fr@$bpg_20210101_fr@$sujiu_20200213_fr"
	random="$random_fruit"
	random_array
	new_fruit_set="'$new_fruit1@$zuoyou_20190516_fr@$Javon_20201224_fr@$jidiyangguang_20190516_fr@$ashou_20210516_fr@$xiaodengzi_20190516_fr@$xiaobandeng_fr@$chiyu_fr@$random_set',"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	fr_rows=$(grep -n "shareCodes =" $dir_file_js/jd_fruit.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$fr_rows a \ $new_fruit_set " $dir_file_js/jd_fruit.js
		js_amount=$(($js_amount - 1))
	done

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	frcode_rows=$(grep -n "FruitShareCodes = \[" $dir_file_js/jdFruitShareCodes.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$frcode_rows a \ $new_fruit_set " $dir_file_js/jdFruitShareCodes.js
		js_amount=$(($js_amount - 1))
	done

	sed -i "s/dFruitBeanCard = false/dFruitBeanCard = $jd_fruit/g" $dir_file_js/jd_fruit.js #农场不浇水开始换豆

	#萌宠
	new_pet1="MTE1NDAxNzcwMDAwMDAwMzk1OTQ4Njk=@MTAxNzIxMDc1MTAwMDAwMDA1NTg4ODM0OQ==@MTE1NDQ5OTUwMDAwMDAwMzk3NDgyMDE=@MTAxODEyOTI4MDAwMDAwMDQwMTIzMzcx@MTEzMzI0OTE0NTAwMDAwMDA0MzI3NzE3MQ==@MTEzMzI1MTE4NDAwMDAwMDA1NDk0NzY0OQ==@MTEzMzI1MTE4NTAwMDAwMDA1NDk0NzYxMQ==@MTE1NDQ5OTIwMDAwMDAwNDQzNjYzMTE=@MTE1NDUwMTI0MDAwMDAwMDQ0MzY2NDMx@MTE0MDE2NjI5MDAwMDAwMDQ3MDYzMzk5@MTEzMzI1MTE4NDAwMDAwMDA1MDI4MjgyMw=="
	zuoyou_20190516_pet="MTEzMzI0OTE0NTAwMDAwMDAzODYzNzU1NQ==@MTE1NDAxNzgwMDAwMDAwMzg2Mzc1Nzc=@MTE1NDAxNzgwMDAwMDAwMzg4MzI1Njc=@MTE1NDQ5OTIwMDAwMDAwNDM3MTM3ODc=@MTAxNzIyNTU1NDAwMDAwMDA1MDIyMjIwMQ==@MTAxNzIxMDc1MTAwMDAwMDA1MDIyMjE2OQ==@MTEzMzI1MTE4NDAwMDAwMDA1MDA5Nzg4MQ==@MTAxNzIxMDc1MTAwMDAwMDA1MDA5NzczOQ==@MTEzMzI1MTE4NDAwMDAwMDA1MDExNTc2MQ==@MTEzMzI1MTE4NDAwMDAwMDA1MDEyMzYxNw=="
	Javon_20201224_pet="MTE1NDUyMjEwMDAwMDAwNDE2NzYzNjc="
	Javon_random_pet="MTE0MDQ3MzIwMDAwMDAwNDczODQ2MTM=@MTAxODc2NTEzMDAwMDAwMDAxODU0NzI3Mw==@MTE1NDAxNzgwMDAwMDAwNDI1MjkxMDU=@MTE1NDQ5OTIwMDAwMDAwNDIxMjgyNjM=@MTE1NDAxNzYwMDAwMDAwMzYwNjg0OTE=@MTE1NDQ5OTIwMDAwMDAwNDI4Nzk3NTE=@MTE1NDQ5OTUwMDAwMDAwNDMwMTIxMzc=@MTE1NDQ5MzYwMDAwMDAwNDQ0NTA5MzM=@MTEzMzI0OTE0NTAwMDAwMDA0NDQ1ODY4NQ=="
	chiyu_pet="MTAxODEyOTI4MDAwMDAwMDQwNzYxOTUx"
	ashou_20210516_pet="MTAxODEyOTI4MDAwMDAwMDM5NzM3Mjk5@MTEzMzI0OTE0NTAwMDAwMDAzOTk5ODU1MQ==@MTE1NDQ5OTIwMDAwMDAwNDIxMDIzMzM=@MTAxODEyMjkxMDAwMDAwMDQwMzc4ODU1@MTAxODc2NTEzMDAwMDAwMDAxOTcyMTM3Mw==@MTAxODc2NTEzMzAwMDAwMDAxOTkzMzM1MQ==@MTAxODc2NTEzNDAwMDAwMDAxNjA0NzEwNw=="
	Jhone_Potte_20200824_pet="MTE1NDAxNzcwMDAwMDAwNDE3MDkwNzE=@MTE1NDUyMjEwMDAwMDAwNDE3NDU2MjU="
	xiaodengzi_20190516_pet="MTE1NDUwMTI0MDAwMDAwMDM5NTc4ODQz@MTAxODExNDYxMTEwMDAwMDAwNDAxMzI0NTk="
	jidiyangguang_20190516_pet="MTE1NDQ5OTUwMDAwMDAwMzk2NTY2MTk=@MTE1NDQ5MzYwMDAwMDAwMzk2NTY2MTE="

	#比白人
	wjq_20190516_pet="MTAxODc2NTEzMTAwMDAwMDAyNDM5MjI0Mw==@MTAxODc2NTEzMDAwMDAwMDAyOTc5MTM1MQ==@MTE0MDE2NjI5MDAwMDAwMDQ2OTk2NjA5@MTEzMzI0OTE0NTAwMDAwMDA0Njk5NDUwMw==@MTAxNzIyNTU1NDAwMDAwMDA1MDE0NjM4MQ==@MTE1MzEzNjI2MDAwMDAwMDUxNTE2OTE5@MTE1MzEzNjI2MDAwMDAwMDUwNzY2NjI5@MTAxNzIyNTU1NDAwMDAwMDA1MTIwMDQyNQ==@MTEyNjE4NjQ2MDAwMDAwMDUyMjM2NzQ3@MTEzMzI1MTE4NTAwMDAwMDA1MDE0NjM4NQ==@MTE1NDY3NTIwMDAwMDAwNTI3MTM2Mjc=@MTE1NDUyMjEwMDAwMDAwNDIzNjQxMDc=@MTE1MzEzNjI2MDAwMDAwMDU0MTgzNzY3@MTEzMzI1MTE4NTAwMDAwMDA1NDQ5NzI1OQ=="

	#南山忆只狸
	NanshanFox_20210303_pet="MTE1NDUwMTI0MDAwMDAwMDQ0OTY5Njcx@MTE1NDUyMjEwMDAwMDAwNDQ5Njk4MTE=@MTE1NDAxNzgwMDAwMDAwNDQ5ODUzMDU=@MTEzMzI0OTE0NTAwMDAwMDA0NTA5NjgzMQ==@MTE1NDQ5OTUwMDAwMDAwNDUyNTQ4ODE=@MTE1NDQ5MzYwMDAwMDAwNDUzMzY0MDM=@MTEzMzI0OTE0NTAwMDAwMDA0NTcwODMzOQ==@MTE1NDQ5OTIwMDAwMDAwNDYwMDc4OTE=@MTE1NDQ5OTUwMDAwMDAwNDcwNjg1ODc=@MTE0MDkyMjEwMDAwMDAwNDcxOTA1OTM=@MTE1NDUyMjEwMDAwMDAwNDUzNjkwNDE=@MTE0MjI0NTE1MjAwMDAwMDA0NzM5ODI2Mw==@MTE0MjI0NTE1MjAwMDAwMDA0NzM5MzU0OQ==@MTE0MDkyMjEwMDAwMDAwNDc1Nzk2NjM=@MTE0MDQ3MzIwMDAwMDAwNDc2MjYzMTk=@MTE0MDQ3MzIwMDAwMDAwNDgxNDQxMDk=@MTAxNzIyNTU1NDAwMDAwMDA0ODE5MzMxNw==@MTEyNjkzMjAwMDAwMDAwMDQ5MTU1MTE5@MTEyNjE4NjQ2MDAwMDAwMDQ5MTY0NzYz@MTAxODc2NTEzMDAwMDAwMDAyODgwODk4NQ==@MTEyOTEzNzMzMDAwMDAwMDQ5NTg3MDUx@MTEyNjkzMjAwMDAwMDAwMDQ5NjAzNDQ1@MTEzMzE4MTU2MDAwMDAwMDQ5NjA1Mzkx@MTEzMzkyODgwMDAwMDAwNDk2MDU3NzE=@MTEyNjE4NjQ2MDAwMDAwMDQ5NjE1MDYz@MTAxNzIxMDc1MTAwMDAwMDA0OTYzMDk5Nw==@MTE1NDY3NTMwMDAwMDAwNDk2NDY5NDE=@MTAxNzIyNTU1NDAwMDAwMDA0OTYzMTA4OQ=="

	#Lili
	Lili_20210121_pet="MTE1NDUyMjEwMDAwMDAwNDM4MjYyMDE="
	
	#己巳
	jisi_20201211_pet="MTE1NDUwMTI0MDAwMDAwMDQyODExMzU1@MTE0MDQ3MzIwMDAwMDAwNDc0NDU4MTU=@MTEzMzI0OTE0NTAwMDAwMDA0Mjg4NTczOQ==@MTE1MzEzNjI2MDAwMDAwMDQ5NjUwMjkz"
	
	#Luckies
	Luckies_20210205_pet="MTE1NDUyMjEwMDAwMDAwNDQxMjY1MTM=@MTE1NDUwMTI0MDAwMDAwMDQ0MTI2NTc1"

	#余生一个浪
	yushengyigelang_2021017_pet="MTE1NDUyMjEwMDAwMDAwNDUyODcwOTM=@MTEzMzI0OTE0NTAwMDAwMDA0NTM1MTg4Nw==@MTEzMzI0OTE0NTAwMDAwMDA0NTIxOTk3MQ==@MTAxODcxOTI2NTAwMDAwMDAzMTE4MjU2Nw==@MTEyNjE4NjQ2MDAwMDAwMDQ4MTI4MjE3@MTEzMzE5ODE0NDAwMDAwMDA0OTYyMzYwNQ==@MTAxNzIxMDc1MTAwMDAwMDA1MDc1ODg5NQ==@MTEyOTEzNzMzMDAwMDAwMDUwOTM5OTU1@MTEzMzI1MTE4NDAwMDAwMDA1NTQwMzA0OQ=="

	#游戏真好玩
	youxizhenhaowan_20201229_pet="MTAxODc2NTEzNDAwMDAwMDAyMTk5NDI5Mw==@MTAxODc2NTEzMjAwMDAwMDAyMjY5OTk0Nw==@MTE1NDQ5OTUwMDAwMDAwNDQ1OTY2NTU=@MTEzMzI1MTE4NTAwMDAwMDA1MDExMjQzNw==@MTEzMzI0OTE0NTAwMDAwMDA0NjUyODE2NQ=="

	#谈何容易
	tanherongyi_20210121_pet="MTAxODc2NTEzNDAwMDAwMDAwNTgyNjI2Nw==@MTEzMzI0OTE0NTAwMDAwMDA0Mzg1NTQwMQ==@MTE1NDUyMjEwMDAwMDAwNDM4NTU0MDU=@MTEyOTEzNzMzMDAwMDAwMDUwMzQ5Mzkx"

	#无聊
	wuliao_20210214_pet="MTE1NDAxNzcwMDAwMDAwMzk5NDUxMTE=@MTEzMzI0OTE0NTAwMDAwMDA0NDg0NzkxOQ=="

	#whiteboy
	whiteboy_20190711_pet="MTAxODc2NTEzMzAwMDAwMDAwNjU4NDU4NQ==@MTAxODc2NTE0NzAwMDAwMDAwNDI4ODExMQ=="

	#阿东
	adong_20201108_pet="MTAxODc2NTEzMTAwMDAwMDAyMTIwNTc3Nw==@MTEzMzI0OTE0NTAwMDAwMDA0MjE0MjUyNQ=="

	#一路向北
	superbei666_20201124_pet="MTAxODcxOTI2NTAwMDAwMDAyNjc1MzUzMw==@MTE1NDQ5OTIwMDAwMDAwNDE4MDc3MzE="

	#dream
	dreamer_20200524_pet="MTAxODc2NTEzMjAwMDAwMDAyNjM5Njg3Mw==@MTE1NDUwMTI0MDAwMDAwMDQ0MTg0MzAz@MTE1NDUyMjEwMDAwMDAwNDM4NTU3OTE=@MTE1NDQ5MzYwMDAwMDAwNDM4NTU4MTc="

	#傻子
	cainiao5_20201209_pet="MTAxODc2NTEzMzAwMDAwMDAyMTg1ODcwMQ=="
	
	#小草
	xiaocao_20210102_pet="MTE1NDQ5MzYwMDAwMDAwNDI4MjM0OTE=@MTE1NDQ5OTIwMDAwMDAwNDM3NTg4ODk=@MTEyOTEzNzMzMDAwMDAwMDU0NzU1MzUz@MTE1NDQ5OTIwMDAwMDAwNDAyNzM4NzE="

	#法外狂徒张三
	fwktzs_20210522_pet="MTAxNzIxMDc1MTAwMDAwMDA1MTAwNzg3NQ==@MTEyNzEzMjc0MDAwMDAwMDUyOTc0MTc3@MTE1MzEzNjI2MDAwMDAwMDUzNzY3NTIx@MTEyNzEzMjc0MDAwMDAwMDUzNjg2MTE5"

	#屌大话事
	ddhs_20210603_pet="MTAxODcxOTI2NTAwMDAwMDAzMTE4MDQzOQ==@MTEzNzcwMTQ4MDAwMDAwMDQ5NzYxNzg1@MTEyNjkzMjAwMDAwMDAwMDU1MTcwMDE5"

	#男人的肩膀
	nrdjb__20210410_pet="MTE0MDkyMjEwMDAwMDAwNDc1NjE5MDM=@MTEyNDI1MTEyMDAwMDAwMDA0NzYxODA4Mw==@MTEzNzcwMTQ4MDAwMDAwMDQ3ODg3ODkz@MTEzMzI1MDE4NzAwMDAwMDA0OTczOTMzNw==@MTE0MjI0NTE1MjAwMDAwMDA0NzYxODE0OQ==@MTEyMTY4MjgwMDAwMDAwNDk2NTkyOTM=@MTEzNzg0MjA4MDAwMDAwMDQ5NjY5Nzkz@MTE0MjI0NTE1MjAwMDAwMDA0NzU3NTkwOQ==@MTE5MzEwNTEzODAwMDAwMDA1MDQ2NjU0OQ==@MTEyNjE4NjQ2MDAwMDAwMDUwNDY3MTg1@MTEzMzI1MTE4NTAwMDAwMDA1MDg2MjAyMw==@MTEyNzEzMjc0MDAwMDAwMDUyMTc0Nzg1@MTEyNjE4NjQ2MDAwMDAwMDUzMzYzMTA5@MTEyOTEzNzMzMDAwMDAwMDUzODY3MzIx@MTAxODc2NTEzMzAwMDAwMDAxOTM4Mzg0Nw==@MTE1NDY3NTMwMDAwMDAwNTA4NjIwNDM="

	#白嫖怪
	bpg_20210101_pet="MTE1NDY3NTMwMDAwMDAwNTAwMTY0MTk="

	#苏酒
	sujiu_20200213_pet="MTAxODc2NTEzMjAwMDAwMDAyMjc4OTI5OQ==@MTAxODExNTM5NDAwMDAwMDAzOTYzODY1Nw==@MTE1NDY3NTMwMDAwMDAwNTI1NTI0ODc=@MTE0MDQ3MzEwMDAwMDAwNDc5OTIwNTM=@MTEyNzEzMjc0MDAwMDAwMDU1MjMzMjgx"
	
	random_pet="$dreamer_20200524_pet@$adong_20201108_pet@$whiteboy_20190711_pet@$wuliao_20210214_pet@$tanherongyi_20210121_pet@$wjq_20190516_pet@$NanshanFox_20210303_pet@$Lili_20210121_pet@$jisi_20201211_pet@$Luckies_20210205_pet@$yushengyigelang_2021017_pet@$youxizhenhaowan_20201229_pet@$superbei666_20201124_pet@$cainiao5_20201209_pet@$xiaocao_20210102_pet@$fwktzs_20210522_pet@$ddhs_20210603_pet@$nrdjb__20210410_pet@bpg_20210101_pet@$sujiu_20200213_pet"
	random="$random_pet"
	random_array
	new_pet_set="'$new_pet1@$zuoyou_20190516_pet@$Javon_20201224_pet@$jidiyangguang_20190516_pet@$ashou_20210516_pet@$Jhone_Potte_20200824_pet@$chiyu_pet@$random_set',"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	pet_rows=$(grep -n "shareCodes =" $dir_file_js/jd_pet.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$pet_rows a \ $new_pet_set " $dir_file_js/jd_pet.js
		js_amount=$(($js_amount - 1))
	done

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	petcode_rows=$(grep -n "PetShareCodes = \[" $dir_file_js/jdPetShareCodes.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$petcode_rows a \ $new_pet_set " $dir_file_js/jdPetShareCodes.js
		js_amount=$(($js_amount - 1))
	done

	#种豆
	new_plantBean1="4npkonnsy7xi3n46rivf5vyrszud7yvj7hcdr5a@fn5sjpg5zdejm2ebnsce2wsjvtu5xkzq4dvbdti@mlrdw3aw26j3xeqso5asaq6zechwcl76uojnpha@nkvdrkoit5o65lgaousaj4dqrfmnij2zyntizsa@u5lnx42k5ifivyrtqhfjikhl56zsnbmk6v66uzi@tnmcphpjys5icix3quq2q2em3bzzciltix2t6nq@u5lnx42k5ifiu6wgvad764nzeefohexgwsutp4y@5sxiasthesobwa3lehotyqcrd4@b3q5tww6is42gzo3u67hjquj54@7k6xprwzbjhon2vefeskk7wes4nt65psczooguy@nkiu2rskjyeta74slb2xiwexa3kbfarnzadmmeq@b3q5tww6is42gzo3u67hjquj54"
	zuoyou_20190516_pb="sz5infcskhz3woqbns6eertieu@mxskszygpa3kaouswi7rele2ji@4npkonnsy7xi3vk7khql3p7gkpodivnbwjoziga@cq7ylqusen234wdwxxbkf23g6y@iu237u55hwjio2j4q6dveezrcun6yqgyh6iyj7a@qo77jw3hunt3nwx5wzintmzzyeetch6vbwqskmy@dhsx55vjyuzkxicr2ttrsc6c47dzqhvbnhxu33y@66nvo67oyxpycn4ikn3qhdxcdn6mteht2kjzfma@66nvo67oyxpycs3powuv6bovdtfmlunzvyx4roa@suqg5cye47cqmod5cabkwhsnvol5lpdrhgb3frq"
	Javon_20201224_pb="wpwzvgf3cyawfvqim3tlebm3evajyxv67k5fsza"
	Javon_random_pb="g3ekvuxcunrery7ooivfylv2ci5ac3f4ijdgqji@wgkx2n7t2cr5oa6ro77edazro3kxfdgh6ixucea@qermg6jyrtndlahowraj6265fm@rug64eq6rdioosun4upct64uda5ac3f4ijdgqji@t4ahpnhib7i4hbcqqocijnecby@5a43e5atkvypfxat7paaht76zy@gdi2q3bsj3n4dgcs5lxnn2tyn4@mojrvk5gf5cfszku73tohtuwli@l4ex6vx6yynouzcgilo46gozezzpsoyqvp66rta@beda5sgrp3bnfrynnqutermxoe"
	chiyu_pb="crydelzlvftgpeyuedndyctelq"
	ashou_20210516_pb="3wmn5ktjfo7ukgaymbrakyuqry3h7wlwy7o5jii@chcdw36mwfu6bh72u7gtvev6em@mlrdw3aw26j3w2hy5trqwqmzn6ucqiz2ribf7na@olmijoxgmjutzdb4pf2fwevfnx4fxdmgld5xu2a@yaxz3zbedmnzhemvhmrbdc7xhq@olmijoxgmjutyy7u5s57pouxi5teo3r4r2mt36i@olmijoxgmjutzh77gykzjkyd6zwvkvm6oszb5ni@dixtq55kenw3ykejvsax6y3xrq"
	xiaobandeng_pb="olmijoxgmjutzcbkzw4njrhy3l3gwuh6g2qzsvi@olmijoxgmjuty4tpgnpbnzvu4pl6hyxp3sferqa"
	xiaodengzi_20190516_pb="kcpj4m5kmd4sfdp7ilsvvtkdvu@4npkonnsy7xi32mpzw3ekc36hh7feakdgbbfjky@j3yggpcyulgljlovo4pwsyi3xa@uvutkok52dcpuntu3gwko34qta@vu2gwcgpheqlm5vzyxutfzc774"
	jidiyangguang_20190516_pb="e7lhibzb3zek2zin4gnao3gynqwqgrzjyopvbua@4npkonnsy7xi3smz2qmjorpg6ldw5otnabrmlei"

	#比白人
	wjq_20190516_pb="sv3wbqzfbzbip22dluyg3kqa5a@4npkonnsy7xi2fg36jqtqkr72x5jddqif4oiama@olmijoxgmjutzbcaz2ejl2cotlb5qzoacbk2sxy@47m36n7ro5guth5f23tvm5fyxx2owrpkwxpmb3q@olmijoxgmjutz4ip3mlwnzqxafeg3yeop5pjqmy@7qol36k2wexal2siu5fu44emhalach3wccuurdq@kdtv2dsifuwcshhvggjv3hxas5pqj5ua4v6agfq@uujy3h5und6zwpocrsz5yihxha5ac3f4ijdgqji@qi5s4ev7e4omhxy2hdcghhswqa@5vvg5oletpyw7whygx3bdt7bfy5ac3f4ijdgqji@x32mroyqad4vy4cfhens5qoxtodgs2pljucho2y@mlrdw3aw26j3xeifj2743ldeuoxyb7krfj7mwfi@7qol36k2wexakvhdxzjcskhgnyxzeh2riupqjfa@e7lhibzb3zek2cjf742xybuz32ysi2dozlnvjky"

	#南山忆只狸
	NanshanFox_20210303_pb="ciue6ohtv7r3wcx6l7kb2trrc3l5vknx47277hi@olmijoxgmjutz53j2fxs5vi5olewxtttsjadtuy@l4ex6vx6yynovcxjwvmqdtk7zk32zmkp5skvdyy@zalmhfy34qahzjpq4r7s62tsf66ev3ukvxhsp6i@h3cggkcy6agkguhymcpp3wzsy2zc3aftfjwau3q@t7obxmpebrxkdikzvu24ze3o3le2sjlivykrmca@2vgtxj43q3jqyxm4pzec2nhm3ftkamipodkhaka@mlrdw3aw26j3x3wggfzdhfon4uiuzmkq7hdt7jq@e7lhibzb3zek26dyzu5w2furny4rqorn4rsndyy@x3x7xhsua3bmiz67jzdwhexwtcjwqfxalbniaay@wsr6thb5bd25kh3n6lzgafa6b6pmhkfjt3zql4a@e7lhibzb3zek36qgapszjjumi4nhdx4wxipoymi@e7lhibzb3zek3lqi2vghnvw5i2rtlplqsdde4ma@olmijoxgmjuty36rm5srvhxplrstiiao7fcgzyy@e7lhibzb3zek3pnn6nn5bwc4em2nns2z64j7mkq@mlrdw3aw26j3xrggjbpnypqkgh6oud4etfkht3a@7qol36k2wexakaxtmmksdngudu7eotuapecp3mq@olmijoxgmjutztjurvkyz7l5zs7rvu5ymlrz5xy@wrqpt6mmzjh2zmobm7vu2756w7yxyxaif5gfcpi@qwmkwedt5pnucx6ura6h7fexcsg2444ycms2rqy@olmijoxgmjutyc5ltjminzcnsnu3a4s75rv2a6i@m5dbjzf7aqwt35a2zxtvvcuj7pjvpeuemdctgjy@olmijoxgmjutyq4kv4v4qha4qsn6nwcbu5shu7q@e7lhibzb3zek2newt4kq22fbduvoy3aq3o2to6y@mlrdw3aw26j3x4glgmmnwlo7caxow6i5dol6rva@u72q4vdn3zes3kcwr6wn62bcbevnb5on7niyxri@olmijoxgmjutygkncksia3veh5xue2emzdd2pdi@tnmcphpjys5ich6ccffqeudobtvhixdtahfrvhy@o7eiltak46s2xirajkeyuomz3oa54pgd6klan4a@qjr4b6t5jjnzoz3rbp6e5smzhy"

	#Lili
	Lili_20210121_pb="n24x4hzuumfuu3a26r2o45ydxe"
	
	#己巳
	jisi_20201211_pb="qm7basnqm6wnqtoyefmgh65nby@eeexxudqtlamobesoisd3c4ygur4f7o46eyzl3q@mnuvelsb76r27b4ovdbtrrl2u5a53z543epg7hi@4npkonnsy7xi2mpzzclrkctwylbyoffpyhsqwri"
	
	#Luckies
	Luckies_20210205_pb="5itdl72qrkd7lbepefbvkmopla@e7lhibzb3zek2qrn2fxojpzh5oatijgpijg73ba"
	
	#余生一个浪
	yushengyigelang_2021017_pb="42jxwmz7ybhbkqdsfn5gpb5kde@pfuw5smhkmxx4gbokvsi3yifr4@uwgpfl3hsfqp3b4zn67l245x6cosobnqtyrbvaa@mlrdw3aw26j3xb6wpvnjtud5ktrtah4errvbety@66nvo67oyxpycucmbw7emjhuj6xfe3d3ellmesq@h3cggkcy6agkgtvxoy76nn63ki7ans4blqb54vq@mlrdw3aw26j3x7kfujww6gopofqmecdfz5cfu4q@e7lhibzb3zek3cwi3hjt4dbtfsqjiraewatunya@mlrdw3aw26j3whntyx2texgiynojbkrid34l3eq"
	
	#游戏真好玩
	youxizhenhaowan_20201229_pb="mlrdw3aw26j3ws2ofu6z6zmp2makwftxpb2slny@nkvdrkoit5o65kqag3swpe4wvp4qhfiwkrlshdi@4npkonnsy7xi3zj7xztax2zk6jnuc7vhxmykmga@4npkonnsy7xi26keghkk4dvbjim75jgxlsoiwda@4azderesnaqa5bxfqtcn423cxm"
	
	#谈何容易
	tanherongyi_20210121_pb="pmxp2qr7mydqspc3tkg77sgvvq@o7eiltak46s2xndhlcezeax3dgahzy5y5f777ii@4npkonnsy7xi2sk3g2epg2bye37g7vtgfxc3lvi@mlrdw3aw26j3xnz7savvsdqpku6pdzwhoveqrwi"

	#无聊
	wuliao_20210214_pb="v6kcqz3wklbhayiw6oadtlos343h7wlwy7o5jii@xooz5rk4vgwfnuxjhefh6ceqwma5yrgx34uq26y"

	#whiteboy
	whiteboy_20190711_pd="jfbrzo4erngfjdjlvmvpkpgbgie7i7c6gsw54yq@e7lhibzb3zek3uzcrgdebl2uyh3kuh7kap6cwaq"

	#阿东
	adong_20201108_pb="qhw4z5vauoy4gfkaybvpmxvjfi@olmijoxgmjuty6wu5iufrhoi6jmzzodszk6xgda"

	#一路向北
	superbei666_20201124_pb="gcdr655xfdjq764agedg7f27knlvxw5krpeddfq@gcdr655xfdjq764agedg7f27ko37tplq475lryq"

	#dream
	dreamer_20200524_pb="6zn5u4prlglstwnl6wsmt2tyce3h7wlwy7o5jii@mlrdw3aw26j3x6dft2224ol7uxl4pt3brorrnmq@4npkonnsy7xi3cryuz47q6fnckyklpz2b3hypuy@e7lhibzb3zek2fezcmre67qfy5wbopeqkbld5oq@452ugavbuefo27jz6vmbvonb5q5ac3f4ijdgqji"

	#傻子
	cainiao5_20201209_pb="mlrdw3aw26j3wuxtla52mzrnywbtfqzw6bzyi3y"
	
	#小草
	xiaocao_20210102_pb="pmvt25o5pxfjzjmrc7fubka5hu3h7wlwy7o5jii@tnmcphpjys5id33ymb3hnv67vtcdorfs7bmxuvi@lyrarvwgbml3rmymqxquhyl2ym@4npkonnsy7xi2zd4jyw4chqrr3wrc2cpui6q5mq@olmijoxgmjutzxumjqxbqtjhcnqkgvecdiey4ea"

	#法外狂徒张三
	fwktzs_20210522_pb="mxh3f6mj6bnp47rr4hzvgjspdq@e7lhibzb3zek3f5jlesp7a3pdgvl6iuxhp42riy@e7lhibzb3zek3w7j3dup4zu5idntbrv6yw5w36a@f5pavyxxlph5okvnqdbkpotqnauxqj6nyl5hm5a"

	#屌大话事
	ddhs_20210603_pb="mlrdw3aw26j3xltrtksfk72uf334zcoz5oy57jq@gcdr655xfdjq67byasjddof6fqh27553rl3dqba@suqg5cye47cqmby7st7ycicbqy3ohjhnuynfhsi"

	#男人的肩膀
	nrdjb_20210410_pb="mlrdw3aw26j3xrmo27a7gwhqib6tphgfe5jp4qa@e7lhibzb3zek2uiwehcjskshpbv4rcvx64hk4ey@e7lhibzb3zek36kzitj4f4kik7tuc2ycyj2ijba@gou7sxm3hztwp2yyywal57nlokcsmt72xnyb65a@t7obxmpebrxkcqooz2nbfanus76oyfn6rcrnsfi@gou7sxm3hztwoymqqgnsbisb6wt5bsenwtaawpy@l4ex6vx6yynouq7xkpw3qhhe5bbbjyxfseisc4i@ozv5zqmojvq5esnehe7ggu6tbu@e7lhibzb3zek3lpd52sfotabetn2565ntspapky@wsr6thb5bd25kgh7h6sb7bxgtcux4vuptzsjetq@qmnmamd3ukiwqyfnl6vz7z2bhqqr5mbi3ut3a6a@7jcz4j7m22med46n7e3ondhoifaq3wm2kn32m2i@eeexxudqtlamphmc3b4qcjifrkxrwbpw5dmt6tq@yhgveqpmpmqznondv7ujyzdyqfusc25h44s5mri@4npkonnsy7xi2nmxrxeyjvpppbbhljfbokrfp2i@ebxm5lgxoknqc5gtb4a3hb6spvcfjtjxigjs6ai@olmijoxgmjutzlikwi7fh4lssftlzegs3bgboxa@o6anvgitbfdkpnbqvvtvyxm4nkrvgy637ira64a@ktnqu7nqc7dimy23nax5z2r6ssz67dyxyihopaa@e7lhibzb3zek3fukfp7glenvobridh2cjer44la@wsr6thb5bd25k3avrly2tzpterzalu4jn2sdipa"

	#白嫖怪
	bpg_20210101_pb="66nvo67oyxpychkle6u4mw6775aof7gqvnsf72a"

	#苏酒
	sujiu_20200213_pb="mlrdw3aw26j3xzd26qnacr3cfnm4zggngukbhny@okj5ibnh3onz7yqop3tum45jigtppsihwynzavy@rtsljotwy2w34jkovhwbzoia2nk4qqxespo4omy@@dhsx55vjyuzkwti3nr2gm4nkm42irmm4rbodkaq@ihhl4ywczktvkk44s34cfpixnkckqm6rdb6d3f2mez45f53hahfq@olmijoxgmjutzo5exibb7w6dd2uktyapfdcxabq"
	
	random_plantBean="$dreamer_20200524_pb@$adong_20201108_pb@$whiteboy_20190711_pd@$wuliao_20210214_pb@$tanherongyi_20210121_pb@$wjq_20190516_pb@$NanshanFox_20210303_pb@$Lili_20210121_pb@$jisi_20201211_pb@$Luckies_20210205_pb@$yushengyigelang_2021017_pb@$youxizhenhaowan_20201229_pb@$superbei666_20201124_pb@$cainiao5_20201209_pb@$xiaocao_20210102_pb@$fwktzs_20210522_pb@$ddhs_20210603_pb@$nrdjb_20210410_pb@$bpg_20210101_pb@$sujiu_20200213_pb"
	random="$random_plantBean"
	random_array
	new_plantBean_set="'$new_plantBean1@$zuoyou_20190516_pb@$Javon_20201224_pb@$jidiyangguang_20190516_pb@$ashou_20210516_pb@$xiaobandeng_pb@$chiyu_pb@$random_set',"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	sed -i "s/shareCodes = \[/shareCodes = \[\n/g" $dir_file_js/jd_plantBean.js
	pb_rows=$(grep -n "shareCodes =" $dir_file_js/jd_plantBean.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$pb_rows a \ $new_plantBean_set " $dir_file_js/jd_plantBean.js
		js_amount=$(($js_amount - 1))
	done

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	pbcode_rows=$(grep -n "PlantBeanShareCodes = \[" $dir_file_js/jdPlantBeanShareCodes.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$pbcode_rows a \ $new_plantBean_set " $dir_file_js/jdPlantBeanShareCodes.js
		js_amount=$(($js_amount - 1))
	done

	#京喜工厂
	new_dreamFactory="4HL35B_v85-TsEGQbQTfFg==@q3X6tiRYVGYuAO4OD1-Fcg==@Gkf3Upy3YwQn2K3kO1hFFg==@1s8ZZnxD6DVDyjdEUu-zXA==@MrEZ6KupbLvOQ_2LDf_xgQ==@jwk7hHoEWAsvQyBkNrBS1Q==@iqAUAWEQx86GvVthAu7-jQ==@ga_4DMiCZm_RqninySPJQw==@0_XIjHNNfhz2vahAPsORWg=="
	zuoyou_20190516_df="oWcboKZa9XxTSWd28tCEPA==@sboe5PFeXgL2EWpxucrKYw==@rm-j1efPyFU50GBjacgEsw==@tZXnazfKhM0mZd2UGPWeCA==@9aUfCEmRqRW9fK7-P-eGnQ==@4yiyXPAaB_ReMPQy-st4AQ==@MmOfTa6Z79J9XRZA4roX1A==@rlJZquhGZTvDFksbDMhs2Q==@DriN9xUWha-XqE0cN3u7Fg==@krMPYOnVbZAAkZJiSz5cUw=="
	Javon_20201224_df="qXsC2yNWiylHJjOrjebXgQ==@P2nGgK6JgLtCqJBeQJ0f27XXLQwYAFHrKmA2siZTuj8=@LTyKtCPGU6v0uv-n1GSwfQ=="
	Javon_20201224_random_df="P2nGgK6JgLtCqJBeQJ0f27XXLQwYAFHrKmA2siZTuj8=@Y4r32JTAKNBpMoCXvBf7oA==@KDhTwFSjylKffc2V7dp5HQ==@UdTgtWxsEwypwH1v6GETfA==@LTyKtCPGU6v0uv-n1GSwfQ==@JuMHWNtZt4Ny_0ltvG6Ipg==@WnaDbsWYwImvOD1CpkeVWA==@Z2t6d_X8aMYIp7IwTnuNyA==@1Oob_S4cfK2z2gApmzRBgw==@BsCgeeTl_H2x5JQKGte6ow==@y7KhVRopnOwB1qFo2vIefg==@zS1ivJY43UFvaqOUiFijZQ==@USNexnDxgdW3h1M84IA8hQ==@QcxX97p7yNgImbEEZVEcyw==@N3AXGi-1Gt51bwdrCo76-Q=="
	chiyu_df="us6se4fFC6cSjHDSS_ScMw=="
	Jhone_Potte_20200824_df="Q4Rij5_6085kuANMaAvBMA==@gTLa05neWl8UFTGKpFLeog=="
	ashou_20210516_df="1rQLjMF_eWMiQ-RAWARW_w==@6h514zWW6JNRE_Kp-L4cjA==@2G-4uh8CqPAv48cQT7BbXQ==@cxWqqvvoGwDhojw6JDJzaA==@pvMjBwEJuWqNrupO6Pjn6w==@nNK5doo5rxvF1HjnP0Kwjw==@BoMD6oFV2DhQRRo_w-h83g==@PqXKBSk3K1QcHUS0QRsCBg=="
	jidiyangguang_20190516_df="w8B9d4EVh3e3eskOT5PR1A==@FyYWfETygv_4XjGtnl2YSg=="
	test_df="1s8ZZnxD6DVDyjdEUu-zXA==@oK5uN03nIPjodWxbtdxPPA==@7VHDTh1iDT3_YEtiZ1iRPA==@KPmB_yK4CEvytAyuVu1zpA==@2oz-ZbJy_cNdcrgSgRJ4Nw==@RNpsm77e351Rmo_R3KwC-g==@SY7JjLpgyYem-rsx1ezHyQ==@ziq14nX6tEIoto9iGTimVQ=="

	#比白人
	wjq_20190516_df="43I0xnmtfBvt5qiFm6ftxA==@Suo8Gk5ZAB8bY5RgiNgdlw==@NoLbYPmp_p3aXBkDRwdE2Q==@-sO6tqkIoeAscsS36ljDMA==@1ZreRGjQrXEAVEk9h6kYBg==@qXB1yTY4gKnmblhlHMqPNrt_8ZxwR8bU8sI5om5_iOA=@XlnTBbI_A83LC6sVZsSt9A==@5nSB1JZvQ3Rhw1P7lk7WiA==@qloqgn5XJVT6gHqzfDAluA==@BK7bP7bzE4GC9h5GPSiMUg==@7R0Uw90k8K8knhyV5NCi7Q=="

	#南山忆只狸
	NanshanFox_20210303_df="yPwJfzwijXtviR92IUzreA==@uQYCmXVYxC3TgnkWlBC5ow==@eSLN49Y-cyfdIeBJ8--W4Q==@0LoJKMF2z6q6ovH7kQNFsg==@V4iSET1KlJuMsf1pFuqfCw==@5zeEy4DZc8n3B-uxx7_-uQ==@Ro1eGwtyQMtdETPd6fOGkw==@m9R516G3-8n_CdFpFAvDMg==@qByxP-FAxaujLBXIIATaMg==@Pdi1IoP82K_YAaBU5TdHFQ==@6wbPf3gpOd_4JJP5fzRtAg==@7s6BaPPzUH_QbF0rPq6acg==@q-Y-p5x-1rksX6G6_NQqYg==@vtyUK9IAhNInmqnA1jS2PA==@IgYuMS2mirWp3qGyUZXPlA==@v2X95auqSibTe_b-WOotBA==@t8OcqcyCMVzfg7djKIZ57A==@JxumZ0LfZfEqni29uDk7iA==@rnWHWgA5DYvhkkHGTxdOOQ==@pCKqeU0_mAVYKMElGRg3xA==@4dx3By5yr2tng51IrBVCTg==@L7tnt1Rol0VSHGaooXBgrg==@EgO_xlLlGYc5Kxi2zJ3z6g==@Df3OTEOo0qqJWu_SaWFvPg=="

	#Lili
	Lili_20210121_df="HQTSebNAjuGe4igMSpHeog=="
	
	#己巳
	jisi_20201211_df="5BOWMhgoVeCjMEjg-ssm1w==@sTpAUMutQkLF8w3r6u9wCw==@i2SuMzTz18a7afGrr9zn6H86hjAEmRIdJD54NZbw_dg="
	
	#余生一个浪
	yushengyigelang_2021017_df="qCG9QOJTxIDm0m8RAzmj_A==@3mO9RC7oitABfebSxFZntg==@jxV8UW_ZoHgE7HYvdofwtA==@q4hywbUaNk0XuRmiMP4Avg==@BFSsGKVKebcBAe1MG5cU8A==@rrO51OzURrvemMbKisbh0g==@2MW25OcosONIzAJxiQoJGg==@ivwtkqZnCgBWIp4Fh1LO5g==@PdZBaGuhRK7Lq3yZ9zQK2w=="

	#游戏真好玩
	youxizhenhaowan_20201229_df="VCCRGELL4kcTt-k5f1JuzQ==@_MwTo0claD9j3U7jdnX5kg=="

	#谈何容易
	tanherongyi_20210121_df="6FDe4u9M6bpexYt56q3tkA==@1qghHzQ8cbiaeDamUxjf5Q==@TR0NgszBNvxdcrohLZDvgg==@qOywEW9dxw7K_501KiW-Lg=="

	#无聊
	wuliao_20210214_df="JErwGyIaLAyHtTRlNVQFFg==@CIbMmbN2ZCilYQLCGc_3iQ=="

	#whiteboy
	whiteboy__20190711_df="U_NgGvEUnbU6IblJUTMQV3F7G5ihingk9kVobx99yrY=@BXXbkqJN7sr-0Qkid6v27A==@QVCi7bxRyA1QRDnBd4LMHQ==@H0ksRV4EFpcIfUdUQBzX7A=="

	#阿东
	adong_20201108_df="QBGc1MnsD3uSN5nGDMAl7A==@a8PK5kDEvblgKUUTLP0e2w=="

	#一路向北
	superbei666_20201124_df="5_h5YOeKKB-7m3ejIBrkyg==@B0236CW-TXeW_L-ESFnmpA=="
	
	#dream
	dreamer_20200524_df="mWZ0hopgeC48h6TjnQIPRQ=="

	#傻子
	cainiao5_20201209_df="LBoBCAhsmQGJdrWJilbWJQ=="
	
	#小草
	xiaocao_20210102_df="Y1heEn9Iva97i-IjTtfI9Q==@IRwRnh7xAVI3o4zLblOYJQ==@nx8Q4Fb5Y9TS1V7pkfg9GA=="

	#法外狂徒张三
	fwktzs_20210522_df="UmqlLQlSpQE90M5gY5sGZw==@oUhF8gTDEJzTkR53wXONqg==@9ivTTstgmUlBhyD1HVq85Q==@pAUDEYLE89ClLDGo0nim0Q=="

	#屌大话事
	ddhs_20210603_df="3my4yYrvmmvshRRBiJ-Ctg==@HgIiK7voFuYjVpfgWPqW4Q==@JSJaBlkCy-e7L9sUKoQsfA=="

	#男人的肩膀
	nrdjb_20210410_df="GlARgeZqZgq2YlOd1iVvpQ==@hSrF4ewFbBtZqFkUty_7_w==@Okmzf0DkUi4jT35ZFO9bSg==@BaoEK1ct0fpYFNMgG0yTEA==@ZLHWbIot-qsuyVHdu5MMTA==@MpjCgijJgPPXjH3cV5Cqjw=="

	#白嫖怪
	bpg_20210101_df="IIVOSKSeLKp4Fn_4hoKJ1Q=="

	#苏酒
	sujiu_20200213_df="-Q2ZHEeaaSlQPB2RKIk_Zg==@mjjfVZ2Skl5A-TsfqIGinw=="
	
	random_dreamFactory="$test_df@$dreamer_20200524_df@$adong_20201108_df@$whiteboy__20190711_df@$wuliao_20210214_df@$tanherongyi_20210121_df@$wjq_20190516_df@$NanshanFox_20210303_df@$Lili_20210121_df@$jisi_20201211_df@$yushengyigelang_2021017_df@$youxizhenhaowan_20201229_df@$superbei666_20201124_df@$cainiao5_20201209_df@$xiaocao_20210102_df@$fwktzs_20210522_df@$ddhs_20210603_df@$nrdjb_20210410_df@$bpg_20210101_df@$sujiu_20200213_df"
	random="$random_dreamFactory"
	random_array
	new_dreamFactory_set="'$new_dreamFactory@$zuoyou_20190516_df@$Javon_20201224_df@$jidiyangguang_20190516_df@$ashou_20210516_df@$Jhone_Potte_20200824_df@$chiyu_df@$random_set',"

	df_rows=$(grep -n "inviteCodes =" $dir_file_js/jd_dreamFactory.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$df_rows a \ $new_dreamFactory_set " $dir_file_js/jd_dreamFactory.js
		js_amount=$(($js_amount - 1))
	done

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	dfcode_rows=$(grep -n "shareCodes = \[" $dir_file_js/jdDreamFactoryShareCodes.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$dfcode_rows a \ $new_dreamFactory_set " $dir_file_js/jdDreamFactoryShareCodes.js
		js_amount=$(($js_amount - 1))
	done


	#京喜开团
	sed -i "s/helpFlag = true/helpFlag = false/g" $dir_file_js/star_dreamFactory_tuan.js

	#东东工厂
	new_ddgc="T0225KkcRxoZ9AfVdB7wxvRcIQCjVWnYaS5kRrbA@T0225KkcRUhP9FCEKR79xaZYcgCjVWnYaS5kRrbA@T0205KkcH0RYsTOkY2iC8I10CjVWnYaS5kRrbA@T0205KkcJEZAjD2vYGGG4Ip0CjVWnYaS5kRrbA"

	new_ddgc_set="'$new_ddgc',"

	sed -i "s/inviteCodes = \[/inviteCodes = \[ \n/g" $dir_file_js/jd_jdfactory.js

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	ddgc_rows=$(grep -n "inviteCodes =" $dir_file_js/jd_jdfactory.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$ddgc_rows a \ $new_ddgc_set " $dir_file_js/jd_jdfactory.js
		js_amount=$(($js_amount - 1))
	done

	#京东试用
	sed -i "/jd_try/d" $cron_file
	JD_TRY=$(cat $openwrt_script_config/jd_openwrt_script_config.txt | grep "JD_TRY=" | awk -F "\"" '{print $2}')
	if [ "$JD_TRY" == "true" ];then
		#jd_try变量(更多详细内容请查看/usr/share/jd_openwrt_script/JD_Script/js/jd_try.js)
		jd_try_ck=$(cat $openwrt_script_config/jd_openwrt_script_config.txt | grep "jd_try_ck" | awk -F "\"" '{print $2}')

		if [ ! -d "$dir_file/jd_try_file" ]; then
			mkdir $dir_file/jd_try_file
			mkdir $dir_file/jd_try_file/tmp
		else
			rm -rf $dir_file/jd_try_file/*
			mkdir $dir_file/jd_try_file/tmp
		fi

		ln -s $openwrt_script_config/sendNotify.js $dir_file/jd_try_file/tmp/sendNotify.js
		ln -s $openwrt_script_config/USER_AGENTS.js $dir_file/jd_try_file/tmp/USER_AGENTS.js
		cp $dir_file_js/jd_try.js $dir_file/jd_try_file/jd_try.js
		wget https://raw.githubusercontent.com/ITdesk01/JD_Script/main/JSON/jdCookie.js -O $dir_file/jd_try_file/jdCookie.js

		jd_try_if=$(grep "jd_try" $cron_file | wc -l)
		if [ "$jd_try_if" == "0" ];then
			echo "检测到试用开关开启，导入一下计划任务"
			echo "0 10 * * * $dir_file/jd.sh jd_try >/tmp/jd_try.log" >>$cron_file
			/etc/init.d/cron restart
		else
			echo "京东试用计划任务已经导入"
		fi

		if [ ! "$jd_try_ck" ];then
			ck_num=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
			for i in `seq $ck_num`
			do
			{
				cp $dir_file/jd_try_file/jd_try.js  $dir_file/jd_try_file/tmp/jd_try$i.js
				cp $dir_file/jd_try_file/jdCookie.js $dir_file/jd_try_file/tmp/jdCookie$i.js
				sed -i "s/jdCookie.js/jdCookie$i.js/g" $dir_file/jd_try_file/tmp/jd_try$i.js

				jd_tryck=$(sed -n "$i p" $openwrt_script_config/js_cookie.txt)
				sed -i "5a $jd_tryck" $dir_file/jd_try_file/tmp/jdCookie$i.js
			}
			done
		else
			echo "$jd_try_ck" >/tmp/jd_tmp/jd_tryck.txt
			sed -i "s/@/\n/g" /tmp/jd_tmp/jd_tryck.txt
			ck_num=$(cat /tmp/jd_tmp/jd_tryck.txt |wc -l)
			for i in `seq $ck_num`
			do
			{
				cp $dir_file/jd_try_file/jd_try.js  $dir_file/jd_try_file/tmp/jd_try$i.js
				cp $dir_file/jd_try_file/jdCookie.js $dir_file/jd_try_file/tmp/jdCookie$i.js
				sed -i "s/jdCookie.js/jdCookie$i.js/g" $dir_file/jd_try_file/tmp/jd_try$i.js

				jd_tryck=$(sed -n "$i p" /tmp/jd_tmp/jd_tryck.txt)
				jd_tryck1=$(grep "$jd_tryck" $openwrt_script_config/js_cookie.txt)
				sed -i "5a $jd_tryck1" $dir_file/jd_try_file/tmp/jdCookie$i.js
			}
			done
		fi
	else
		jd_try_if=$(grep "jd_try" $cron_file | wc -l)
		if [ "$jd_try_if" == "1" ];then
			echo "检测到试用开关关闭，清理一下之前的导入"
			sed -i '/jd_try/d' /etc/crontabs/root >/dev/null 2>&1
			/etc/init.d/cron restart
		fi
		echo "京东试用计划任务不导入"
	fi

	#签到领现金
	new_jdcash="eU9Ya-iyZ68kpWrRmXBFgw@eU9YEJLQI4h1kiqNogJA@eU9YabrkZ_h1-GrcmiJB0A@eU9YM7bzIptVshyjrwlt@eU9YCLTrH5VesRWnvw5t@eU9YC6nQAZhYoiqgtw9x@eU9YCLXXPrhnhCiQlCRg@P2nGgK6JgLtCqJBeQJ0f27XXLQwYAFHrKmA2siZTuj8=@JuMHWNtZt4Ny_0ltvG6Ipg==@IRM2beu1b-En9mzUwnU@eU9YaOSwMP8m-D_XzHpF0w@eU9Yau-yMv8ho2fcnXAQ1Q@eU9YCovbMahykhWdvS9R@JxwyaOWzbvk7-W3WzHcV1mw"
	zuoyou_20190516_jdcash="f1kwaQ@a1hzJOmy@eU9Ya7-wM_Qg-T_SyXIb0g@flpkLei3@eU9YD7rQHo1btTm9shR7@eU9YE67FOpl9hTG0mjNp@eU9YBJrlD5xcixKfrS1U@eU9YG7TVDLlhgAyBsRpw@eU9YG4X6HpZMixS8lBBu@eU9YH6THD4pXkiqTuCFi"
	chiyu_jdcash="cENuJam3ZP0"
	Jhone_Potte_20200824_jdcash="eU9Yaum1N_4j82-EzCUSgw@eU9Yar-7Nf518GyBniIWhw"
	jidiyangguang_20190516_jdcash="eU9YaOjhYf4v8m7dnnBF1Q@eU9Ya762N_h3oG_RmXoQ0A"
	ashou_20210516_jdcash="IhMxaeq0bvsj92i6iw@9qagtEUMPKtx@eU9YaenmYKhwpDyHySFChQ@eU9YariwMvp19G7WmXYU1w@YER3NLXuM6l4pg@eU9YaujjYv8moGrcnSFFgg@eU9Yar_kYvwjpD2DmXER3w@ZEFvJu27bvk"
	dreamer_20200524_jdcash="IhM0aOyybv4l8266iw@eU9Yaem2bqhz-WzSyHdG1Q@eU9Ya77hNakv8GaGyXUa0Q@eU9YaLnmYv909mvWnyUX0g@aUNoKb_qI6Im9m_S"
	test_jdcash="eU9YaO62NPh18j_dyHtA1Q@IhgybO66b_4g8me6iw@eU9YJJrOFbxPixuIshNw@eU9Yaey6MK4l9D3XwnQW1Q@eU9YaeThMqkn92vSn3Mb3w@eU9Ya-XkNfRypT_UmnRBhA"
	new_jdcash_set="'$new_jdcash@$chiyu_jdcash@$jidiyangguang_20190516_jdcash@$Jhone_Potte_20200824_jdcash@$ashou_20210516_jdcash@$zuoyou_20190516_jdcash@$dreamer_20200524_jdcash@$test_jdcash',"


	sed -i "s/$.isNode() ? 5 : 5/$.isNode() ? 5 : 0/g" $dir_file_js/jd_cash.js
	sed -i "s/helpAuthor = true/helpAuthor = false/g" $dir_file_js/jd_cash.js
	sed -i "s/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateCash.json//g" $dir_file_js/jd_cash.js
	sed -i "s/https:\/\/purge.jsdelivr.net\/gh\/Aaron-lv\/updateTeam@master\/shareCodes\/jd_updateCash.json//g" $dir_file_js/jd_cash.js
	sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/Aaron-lv\/updateTeam@master\/shareCodes\/jd_updateCash.json//g" $dir_file_js/jd_cash.js
	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	sed -i "s/inviteCodes = \[/inviteCodes = \[\n/g" $dir_file_js/jd_cash.js
	cashcode_rows=$(grep -n "inviteCodes = \[" $dir_file_js/jd_cash.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$cashcode_rows a \ $new_jdcash_set " $dir_file_js/jd_cash.js
		js_amount=$(($js_amount - 1))
	done


	
	#闪购盲盒
	new_jdsgmh="T0225KkcRxoZ9AfVdB7wxvRcIQCjVWmIaW5kRrbA@T0225KkcRUhP9FCEKR79xaZYcgCjVWmIaW5kRrbA@T0205KkcH0RYsTOkY2iC8I10CjVWmIaW5kRrbA@T0205KkcJEZAjD2vYGGG4Ip0CjVWmIaW5kRrbA@T019vPVyQRke_EnWJxj1nfECjVQmoaT5kRrbA@T0225KkcRBYbo1fXKUv2k_5ccQCjVQmoaT5kRrbA@T0225KkcRh0ZoVfQchP9wvQJdwCjVQmoaT5kRrbA@T0205KkcJnlwogCDQ2G84qtICjVQmoaT5kRrbA"
	zuoyou_20190516_jdsgmh="T0064r90RQCjVQmoaT5kRrbA@T0089r43CBsZCjVQmoaT5kRrbA@T0225KkcR00boFzRKEvzlvYCcACjVQmoaT5kRrbA@T00847wgARocCjVQmoaT5kRrbA@T0205KkcI0h7jSWqZE2c7ZBiCjVQmoaT5kRrbA@T0205KkcP1xuqTGMVEWVxbdwCjVQmoaT5kRrbA@T0205KkcKGhOnDStWma-8qlNCjVQmoaT5kRrbA@T0205KkcN0Z-nxGQUXig7p5pCjVQmoaT5kRrbA@T0205KkcN3dRjT69WmCdy5R3CjVQmoaT5kRrbA@T0205KkcM1ZsnCKmQ16y56V7CjVQmoaT5kRrbA@T0144qQkFUBOsgG4fQCjVQmoaT5kRrbA@T0225KkcR0scpgDUdBnxkaEPcgCjVQmoaT5kRrbA@T0205KkcOUt-tA2xfVuXyo9RCjVQmoaT5kRrbA@T019-akMAUNKozyMcl6e_L8CjVQmoaT5kRrbA@T0127KQtF1dc8lbXCjVQmoaT5kRrbA@T0155rQ3EUBOtA2Ifk0CjVQmoaT5kRrbA@T0225KkcRRtL_VeBckj1xaYNfACjVQmoaT5kRrbA@T0225KkcRB8d9FLRKU6nkPQOdwCjVQmoaT5kRrbA@T0225KkcRRgZ_FPWKU_2k_dYJwCjVQmoaT5kRrbA@T0225KkcREoQ_VffcxulkfUNJgCjVQmoaT5kRrbA@T0225KkcREpN8FCEIxmgnKYCJwCjVQmoaT5kRrbA@T0205KkcFFZkixyvUWmHx655CjVQmoaT5kRrbA@T0225KkcRx8bo1LfcR6lwvBfIQCjVQmoaT5kRrbA@T023a3PDlaO-I_Z19blMQkyzdDwCjVQmoaT5kRrbA@T015v_hzRxwd8lfSIR0CjVQmoaT5kRrbA@T0225KkcRBsY81zXckj3kqUJJQCjVQmoaT5kRrbA"
	jidiyangguang_20190516_jdsgmh="T0225KkcR0wdpFCGcRvwxv4JcgCjVWmIaW5kRrbA@T0225KkcRBpK8lbeIxr8wfRcdwCjVWmIaW5kRrbA"
	chiyu_jdsgmh="T0117aUqCVsc91UCjVWmIaW5kRrbA"
	Javon_20201224_jdsgmh="T023uvp2RBcY_VHKKBn3k_MMdNwCjVQmoaT5kRrbA"
	Jhone_Potte_20200824_jdsgmh="T0225KkcRhsepFbSIhulk6ELIQCjVWmIaW5kRrbA@T0225KkcRk0QplaEIRigwaYPJQCjVWmIaW5kRrbA"
	jidiyangguang_20190516_jdsgmh="T0225KkcRBpK8lbeIxr8wfRcdwCjVQmoaT5kRrbA@T0225KkcR0wdpFCGcRvwxv4JcgCjVQmoaT5kRrbA"
	chiyu_jdsgmh="T0117aUqCVsc91UCjVQmoaT5kRrbA"
	
	ashou_20210516_jdsgmh="T018v_V1RRgf_VPSJhyb1ACjVQmoaT5kRrbA@T012a0DkmLenrwOACjVQmoaT5kRrbA@T0225KkcRRtN8wCBdUimlqVbJwCjVQmoaT5kRrbA@T0225KkcRkoboVKEJRr3xvINdQCjVQmoaT5kRrbA@T014_aIzGEdFoAGJdwCjVQmoaT5kRrbA@T0225KkcRhpI8VfXcR79wqVcIACjVQmoaT5kRrbA@T0225KkcRk1P8VTSdUmixvUIfQCjVQmoaT5kRrbA@T011-acrCh8Q_VECjVQmoaT5kRrbA"
	dreamer_20200524_jdsgmh="T018v_VwRB4Z_VbUIhqb1ACjVQmoaT5kRrbA@T0225KkcRRsd_QCCKBjzl_NfdwCjVQmoaT5kRrbA@T0225KkcR0xKpgHeIRKnlvEDcwCjVQmoaT5kRrbA@T0225KkcREtN8VeFJx_3wKEOcACjVQmoaT5kRrbA@T0169KUsBU1BsArXJxvzCjVQmoaT5kRrbA"
	
	new_jdsgmh_set="$new_jdsgmh@$zuoyou_20190516_jdsgmh@$jidiyangguang_20190516_jdsgmh@$chiyu_jdsgmh@$Javon_20201224_jdsgmh@$xo_20201229_jdsgmh@$Jhone_Potte_20200824_jdsgmh@$jidiyangguang_20190516_jdsgmh@$chiyu_jdsgmh@$ashou_20210516_jdsgmh@$dreamer_20200524_jdsgmh"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	sgmhcode_rows=$(grep -n "inviteCodes = \[" $dir_file_js/jd_sgmh.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$sgmhcode_rows a \ '$new_jdsgmh_set', " $dir_file_js/jd_sgmh.js
		js_amount=$(($js_amount - 1))
	done

	#京东赚赚长期活动
	new_jdzz="AUWE5mKmQzGYKXGT8j38cwA@AUWE5mvvGzDFbAWTxjC0Ykw@AUWE5wPfRiVJ7SxKOuQY0@S5KkcJEZAjD2vYGGG4Ip0@S5KkcREsZ_QXWIx31wKJZcA@S5KkcRUwe81LRIR_3xaNedw@Suvp2RBcY_VHKKBn3k_MMdNw@SvPVyQRke_EnWJxj1nfE@S5KkcRBYbo1fXKUv2k_5ccQ@S5KkcRh0ZoVfQchP9wvQJdw@S5KkcJnlwogCDQ2G84qtI"
	zuoyou_20190516_jdzz="S4r90RQ@S9r43CBsZ@S5KkcR00boFzRKEvzlvYCcA@S47wgARoc@S4qQkFUBOsgG4fQ@S7KQtF1dc8lbX@S5rQ3EUBOtA2Ifk0@S5KkcR0scpgDUdBnxkaEPcg@S5KkcOUt-tA2xfVuXyo9R@S-akMAUNKozyMcl6e_L8@S5KkcRRtL_VeBckj1xaYNfA@S5KkcRB8d9FLRKU6nkPQOdw"
	jidiyangguang_20190516_jdzz="S5KkcRBpK8lbeIxr8wfRcdw@S5KkcR0wdpFCGcRvwxv4Jcg"
	chiyu_jdzz="S7aUqCVsc91U"
	ashou_20210516_jdzz="Sv_V1RRgf_VPSJhyb1A@Sa0DkmLenrwOA@S5KkcRRtN8wCBdUimlqVbJw@S5KkcRkoboVKEJRr3xvINdQ@S_aIzGEdFoAGJdw@S5KkcRhpI8VfXcR79wqVcIA@S5KkcRk1P8VTSdUmixvUIfQ@S-acrCh8Q_VE"
	
	new_jdzz_set="$new_jdzz@$zuoyou_20190516_jdzz@$jidiyangguang_20190516_jdzz@$chiyu_jdzz@$ashou_20210516_jdzz"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	jdzzcode_rows=$(grep -n "inviteCodes = \[" $dir_file_js/jd_jdzz.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$jdzzcode_rows a \ '$new_jdzz_set', " $dir_file_js/jd_jdzz.js
		js_amount=$(($js_amount - 1))
	done

	#健康社区
	new_health="T0225KkcRxoZ9AfVdB7wxvRcIQCjVfnoaW5kRrbA@T0225KkcRUhP9FCEKR79xaZYcgCjVfnoaW5kRrbA@T0205KkcH0RYsTOkY2iC8I10CjVfnoaW5kRrbA@T0205KkcJEZAjD2vYGGG4Ip0CjVfnoaW5kRrbA"
	test_health="T019vPVyQRke_EnWJxj1nfECjVfnoaW5kRrbA@T0225KkcRBYbo1fXKUv2k_5ccQCjVfnoaW5kRrbA@T0225KkcRh0ZoVfQchP9wvQJdwCjVfnoaW5kRrbA@T0205KkcPGhhswmWX2e03YBbCjVfnoaW5kRrbA@T0225KkcRBwdp1CEI0v8l_9ZdwCjVfnoaW5kRrbA"

	Javon_20201224_health="T023uvp2RBcY_VHKKBn3k_MMdNwCjVfnoaW5kRrbA"

	random_health="$test_health"
	random="$random_health"
	random_array
	new_health_set="$new_health@$Javon_20201224_health@$random_set"

	js_amount=$(cat $openwrt_script_config/js_cookie.txt | wc -l)
	healthcode_rows=$(grep -n "inviteCodes = \[" $dir_file_js/jd_health.js | awk -F ":" '{print $1}')
	while [[ ${js_amount} -gt 0 ]]; do
		sed -i "$healthcode_rows a \ '$new_health_set', " $dir_file_js/jd_health.js
		js_amount=$(($js_amount - 1))
	done
}

if [ ! `cat /tmp/github.txt` == "ITdesk01" ];then 
echo ""
#exit 0
fi

share_code_generate() {
	js_amount="10"
	while [[ ${js_amount} -gt 0 ]]; do
		share_code_value="$share_code_value&$share_code"
		js_amount=$(($js_amount - 1))
	done
}

close_notification() {
	#农场和东东萌宠关闭通知
	if [ `date +%A` == "Monday" ];then
		echo -e "$green今天周一不关闭农场萌宠通知$white"
		case `date +%H` in
		22|23|00|01)
			sed -i "s/notify.sendNotify/\/\/notify.sendNotify/g" $dir_file_js/jd_cash_exchange.js
		;;
		*)
			sed -i "s/\/\/notify.sendNotify/notify.sendNotify/g" $dir_file_js/jd_cash_exchange.js
		;;
		esac
	else
		case `date +%H` in
		22|23|00|01)
			if [ "$ccr_if" == "yes" ];then
				for i in `ls $ccr_js_file | grep -E "^js"`
				do
				{
					sed -i "s/jdNotify = true/jdNotify = false/g" $ccr_js_file/$i/jd_fruit.js
					sed -i "s/jdNotify = true/jdNotify = false/g" $ccr_js_file/$i/jd_pet.js
				}&
				done
				ps_fr=$(ps -ww | grep "jd_fruit.js" | grep -v grep | wc -l)
				ps_pet=$(ps -ww | grep "jd_pet.js" | grep -v grep | wc -l)
				while [ $ps_fr -gt 0 ] && [ $ps_pet -gt 0 ];do
					sleep 1
					ps_fr=$(ps -ww | grep "jd_fruit.js" | grep -v grep | wc -l)
					ps_pet=$(ps -ww | grep "jd_pet.js" | grep -v grep | wc -l)
				done
			fi

			sed -i "s/jdNotify = true/jdNotify = false/g" $dir_file_js/jd_fruit.js
			sed -i "s/jdNotify = true/jdNotify = false/g" $dir_file_js/jd_pet.js

			sed -i "s/notify.sendNotify/\/\/notify.sendNotify/g" $dir_file_js/jd_cash_exchange.js

			echo -e "$green暂时不关闭农场和萌宠通知$white"
		;;
		*)
			if [ "$ccr_if" == "yes" ];then
				for i in `ls $ccr_js_file | grep -E "^js"`
				do
				{
					sed -i "s/jdNotify = false/jdNotify = true/g" $ccr_js_file/$i/jd_fruit.js
					sed -i "s/jdNotify = false/jdNotify = true/g" $ccr_js_file/$i/jd_pet.js
				}&
				done

				ps_fr=$(ps -ww | grep "jd_fruit.js" | grep -v grep | wc -l)
				ps_pet=$(ps -ww | grep "jd_pet.js" | grep -v grep | wc -l)
				while [ $ps_fr -gt 0 ] && [ $ps_pet -gt 0 ];do
					sleep 1
					ps_fr=$(ps -ww | grep "jd_fruit.js" | grep -v grep | wc -l)
					ps_pet=$(ps -ww | grep "jd_pet.js" | grep -v grep | wc -l)
				done
			fi

			sed -i "s/jdNotify = false/jdNotify = true/g" $dir_file_js/jd_fruit.js
			sed -i "s/jdNotify = false/jdNotify = true/g" $dir_file_js/jd_pet.js

			sed -i "s/\/\/notify.sendNotify/notify.sendNotify/g" $dir_file_js/jd_cash_exchange.js
			echo -e "$green时间大于凌晨一点开始关闭农场和萌宠通知$white"
		;;
		esac
	fi
}
random_array() {
	#彻底完善，感谢minty大力支援
	length=$(echo $random | awk -F '[@]' '{print NF}') #获取变量长度
	quantity_num=$(expr $length + 1)

	if [ "$length" -ge "20" ];then
		echo "random_array" > /tmp/random.txt
		random_num=$(python3 $dir_file/jd_random.py $quantity_num,$length  | sed "s/,/\n/g")
		for i in `echo $random_num`
		do
			echo $random | awk -va=$i -F '[@]' '{print $a}'  >>/tmp/random.txt
		done

		random_set=$(cat /tmp/random.txt | sed  "/random_array/d"| sed "s/$/@/" | sed ':t;N;s/\n//;b t' |sed 's/.$//g')
	else
		random_set="$random"
	fi
}

time() {
	if [ $script_read == "0" ];then
		echo ""
		echo -e  "$green你是第一次使用脚本，请好好阅读以上脚本说明$white"
		echo ""
		seconds_left=120
		while [[ ${seconds_left} -gt 0 ]]; do
			echo -ne "$green${seconds_left}秒以后才能正常使用脚本，不要想结束我。我无处不在。。。$white"
			sleep 1
			seconds_left=$(($seconds_left - 1))
			echo -ne "\r"
		done
		echo -e "$green恭喜你阅读完成，祝玩的愉快，我也不想搞这波，但太多小白不愿意看说明然后一大堆问题，请你也体谅一下$white"
		echo "我已经阅读脚本说明" > $dir_file/script_read.txt
		exit 0
	fi
}

npm_install() {
	echo -e "$green 开始安装npm模块$white"
	#安装js模块
	cp $dir_file/git_clone/lxk0301_back/package.json $openwrt_script/package.json
	cd $openwrt_script && npm -g install
	npm install -g request http stream zlib vm png-js fs got tough-cookie audit date-fns ts-md5 md5 jsdom
	npm install --save axios
	cd $dir_file/cookies_web && npm -g install

	#安装python模块
	python_install
	echo ""
}

python_install() {
	echo -e "$green 开始安装python模块$white"
	python3 $dir_file/get-pip.py
	pip3 install requests rsa
	echo -e "$green命令执行完成，如果一直报错我建议你重置系统或者重新编译重新刷$white"
}

system_variable() {

	if [[ ! -d "$dir_file/config/tmp" ]]; then
		mkdir -p $dir_file/config/tmp
	fi
	
	if [[ ! -d "$dir_file/js" ]]; then
		mkdir  $dir_file/js
	fi

	if [[ ! -d "/tmp/jd_tmp" ]]; then
		mkdir  /tmp/jd_tmp
	fi

	#判断参数
	if [ ! -f /root/.ssh/test1 ];then
		rm -rf /root/.ssh
		cp -r $dir_file/.ssh /root/.ssh
		chmod 600 /root/.ssh/lxk0301
		sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g" /etc/ssh/ssh_config
		echo > /root/.ssh/test1
		update
	fi

	if [ "$dir_file" == "$openwrt_script/JD_Script" ];then
		#jdCookie.js
		if [ ! -f "$openwrt_script_config/jdCookie.js" ]; then
			cp  $dir_file/JSON/jdCookie.js  $openwrt_script_config/jdCookie.js
			rm -rf $dir_file_js/jdCookie.js #用于删除旧的链接
			ln -s $openwrt_script_config/jdCookie.js $dir_file_js/jdCookie.js
		fi

		#jdCookie.js用于升级以后恢复链接
		if [ ! -L "$dir_file_js/jdCookie.js" ]; then
			rm -rf $dir_file_js/jdCookie.js
			ln -s $openwrt_script_config/jdCookie.js $dir_file_js/jdCookie.js
		fi

		#sendNotify.js
		if [ ! -f "$openwrt_script_config/sendNotify.js" ]; then
			cp  $dir_file/JSON/sendNotify.js $openwrt_script_config/sendNotify.js
			rm -rf $dir_file_js/sendNotify.js  #用于删除旧的链接
			ln -s $openwrt_script_config/sendNotify.js $dir_file_js/sendNotify.js
		fi

		#sendNotify.js用于升级以后恢复链接
		if [ ! -L "$dir_file_js/sendNotify.js" ]; then
			rm -rf $dir_file_js/sendNotify.js  #临时删除，解决最近不推送问题
			ln -s $openwrt_script_config/sendNotify.js $dir_file_js/sendNotify.js
		fi

		#USER_AGENTS.js
		if [ ! -f "$openwrt_script_config/USER_AGENTS.js" ]; then
			cp  $dir_file/git_clone/lxk0301_back/USER_AGENTS.js $openwrt_script_config/USER_AGENTS.js
			rm -rf $dir_file_js/USER_AGENTS.js #用于删除旧的链接
			ln -s $openwrt_script_config/USER_AGENTS.js $dir_file_js/USER_AGENTS.js
		fi

		#USER_AGENTS.js用于升级以后恢复链接
		if [ ! -L "$dir_file_js/USER_AGENTS.js" ]; then
			rm -rf $dir_file_js/USER_AGENTS.js
			ln -s $openwrt_script_config/USER_AGENTS.js $dir_file_js/USER_AGENTS.js
		fi

		#JS_USER_AGENTS.js
		if [ ! -f "$openwrt_script_config/JS_USER_AGENTS.js" ]; then
			cp  $dir_file/git_clone/lxk0301_back/JS_USER_AGENTS.js $openwrt_script_config/JS_USER_AGENTS.js
			rm -rf $dir_file_js/JS_USER_AGENTS.js #用于删除旧的链接
			ln -s $openwrt_script_config/JS_USER_AGENTS.js $dir_file_js/JS_USER_AGENTS.js
		fi

		#JS_USER_AGENTS.js用于升级以后恢复链接
		if [ ! -L "$dir_file_js/JS_USER_AGENTS.js" ]; then
			rm -rf $dir_file_js/JS_USER_AGENTS.js
			ln -s $openwrt_script_config/JS_USER_AGENTS.js $dir_file_js/JS_USER_AGENTS.js
		fi
	fi

	jd_openwrt_config_version="1.4"
	if [ "$dir_file" == "$openwrt_script/JD_Script" ];then
		jd_openwrt_config="$openwrt_script_config/jd_openwrt_script_config.txt"
		if [ ! -f "$jd_openwrt_config" ]; then
			jd_openwrt_config_description
		fi
		#jd_openwrt_script_config用于升级以后恢复链接
		if [ ! -L "$dir_file/config/jd_openwrt_script_config.txt" ]; then
			rm rf $dir_file/config/jd_openwrt_script_config.txt
			ln -s $jd_openwrt_config $dir_file/config/jd_openwrt_script_config.txt
		fi
	fi

	if [ `grep "jd_openwrt_config $jd_openwrt_config_version" $jd_openwrt_config |wc -l` == "1"  ];then
		jd_config_version="$green jd_config最新 $yellow$jd_openwrt_config$white"
	else
		jd_config_version="$red jd_config与新版不一致，请手动更新，更新办法，删除$green rm -rf $jd_openwrt_config$white然后更新一下脚本,再进去重新设置一下"
	fi

	ccr_if=$(grep "concurrent" $jd_openwrt_config | awk -F "'" '{print $2}')
	jd_fruit=$(grep "jd_fruit" $jd_openwrt_config | awk -F "'" '{print $2}')
	jd_joy_reward=$(grep "jd_joy_reward" $jd_openwrt_config | awk -F "'" '{print $2}')
	jd_joy_feedPets=$(grep "jd_joy_feedPets" $jd_openwrt_config | awk -F "'" '{print $2}')
	jd_joy_steal=$(grep "jd_joy_steal" $jd_openwrt_config | awk -F "'" '{print $2}')
	jd_unsubscribe=$(grep "jd_unsubscribe" $jd_openwrt_config | awk -F "'" '{print $2}')
	push_if=$(grep "push_if" $jd_openwrt_config | awk -F "'" '{print $2}')
	weixin2=$(grep "weixin2" $jd_openwrt_config | awk -F "'" '{print $2}')

	#添加系统变量
	jd_script_path=$(cat /etc/profile | grep -o jd.sh | wc -l)
	if [[ "$jd_script_path" == "0" ]]; then
		echo "export jd_file=$dir_file" >> /etc/profile
		echo "export jd=$dir_file/jd.sh" >> /etc/profile
		source /etc/profile
	fi


	cd $dir_file
	if_git=$(git remote -v | grep -o "https:\/\/github.com\/ITdesk01\/JD_Script.git" | wc -l)
	if [ "$if_git" == "2" ];then
		echo ""
	else
		echo ""
		#echo -e "$red检测到你的JD_Script的github地址错误，停止为你服务，省的老问我，为什么你更新了以后，没有我说的脚本,你用的都不是我的，怎么可能跟上我的更新！！！$white"
		#echo -e "$green唯一的github地址：https://github.com/ITdesk01/JD_Script.git$white"
		#exit 0
	fi
	if [ "$ccr_if" == "yes" ];then
		if [[ ! -d "$ccr_js_file" ]]; then
			mkdir  $ccr_js_file
		fi
	else
		if [[ ! -d "$ccr_js_file" ]]; then
			echo ""
		else
			rm -rf $ccr_js_file
		fi
	fi

	index_js

	#农场萌宠关闭通知
	close_notification

	script_black
}

index_js() {
#后台默认运行index.js
	openwrt_ip=$(ubus call network.interface.lan status | grep address  | grep -oE '([0-9]{1,3}.){3}[0-9]{1,3}')
	index_if=$(ps -ww | grep "index.js" | grep -v grep | wc -l)
	if [ $index_if == "1" ];then
		index_num="$yellow 8.网页扫码功能已启动，网页输入$green$openwrt_ip:6789$white$yellow,就可以访问了$white"
	else
		echo -e "$green启动网页扫码功能$white"
		node $dir_file/cookies_web/index.js &
		if [ $? -eq 0 ]; then
			index_num="$yellow 8.网页扫码功能已启动，网页输入$green$openwrt_ip:6789$white$yellow,就可以访问了$white"
		else
			index_num="$yellow 8.网页扫码功能启动失败，请手动执行看下问题　node $dir_file/cookies_web/index.js$white"
		fi
	fi
}

kill_index() {
	index_if=$(ps -ww | grep "index.js" | grep -v grep | awk '{print $1}')
	for i in `echo $index_if`
	do
		echo "终止网页扫码功能，重新执行sh \$jd 就可以恢复"
		kill -9 $i
	done
}


ss_if() {
	echo -e "$green开启检测github是否联通，请稍等。。$white"
	wget https://raw.githubusercontent.com/ITdesk01/JD_Script/master/README.md -O /tmp/test_README.md
	if [[ $? -eq 0 ]]; then
		echo "github正常访问，不做任何操作"
	else
		ss_pid=$(ps -ww | grep "ssrplus" | grep -v grep | awk '{print $1}')
		if [ $ss_pid == "2" ];then
			echo "后台有ss进程，不做处理"
		else
			echo "无法ping通Github,重新加载ss进程"
			/etc/init.d/shadowsocksr stop
			/etc/init.d/shadowsocksr start
			echo "重启进程完成"
			wget https://raw.githubusercontent.com/ITdesk01/JD_Script/master/README.md -O /tmp/test_README.md
			if [[ $? -eq 0 ]]; then
				echo -e "$green github正常访问，不做任何操作$white"
			else
				echo -e "$red依旧无法访问github,请检查网络问题$white"
			fi
		fi
	fi
}


jd_openwrt_config_description() {
cat > $jd_openwrt_config <<EOF
*****************jd_openwrt_config $jd_openwrt_config_version**************

这里主要定义一些脚本的个性化操作，如果你不需要微调，那么保持默认不理他就行了

这里的参数如果你看不懂或者想知道还有没有其他参数，你可以去$dir_file_js这里找相应的js脚本看说明

修改完参数如何生效：sh \$jd update && sh \$jd

*******************************************************
#是否启用账号并发功能（多账号考虑打开，黑了不管） yes开启 默认no
concurrent='no'

#推送方式
0.server酱和微信同时推送   1.server酱推送     2.微信推送
3.将shell模块检测推送到另外一个小程序上（举个例子，一个企业号，两个小程序，小程序1填到sendNotify.js,这样子js就会推送到哪里，小程序2填写到jd_openwrt_config这样jd.sh写的模块就会推送到小程序2）

push_if='1'

(push_if填写为3，这里就必须要填，不然无法推送，不为3,可以不填)
weixin2=''

------------------------------------------------------------------------------------------------------------
#京东试用 true开启  默认false(更多详细内容请查看/usr/share/jd_openwrt_script/JD_Script/js/jd_try.js)
JD_TRY="false"

#jd_try ck变量(那几个ck要跑，用@隔开，比如jd_01@jd_02(填写ck的用户名也就是pt_pin值)，这里不填就跑所有ck)
jd_try_ck=""

#jd_try黑名单
export JD_TRY_TITLEFILTERS="考题@试卷@短筒靴@双面胶@沉香@香薰@充电宝@网红零食礼盒@网红@矿泉水@热身膏@按摩膏@芝士片@莆田@男鞋@精粹水@娇兰@帝皇峰@古龙香水@保暖护膝@小凳子@真皮笔袋@牛皮笔袋@触控手写@电容笔@SD卡@电池iPhone@摄像头@康复训练器@单肩包@防火毯@应急逃生衣@硒鼓@休闲零食@电动割草机@除草剂@膝盖贴@艾灸@茶叶@青梅酒@食用油@话筒@燃油宝@燃油添加剂@洗衣液@汽车应急启动电源@背景板@摆件@创意礼盒@烧水壶@果酒@注射器@浴巾@靴子@警告牌@被芯@手电筒@潮牌@土工布@安美琪@爽肤水@健身轮@懒人鞋@抛光@文玩@包浆@机油@户外鞋@白葡萄酒@宝珠笔@签字笔@台秤@麻将机@卡片@钱码@贵州名酒@葡萄酒@四件套@平底锅@休闲潮鞋@地图@茅台镇@贵州茅台镇@养殖围栏@平光@蜡油@花架子@水龙头@沐浴露@止痒@洗衣凝珠@记事本@灯泡@休闲鞋@运动鞋@女靴@男装@修复贴@冻干@保密袋@手机屏蔽袋@拖把池@冻干粉@修颜@牛仔裤@苏打水@代餐@精华@洗发露@鸡毛掸@拖把@咖啡豆@精油@维生素@降血压@活络油@隔离网@养生茶@减肥@喷雾@正骨@枕头@925@PVC@qq名片@按摩霜@奥咖蚕精参肽片压片@白富美@白玉@棒@棒球帽@包皮@孢子@保护膜@保护套@保健@保湿乳@杯@鼻@鼻炎@壁纸@避孕@便携装@饼干@玻尿酸@不限速@不锈钢@补钙@补水@布鞋@擦杯布@产后修复@尝鲜@长袖@超薄@超长@车载充电器@成功学@虫@宠物@除臭@床垫@春节@纯棉@瓷砖@打底裤@大米@单肩包女@淡化@蛋糕@档案袋@电话@电脑椅@电商@吊带@吊坠@钓鱼@定情@抖音@抖音作品@痘印@端午节@短裤@俄语@儿童@儿童牛奶@耳钉@耳环@耳坠@防臭地漏@防晒霜@翡翠@粉底@风湿@辅导@妇女@钙片@肛门@钢化@钢化膜@钢圈@高跟鞋@高血压@隔离带@宫颈@狗@股票@挂画@挂件@冠心病@罐@国庆节@果树@和田白玉@和田玉@黑丝@狐臭@互动课@护眼仪@花洒@化妆爽肤水@化妆水@活动@激素@甲醛@尖锐@监控补光灯@僵尸粉@降敏@教程@脚气@洁面乳@睫毛@睫毛胶水@解酒@戒烟@戒指@界家居@金刚石@精华@精华水@精华液@镜片@咀嚼片@卷尺@开发@看房@看房游@抗皱@克尤@刻字@课@口@口臭咀嚼片@口腔@口罩@快手@垃圾@垃圾桶@懒人支架@老太太@类纸膜@灵芝@领带@流量@流量卡@六级@旅游@玛瑙@猫@帽@眉@美白@美容仪@美少女@门把手@门票@糜烂@棉签@面膜@面霜@膜@墨水@奶粉@男用喷剂@内裤@尿不湿@女纯棉@女孩@女内裤@女内衣@女士上衣@女鞋@女性内裤@女性内衣@女友@女装@泡沫@疱疹@培训@盆栽@皮带@皮带扣@皮鞋@屏风底座@菩提@旗袍@亲子@轻奢@情人节@祛斑@祛痘@驱蚊@去黑头@染色@日租@肉苁蓉@乳霜@软件@腮红@三角短裤@三角裤@杀@少妇@少女@少女内衣@伸缩带@生殖器@施华洛世奇@湿疣@实战@手表@手抄报@手环@手机壳@手机膜@手机套@手机支架@手链@手套@手镯@树脂@刷头@水管@水晶@睡袍@睡衣@四级@四角短裤@四六级@素@随身wifi@损伤膏@太阳能@糖果@糖尿病@题库@体验装@贴膜@贴纸@铁@通话@童鞋@童装@褪黑素@娃娃@袜@袜子@袜子一双@外套@网课@网络@网络课程@网校@卫生巾@卫生条@卫衣@文胸@卧室灯@西服@西装@洗面@系统@癣@项链@小白鞋@小红书@小靓美@小胸@鞋拔@卸妆@卸妆水@心动@性感@胸部按摩@胸罩@休闲裤@Ｔ恤@玄关画@鸭舌帽@牙刷头@延时湿巾@演唱会@眼@眼镜@眼影@洋娃娃@羊脂白玉@羊脂玉@腰带@药@一次性@一米线栏杆@医用@衣架@姨妈巾@益生菌@益智@阴道@阴道炎@银@印度神油@婴儿@英语@疣@幼儿@鱼@鱼饵@羽绒服@语@玉@玉石@孕妇@在线@在线网络@在线直播@早餐奶@蟑螂@照明@遮斑@遮痘@遮瑕@职称@纸尿裤@中年@中秋节@中小学@种子@咨询@滋润@钻@钻石@坐垫"

#jd_try试用白名单
JD_TRY_WHITELIST="耳机@键盘"

#jd_try最小提供数量
JD_TRY_PRICE="119"
JD_TRY_PLOG="true"
JD_TRY_MINSUPPLYNUM="0"
JD_TRY_TABID="1@2@3@4@5@6@7@8@9@10@11@12@13@14@15@16"
JD_TRY_MAXLENGTH="200"
JD_TRY_APPLYNUMFILTER="10000"
JD_TRY_TRIALPRICE="10"

#这里的变量都可以自己修改，按自己的想法来
------------------------------------------------------------------------------------------------------------


#农场不浇水换豆 false关闭 true打开
jd_fruit='false'

#宠汪汪积分兑换500豆子，(350积分兑换20豆子，8000积分兑换500豆子要求等级16级，16000积分兑换1000京豆16级以后不能兑换)
jd_joy_reward='500'


#宠汪汪喂食(更多参数自己去看js脚本描述)
jd_joy_feedPets='80'


#宠汪汪不给好友喂食 false不喂食 true喂食
jd_joy_steal='false'

#取消店铺200个(觉得太多你可以自己调整)
jd_unsubscribe='200'
EOF
}

system_variable
action1="$1"
action2="$2"
if [[ -z $action1 ]]; then
	help
else
	case "$action1" in
		run_0|run_01|run_06_18|run_10_15_20|run_02|run_03|opencard|run_08_12_16|run_07|run_030|run_020)
		concurrent_js_if
		;;
		system_variable|update|update_script|task|jx|additional_settings|jd_sharecode|ds_setup|checklog|that_day|stop_script|script_black|script_name|backnas|npm_install|checktool|concurrent_js_clean|if_ps|getcookie|addcookie|delcookie|check_cookie_push|python_install|concurrent_js_update|kill_index|run_jd_cash|run_jd_blueCoin|run_jd_joy_reward|del_expired_cookie|jd_try|ss_if)
		$action1
		;;
		kill_ccr)
			action="run_"
			kill_ccr
		;;
		*)
		help
		;;
	esac

	if [[ -z $action2 ]]; then
		echo ""
	else
		case "$action2" in
		run_0|run_01|run_06_18|run_10_15_20|run_02|run_03|opencard|run_08_12_16|run_07|run_030|run_020)
		concurrent_js_if
		;;
		system_variable|update|update_script|task|jx|additional_settings|jd_sharecode|ds_setup|checklog|that_day|stop_script|script_black|script_name|backnas|npm_install|checktool|concurrent_js_clean|if_ps|getcookie|addcookie|delcookie|check_cookie_push|python_install|concurrent_js_update|kill_index|run_jd_cash|run_jd_blueCoin|run_jd_joy_reward|del_expired_cookie|jd_try|ss_if)
		$action2
		;;
		kill_ccr)
			action="run_"
			kill_ccr
		;;
		*)
		help
		;;
	esac
	fi
fi
