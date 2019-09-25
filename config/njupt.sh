#!/bin/sh

# 输入格式：登录类型(in、out)，运营商(ctcc-电信、cmcc-移动、cucc-联通、njupt-校园网)，账号，密码

# 登录类型
logintype=$1

# 运营商
isp=$2

# 账号
name=$3

# 密码
pwd=$4

# 登录IP
logip=

# 运营商标识
loginisp=

# 执行登录操作
if [ "$logintype" = "in"  ]
then
	printf "执行登录操作！\n\n"
	
	# 获取运营商标识
	# 移动
	if [ "$isp" = "cmcc" ] 
	then
		loginisp=%40cmcc
		printf "当前是移动网！\n\n"
	# 电信
	elif [ "$isp" = "ctcc" ]
	then
		loginisp=%40njxy
		printf "当前是电信网！\n\n"
	# 校园网
	elif [ "$isp" = "njupt" ] 
	then
		printf "当前是校园网！\n\n"
	else
		printf "运营商错误！\n\n"
		exit 0
	fi
	
	##########################################
	
    # 获取动态IP
	# 有线端口
	netip=$(ifconfig eth2.2 | grep inet | awk '{print $2}' | tr -d "addr:")
	printf "有线-IP=${netip}\n\n"
	
	# 2.4G中继
	twoip=$(ifconfig apcli0 | grep inet | awk '{print $2}' | tr -d "addr:")
	printf "2.4G中继-IP=${twoip}\n\n"
	
	# 5G中继
	fiveip=$(ifconfig apclii0 | grep inet | awk '{print $2}' | tr -d "addr:")
	printf "5G中继-IP=${fiveip}\n\n"
	
	# MAC无线端口
	macip=$(ifconfig en0 | grep "inet " | awk '{print $2}' | grep '10.')
	printf "MAC-IP=${macip}\n\n"
	
	##########################################
	
	# 如果netip不为空
	if [ ${netip} ]
	then
		loginip=${netip}
		printf "当前loginip=有线-IP=${netip}\n\n"
	elif [ ${twoip} ] 
	then
		loginip=${twoip}
		printf "当前loginip=2.4G中继-IP=${twoip}\n\n"
	elif [ ${fiveip} ] 
	then
		loginip=${fiveip}
		printf "当前loginip=5G中继-IP=${fiveip}\n\n"
	elif [ ${macip} ] 
	then
		loginip=${macip}
		printf "当前loginip=MAC-IP=${macip}\n\n"
	else
		printf "获取IP错误！\n\n"
		exit 0
	fi
	
	##########################################

	# 账号不为空
	if [ ${name} ]
	then
		loginname="%2C0%2C"${name}${loginisp}
		echo "账号为：$loginname"
		echo ""
	else
		printf "账号为空！\n\n"
		exit 0
	fi
	
	##########################################
	
	# 密码不为空
	if [ ${pwd} ]
	then
		loginpwd=${pwd}
		echo "密码为：$loginpwd"
		echo ""
	else
		printf "密码为空！\n\n"
		exit 0
	fi
	
	##########################################
	
	# 登录操作
	curl "http://p.njupt.edu.cn:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=p.njupt.edu.cn&iTermType=1&wlanlogip=${loginip}&wlanacip=null&wlanacname=XL_ME60&mac=00-00-00-00-00-00&ip=${loginip}&enAdvert=0&queryACIP=0&loginMethod=1" --data "DDDDD=${loginname}&upass=${loginpwd}&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=&v6ip="
	
# 执行退出操作
elif [ "$logintype" = "out" ] 
then
	printf "执行退出操作！\n\n"
	
	# 退出操作
	curl "http://p.njupt.edu.cn:801/eportal/?c=ACSetting&a=Logout"
# 什么都不做
else
	printf "参数错误！\n\n"
	exit 0
fi