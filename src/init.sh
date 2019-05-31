#!/bin/bash


#加载配置和函数文件
. $CURRENT_DIR/src/setting.sh
. $CURRENT_DIR/src/fun.sh

ALL_MODS=`ls $SOURCE_MOD_PATH|tr "\n" " "`
ALL_COMS=`ls $SOURCE_COM_PATH|tr "\n" " "`
		
#帮助文件
if [ "$CURRENT_MODE" = "h" ]; then
    echo "AutoSetup  For CentOS 7"
    echo "作者: King 邮箱：tinycn@qq.com"
    echo "-h    可阅读详细帮助"
    echo "-c       可直接安装组件!"
    echo  "可安装组件:$ALL_COMS"
    echo  "-m    可直接安装模块"
    echo  "可安装模块: $ALL_MODS "
    exit;
fi

if [ "$IS_QUIET" = '0' ];then

    #检查是否以root身份运行脚本
    if [ $(id -u) != "0" ]; then
	    error  "必须以root身份运行该安装脚本!"
    fi

    #检查Linux版本
    if [ `cat /etc/centos-release|grep -i centos|wc -l` -eq "0" ];then
	    error "必须运行在CentOS系统下面!"	
    fi

    #设置时区
    rm -f /etc/localtime
    cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


    #关闭selinux
    if [ -s /etc/selinux/config ]; then
	    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    fi

    #加载基础库
    if [ ! -f /etc/ld.so.conf.d/auto_setup.conf ];then
    cat >> /etc/ld.so.conf.d/auto_setup.conf <<EOT
/usr/local/lib
/usr/local/lib64
EOT
    ldconfig -v
    fi

    #优化网络参数
    grep "^#Sys Options$" /etc/sysctl.conf >/dev/null
    if [ $? != 0 ]; then

        cat >>/etc/sysctl.conf<<EOF
#Sys Options
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 8192 4336600 873200
net.ipv4.tcp_rmem = 32768 4336600 873200
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.ip_local_port_range = 1024 65000
vm.zone_reclaim_mode = 1
EOF
        sysctl -p >>/dev/null 2>&1
    fi


    #优化文件描述符
    grep "^#Sys Options$" /etc/security/limits.conf >/dev/null
    if [ $? != 0 ]; then

        cat >>/etc/security/limits.conf<<EOF
#Sys Options
*               soft     nproc         65536
*               hard     nproc         65536

*               soft     nofile         102400
*               hard     nofile         102400
EOF

    fi
    ulimit -n 102400


#添加用户
user_add www www

#创建data文件夹
create_dir $DATA_DIR $DATA_BAK_DIR

#需要备份的data文件夹路径
create_dir $DATA_BAK_DIR $DATA_WEB_DIR $DATA_DB_DIR $DATA_SCRIPT_DIR $DATA_CONF_DIR

#安装必须的包
yum_install gd-devel flex bison file libtool libtool-libs autoconf ntp ntpdate net-snmp-devel  readline-devel net-snmp net-snmp-utils psmisc net-tools iptraf ncurses-devel  iptraf wget curl patch make gcc gcc-c++  kernel-devel unzip zip pigz
yum_install pcre-devel openssl-devel
#同步时间
ntpdate cn.pool.ntp.org
hwclock --systohc

fi