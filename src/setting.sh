#!/bin/bash




CPU_NUM=`cat /proc/cpuinfo|grep "model name"|wc -l`


#资源包存放目录
SOURCE_DIR=$CURRENT_DIR/source/


#模块存放目录
SOURCE_MODULE_DIR=${SOURCE_DIR}mod/

#组件存放目录
SOURCE_MODULE_DIR=${SOURCE_DIR}com/

#安装脚本源码目录
SRC_DIR=$CURRENT_DIR/src/

#临时解压与安装目录
TMP_DIR=$CURRENT_DIR/tmp/

#组件临时目录
TMP_COM_DIR=${TMP_DIR}com/

#模块临时目录
TMP_MOD_DIR=${TMP_DIR}mod/

#默认安装目录
INSTALL_DIR=/usr/local/

#数据目录
DATA_DIR=/data/

#网站目录
DATA_WEB_DIR=${DATA_DIR}web/

#数据库目录
DATA_DB_DIR=${DATA_DIR}db/

#script文件路径
DATA_SCRIPT_DIR=${DATA_DIR}script/

#conf文件路径
DATA_CONF_DIR=${DATA_DIR}conf/

#bak文件路径
DATA_BAK_DIR=${DATA_DIR}bak/

#LOG存放目录
DATA_LOG_DIR=${DATA_DIR}log/

#DFS存储目录
DATA_DFS_DIR=${DATA_DIR}dfs/

#缓存文件路径
DATA_CACHE_DIR=${DATA_DIR}cache/

#LOG文件路径
DATA_LOG_FILE=${DATA_DIR}${autosetup}.log

#模块目录
MOD_DIR=""

#模块名称
MOD_NAME=""

#模块安装文件
MOD_INSTALL_SCRIPT=""

#模块安装包目录
MOD_PACKAGE_DIR=""

#模块配置目录
MOD_CONF_DIR=""

#组件目录
COM_DIR=""

#组件名称
COM_NAME=""

#组件源码文件
COM_SOURCE_FILE=""

#组件安装目录
COM_INSTALL_DIR=""

#组件安装脚本
COM_INSTALL_SCRIPT=""

#组件安装包目录
COM_PACKAGE_DIR=""

#组件配置目录
COM_CONF_DIR=""

#组件的配置目录
COM_DATA_CONF_DIR=""

#组件的DB目录
COM_DATA_DB_DIR=""


#组件的脚本目录
COM_DATA_SCRIPT_DIR=""

#组件的日志目录
COM_DATA_LOG_DIR=""
