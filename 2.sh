#!/bin/sh
#
git clone https://github.com/ITdesk01/JD_Script.git JDScript
git clone https://github.com/firkerword/JD_Script.git
cd JDScript
cp -r `ls /home/JDScript | grep -v ccc | xargs` /home/JD_Script
cd ..
	#京东农场
        new_fruit="0763443f7d6f4f5ea5e54adc1c6112ed@e61135aa1963447fa136f293a9d161c1@f9e6a916ad634475b8e77a7704b5c3d8@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/6632c8135/$new_fruit&/" JD_Script/jd.sh

	#萌宠
        new_pet="MTE1NDUyMjEwMDAwMDAwNDI4ODA5NDU=@MTE1NDQ5OTUwMDAwMDAwNDI4ODA5NTE=@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/MTE1NDAxN/$new_pet&/" JD_Script/jd.sh

	#种豆
        new_plantBean="nuvfqviuwvnigxx65s7s77gbbvd4thrll7o63pq@fn5sjpg5zdejnypipngfhaudisqrfccakjuyaty@e7lhibzb3zek2xhmmypkf6ratimjeenqwvqvwjq@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/4npkonns/$new_plantBean&/" JD_Script/jd.sh

	#京喜工厂
        new_dreamFactory="X2poJVLcLoygZX0TgGmkl8EiBIkQe_zrMAZqtgL24-M=@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/4HL35B/$new_dreamFactory&/" JD_Script/jd.sh

	#东东工厂
        new_jdfactory="T024anXulbWUI_NR9ZpeTHmEoPlACjVWnYaS5kRrbA@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/P04z54XCjVWnYaS5m9cZ2f83X0Zl/$new_jdfactory&/" JD_Script/jd.sh

	#京东赚赚长期活动
        new_jdzz="95OquUc_sFugJO5_E_2dAgm-@eU9YELv7P4thhw6utCVw@eU9YaOjnbvx1-Djdz3UUgw@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/AUWE5mKm/$new_jdzz&/" JD_Script/jd.sh

	#crazyJoy任务
        new_crazyJoy="2wgkflmSL-eOLT3n1sPRIKGLdMmSR-i1@uahlHElOqVadmIuLt6yoeg==@wVO5hjOkRcsuqL_wHuhERqt9zd5YaBeE@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/rHYmFm9wQ/$new_crazyJoy&/" JD_Script/jd.sh

	#口袋书店
        new_jdbook="互助码填写位置@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/d6d73edddaa64cbd/$new_jdbook&/" JD_Script/jd.sh

	#京喜农场
        new_jxnc="互助码填写位置@"
        #互助码填写格式：@+互助码    例如：@sd452a41ds2af1a1
        sed -i "s/019cffd91086/$new_jxnc&/" JD_Script/jd.sh

