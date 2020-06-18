Zeroai-Utils README
============

简介
===========

  ZeroAI-Utils 是一个Linux CentOS-7.x x86_64的运维环境一键安装工具包.
  主要集成了openresty(nginx)+Mysql+PHP+Redis为核心的运维环境。

  安装方式: 源码编译.

  优势:   注重性能。

  推荐系统: CentOS 7.x 64 minimal

  推荐基础硬件:
  			CPU 4/8核，
  			内存16/32G，
  			硬盘SSD+HDD。

组件清单
=======
```shell
   openresty(nginx+lua) 1.15.8.2 https://github.com/openresty/openresty.git
       High Performance Web Platform Based on Nginx and LuaJIT
   mysql                8.0.18 https://github.com/mysql/mysql-server.git
       MySQL Server, the world's most popular open source database, and MySQL Cluster, a real-time, open source transactional database.
   php                  7.3.10 http://php.net
       PHP语言环境
   redis                5.0.7 http://redis.io/
       可持久化的内存NOSQL
   memcached            1.5.19 http://www.memcached.org/
       纯内存NOSQL
   fastdfs              6.01 https://github.com/happyfish100/fastdfs.git
       分布式小文件存储
   lsyncd
       CentOS下文件实时同步组件

```

安装方式
=======
```shell
   git clone https://github.com/zeroainet/zeroai-utils.git
```

使用方式
=======
```shell
   #安装
   cd zeroai-utils
   ./install.sh -c php,redis,mysql,memcached,openresty
```