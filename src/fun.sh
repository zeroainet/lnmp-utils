#!/bin/bash

#输出日志
outlog(){
	local _d=`date +"%Y-%m-%d %H:%M:%S"`
	echo -e "$_d $1">> $DATA_LOG_FILE
}

#错误退出
error(){
        echo -e "Error: \033[0;31;1m$1\033[0m";
	outlog "Error: $1"
        exit 1;
}

#添加用户
useradd(){
	local _g=$1
	local _u=$2

	if [ "$_g" = "" ];then
		return;
	fi

	if [ "$_u" = "" ];then
		_u=$_g;
	fi
	if [ `cat /etc/group|grep "^$_g:"|wc -l` -eq "0" ];then
		groupadd $_g
	fi
        if [ `cat /etc/passwd|grep "^$_u:"|wc -l` -eq "0" ];then
                useradd -g $_g  $_u
        fi

}

#生成目录
createdir(){
        local _p;
	if [ "$1" = "" ];then
		return;
	fi
        for _p in $@;
        do	
        	if [ -d "$_p" ];then
			continue;
		fi
		mkdir -p -m 777 $_p;
        done
}

#安装yum package
yuminstall(){

if [ "$IS_QUIET" = '0' ];then
	local _i="";
	local _wpn="";
        for _i in $@;
        do
		_wpn=`yum list installed|grep $_i|wc -l`
                if [ "$_wpn" -gt "0" ];then
                	continue;
		else
			yum -y install $_i;
        	fi 
        done
fi
}

#根据端口删除进程

killport (){
        if [ ! "$1" ];then
                return;
        fi
        local _pn= `netstat -anp|grep ":$1\s"|awk '{print $7}'|awk -F'/' '{print $2}'|awk -F':' '{print $1}'`
        if [ "$_PN" != "" ];then
                killall -9 $_pn
        fi
}
#必须组件
require(){
        local _cd=$INSTALL_DIR"$1"
        if [ ! -d $_cd ];then
                com_install "$1";
        fi
}

#安装
install(){
        if [ "$CURRENT_MODE" = "c" ];then
                com_install "$1"
        elif [ "$CURRENT_MODE" = "m" ];then
                mod_install "$1"
        fi
}


#初始化组件临时文件
com_tmp_init(){
        if [ "$TMP_COM_DIR" != "" ];then
                if [ ! -d $TMP_COM_DIR ];then
                        createdir $TMP_COM_DIR
                else
                        chmod -R 777 $TMP_COM_DIR
                fi
                rm -rf  $TMP_COM_DIR"*"
        fi
}



#安装组件
com_install(){

        local _com;
        for _com in $1;
        do      
                
                COM_NAME=$_com
                COM_DIR="$SOURCE_MODULE_DIR$_com/"
                COM_PACKAGE_DIR="${COM_DIR}package/"
                COM_SOURCE_FILE=""
                COM_CONF_DIR="${COM_DIR}conf/"
                COM_INSTALL_SCRIPT="${COM_DIR}install.sh"
                COM_INSTALL_DIR="${INSTALL_DIR}$_com/"
                COM_DATA_CONF_DIR="${DATA_CONF_DIR}$_com/"
                COM_DATA_DB_DIR="${DATA_DB_DIR}$_com/"
                COM_DATA_PID_DIR="${DATA_PID_DIR}$_com/"
                COM_DATA_SCRIPT_DIR="${DATA_SCRIPT_DIR}$_com/"
                COM_DATA_LOG_DIR="${DATA_LOG_DIR}$_com/"
                COM_DATA_CACHE_DIR="${DATA_CACHE_DIR}$_com/"
                if [ ! -d $COM_DIR ];then
                        error "组件${_com}安装失败,目录${COM_DIR}不存在!"
                fi
                
                if [ ! -f $COM_INSTALL_FILE ]; then
                        error "组件${_com}安装失败,${COM_INSTALL_FILE}不存在!"
                fi
                
                com_tmp_init
 
          	echo "安装组件包：${_com}开始";                        
          	cd $CURRENT_DIR
                . $COM_INSTALL_SCRIPT
                echo "安装组件包：${_com}结束";
                sleep 2  
                
                
                COM_NAME=$_com
                COM_DIR=""
		COM_PACKAGE_DIR=""
		COM_SOURCE_FILE=""
		COM_CONF_DIR="" 
		COM_INSTALL_SCRIPT=""
		COM_INSTALL_DIR=""
                COM_DATA_CONF_DIR=""
                COM_DATA_DB_DIR=""
                COM_DATA_PID_DIR=""
                COM_DATA_SCRIPT_DIR=""		
                COM_DATA_LOG_DIR=""
                COM_DATA_CACHE_DIR=""
        done
        
        com_tmp_init
        
}

#解压组件的tar文件
com_untar(){
        tar zxvf $1 -C $TMP_COM_DIR >/dev/null
}

#解压组件的zip文件
com_unzip() {
        unzip  -u $1  -d $TMP_COM_DIR>/dev/null
}
com_unbz2(){
        tar jxvf $1 -C $TMP_COM_DIR >/dev/null
}


com_init(){
        COM_SOURCE_FILE="${COM_PACKAGE_DIR}$1"
        if [ -d $COM_INSTALL_DIR ]; then
                printf "已经安装了$COM_NAME ,开始删除!"
               # rm -rf $COM_INSTALL_DIR
        fi
        if [ ! -f $COM_SOURCE_FILE ]; then
                error "$COM_NAME安装失败, $COM_SOURCE_FILE不存在!"
        fi
}


#初始化模块临时文件
mod_tmp_init(){
        if [ "$TMP_MOD_DIR" != "" ];then
                if [ ! -d $TMP_MOD_DIR ];then
                        createdir $TMP_MOD_DIR
                else
                        chmod -R 777 $TMP_MOD_DIR
                fi
                rm -rf  $TMP_MOD_DIR"*"
        fi
}

#安装模块
mod_install(){
        local _mod;
        for _mod in $1;
        do
                MOD_DIR="${SOURCE_MODULE_DIR}$_mod/"
                MOD_NAME=$_mod
                MOD_PACKAGE_DIR="${MOD_DIR}package/"
                MOD_CONF_DIR="${MOD_DIR}conf/"
                MOD_INSTALL_SCRIPT="${SOURCE_MODULE_DIR}$_mod/install.sh"

                if [ ! -d $MOD_DIR ];then
                        error "模块${_mod}安装失败,目录${MOD_DIR}不存在!"
                fi
                
                if [ ! -f $MOD_INSTALL_FILE ]; then
                        error "模块${_mod}安装失败,${MOD_INSTALL_FILE}不存在!"
                fi
                
                mod_tmp_init
                
                echo "安装模块：${_mod}开始";                        
                cd $CURRENT_DIR
                . $MOD_INSTALL_SCRIPT
                echo "安装模块：${_mod}结束";
                sleep 2

                MOD_DIR=""
                MOD_NAME=""
                MOD_PACKAGE_DIR=""
                MOD_CONF_DIR=""  
                MOD_INSTALL_SCRIPT=""            
        done
        mod_tmp_init
}


#解压组件的tar文件
mod_untar(){
        tar zxvf $1 -C $TMP_MOD_DIR >/dev/null
}

#解压组件的zip文件
mod_unzip() {
        unzip -f $1 -d $TMP_MOD_DIR >/dev/null
}
mod_unbz2(){
        tar jxvf $1 -C $TMP_MOD_DIR >/dev/null
}
