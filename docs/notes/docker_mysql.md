## 下载对应版本的mysql source package 
[MySQL :: Download MySQL Community Server (Archived Versions)](https://downloads.mysql.com/archives/community/)


## check mysql文档, 找到对应的OS版本: 
https://docs.oracle.com/cd/E19078-01/mysql/mysql-refman-5.1/installing.html#quick-install

     比如本次我们要用的Linux操作系统是 ubuntu 9.04 (jaunty)
     
## 创建容器以及安装相关lib
https://github.com/iComputer7/ancient-ubuntu-docker

     docker run -it icomputer7/ancient-ubuntu-docker:jaunty /bin/bash
     apt-get update
非常重要的library!

     apt-get install g++ gcc build-essential cmake make libncurses5-dev

## 要退出终端，直接输入 exit:
     exit

## 使用 docker start 启动一个已停止的容器
     docker start (id)

## 进入容器, docker exec：推荐使用 docker exec 命令，因为此命令会退出容器终端，但不会导致容器的停止。
     docker exec -it (id) /bin/bash

## copy files from host to Docker container
    docker cp mysql-5.0.96.tar.gz (id):/home


# build mysql from source code

## 建用户,用户组  
    groupadd mysql
    useradd -g mysql mysql

## 配置1：把MySql安装到/usr/local/mysql目录，其它采用默认配置

    ./configure --prefix=/usr/local/mysql

看到一下信息表示安装成功了!

     Thank you for choosing MySQL!

     Remember to check the platform specific part of the reference manual
     for hints about installing MySQL on your platform.
     Also have a look at the files in the Docs directory.
     
## 配置2：把MySql安装到/usr/local/mysql 下,语言用utf8

    ./configure --prefix=/usr/local/mysql --with-charset=utf8 --with-extra-charset=all --enable-thread-safe-client --enable-local-infile 
    
## build
     make && make install

## 拷贝安装my.cnf配置文件 ，这是MySql的最重要的配置文件，每次启动都会读这个文件 ，
    cp support-files/my-medium.cnf /etc/my.cnf

## 初步配置mysql
     cd /usr/local/mysql   //进入mysql目录
     bin/mysql_install_db --user=mysql  //初始化数据库
     chown -R root .  //设置安装根目录权限
     chown -R mysql /usr/local/mysql/var //设置数据目录的权限
     bin/mysqld_safe --user=mysql &  //以安全方式启动mysql，后面加一个&表示后台运行

     bin/mysqladmin -uroot password 123456  #在mysql首次正常启动情况下，更改root用户登录密码
     bin/mysql -uroot -p              #输入此命令后，按回车会显示让你输入root密码
     mysql> show databases;             #show一下你所有的数据库。
     mysql> quit;                       #退出mysql

## 把mysql加入到系统服务中
     cp /usr/local/mysql/share/mysql/mysql.server /etc/init.d/mysqld  
     //这样就可以通过/etc/init.d/mysqld start|stop|restart来重启mysqll
     
     echo export PATH=$PATH:/usr/local/mysql/bin >> /etc/profile   //配置mysql环境变量
     
     source /etc/profile  //要让刚才的修改马上生效，需要执行此代码  



