Zeroai-Utils README
============

简介
===========

  ZeroAI-Utils

  Linux(CentOS7X_64) +openresty(nginx)+Mysql+PHP+Redis一键安装包.

  安装方式: 源码编译.

  优势: 注重性能，适合生产环境使用。

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
       MySQL Server, the worlds most popular open source database, and MySQL Cluster, a real-time, open source transactional database.
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

组件源与扩展
=======
公共组件源: https://github.com/zeroainet/zeroai-utils-components.git
中国地区的组件源 https://e.coding.net/zeroai/zeroai-utils-components.git
更改组件源

```shell
vi ./install.conf
修改 SOURCE_URL=https://github.com/zeroainet/zeroai-utils-components.git
```
可以自定义扩展组件


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