

## 创建容器以及安装相关lib

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

## 配置2：把MySql安装到/usr/local/mysql 下,语言用utf8

    ./configure --prefix=/usr/local/mysql --with-charset=utf8 --with-extra-charset=all --enable-thread-safe-client --enable-local-infile 
    
## build
     make && make install


