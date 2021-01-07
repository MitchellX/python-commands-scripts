# Record Command
this repository aims to record some frequently-used command, including Linux and python commands.

# Linux Common Command
    cd - 返回上次的目录
  
## 从YouTube下载视频
    !pip3 install youtube-dl ffmpeg-python

    source_url = 'https://www.youtube.com/watch?v=5-s3ANu4eMs' #@param {type:"string"}
    
    # (start, end) 剪取指定时长
    source_start = '00:01:40' #@param {type:"string"}
    source_end = '00:01:50' #@param {type:"string"}

    !mkdir -p /content/data
    !rm -dr /content/data/source*
    !youtube-dl $source_url --merge-output-format mp4 -o /content/data/source_tmp.mp4
    !ffmpeg -y -i /content/data/source_tmp.mp4 -ss $source_start -to $source_end -r 25 /content/data/source.mp4
    !rm /content/data/source_tmp.mp4
   
Taylor Swift videos:

    source_url = 'https://www.youtube.com/watch?v=JgkCFCOAn48'
    source_start = '00:00:08' #@param {type:"string"}
    source_end = '00:00:25' #@param {type:"string"}
    
    
## 前后台切换命令
https://blog.csdn.net/u011630575/article/details/48288663

    fg          回到上一个进程
    bg          将一个在后台暂停的命令，变成继续执行。如果后台中有多个命令，可以用bg %jobnumber将选中的命令调出
    jobs -l     查看当前所有进程，并显示pid
    kill pid    杀死pid进程
    
## 监控GPU使用情况
    gpustat     最简单的
    watch -n 0.1 nvidia-smi   实时监控 -n设置间隔
    
## 释放GPU一直占用的显存
    fuser -v /dev/nvidia*   查看当前系统中GPU占用的线程
    nvidia-smi              也能查看pid
    kill -9 pid             结束进程
## pytorch查看tensor大小
    import sys
    sys.getsizeof(input.storage())      单位byte B
    
## pytorch查看Net model详情
    print('model.__len__(): %d layers' % model.__len__())
    print(f'model.__len__(): {model.__len__()} layers')

    # U-net(5, 64) memory usage
    param_count = sum(p.storage().size() for p in model.parameters())
    param_size = sum(p.storage().size() * p.storage().element_size() for p in model.parameters())
    param_scale = 2  # param + grad

    print(f'# of Model Parameters: {param_count:,}')
    print(f'Total Model Parameter Memory: {param_size * param_scale:,} Bytes')
    
## View继承nn.Module，这样即可放入nn.Sequential()中了
在接入全连接层前，一般都需要一个打平的操作放在nn.Sequential里面，因此需要自己写一个打平的类继承自nn.Module.以上便是代码，特记录之。

    class View(nn.Module):
    def __init__(self):
        super(View, self).__init__()
    def forward(self, x):
        return x.view(x.size[0], -1)
        
## Conda环境复制的方法
前提是，在本地的conda里已经有一个叫AAA的环境，我想创建一个新环境跟它一模一样的叫BBB，那么这样一句就搞定了：
    
    conda create -n BBB --clone AAA
    conda create -n your_env_name python=X.X（2.7、3.6等)   # Conda 创建虚拟环境
    conda remove -n your_env_name(虚拟环境名称) --all       #  删除虚拟环境
但是如果是跨计算机呢。查询conda create命令的原来说明，是这样的：

    –clone ENV
    Path to (or name of) existing local environment.    
–clone这个参数后面的不仅可以是环境的名字，也可以是环境的路径。所以，很自然地，我们可以把原来电脑上目标conda环境的目录复制到新电脑上，然后再用：

    conda create -n BBB --clone ~/path
参考：https://blog.csdn.net/qq_38262728/article/details/88744268


# Git Command

## download：
    git clone https://github.com/MitchellX/testImage.git
    
无用的：
    mkdir yourFileName
    cd /yourFileName
    git init

## upload：
    git add .        （注：别忘记后面的.，此操作是把Test文件夹下面的文件都添加进来
    git commit  -m  "提交信息"  （注：“提交信息”里面换成你需要，如“first commit”）
    git push -u origin master   （注：此操作目的是把本地仓库push到github上面，此步骤需要你输入帐号和密码）
    ## 一条指令完成
    git add . && git commit -m "update" && git push

## update--(git强制覆盖)：
    git fetch --all
    git reset --hard origin/master
    git pull
    
然后有两种方法来把你的代码和远程仓库中的代码合并

-a. git pull这样就直接把你本地仓库中的代码进行更新但问题是可能会有冲突(conflicts)，个人不推荐

-b. 先git fetch origin（把远程仓库中origin最新代码取回），再git merge origin/master（把本地代码和已取得的远程仓库最新代码合并），如果你的改动和远程仓库中最新代码有冲突，会提示，再去一个一个解决冲突，最后再从1开始

如果没有冲突，git push origin master，把你的改动推送到远程仓库中

## delete:
    git reset --hard HEAD^ 可以将本地的仓库回滚到上一次提交时的状态，HEAD^指的是上一次提交。

# git强制覆盖本地命令（单条执行）：

    git fetch --all && git reset --hard origin/master && git pull


 git 删除远程分支上的某次提交
    git revert HEAD
    git push origin master
    删除最后一次提交，但是查看git log 会有记录
    




# 2020-10-22 开始记录京东的笔记


## make cmake 装完包记得 更新一下
    sudo make install

## sudo apt-get install 包之前记得更新源
    sudo apt-get update


## 改变环境变量。要立即生效的话，记得source ~/.bashrc
    export PYTHONPATH=$PYTHONPATH:~/你的环境位置
    export PYTHONPATH=$PYTHONPATH:/home/xiangmingcan/notespace/deepfakes/faceswapNirkin/face_swap/interfaces/python

## 从YouTube下载视频
    !pip3 install youtube-dl ffmpeg-python

    source_url = 'https://www.youtube.com/watch?v=5-s3ANu4eMs' #@param {type:"string"}
    
    # (start, end) 剪取指定时长
    source_start = '00:01:40' #@param {type:"string"}
    source_end = '00:01:50' #@param {type:"string"}

    !mkdir -p /content/data
    !rm -dr /content/data/source*
    !youtube-dl $source_url --merge-output-format mp4 -o /content/data/source_tmp.mp4
    !ffmpeg -y -i /content/data/source_tmp.mp4 -ss $source_start -to $source_end -r 25 /content/data/source.mp4
    !rm /content/data/source_tmp.mp4
   
Taylor Swift videos:

    source_url = 'https://www.youtube.com/watch?v=JgkCFCOAn48'
    source_start = '00:00:08' #@param {type:"string"}
    source_end = '00:00:25' #@param {type:"string"}

# 在终端执行程序时指定GPU

    CUDA_VISIBLE_DEVICES=1 python xxx.py ...
    
    CUDA_VISIBLE_DEVICES=0    python  your_file.py  # 指定GPU集群中第一块GPU使用,其他的屏蔽掉

    CUDA_VISIBLE_DEVICES=1           Only device 1 will be seen
    CUDA_VISIBLE_DEVICES=0,1         Devices 0 and 1 will be visible


## 从Linux服务器下载文件到Windows：
    # scp root@10.1.22.5:/root/1.txt e:\scpdata\
    scp xiangmingcan@10.207.174.24:/export2/xiangmingcan/celeba.tar e:    # 下载到E盘
windows上传文件夹到linux服务器：

    scp -rp e:\scpdata root@10.1.22.5:/root
    
Linux服务器之间传输：[点此](https://kernel.blog.csdn.net/article/details/51673229?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param)

### 远程到本地
以admin的身份把IP地址为“192.168.219.125”，/home/admin/test目录下所有的东西都拷贝到本机/home/admin/目录下
    
    scp -r 用户名@计算机IP或者计算机名称:目录名 本地路径
    scp -r  admin@192.168.219.125:/home/admin/test     /home/admin/
### 本地到远程
    
    scp -r 要传的本地目录名     用户名@计算机IP或名称:远程路径
    scp -r /home/music/    root@ipAddress:/home/root/others/ 
    
## linux tar (打包.压缩.解压缩)命令说明 | tar如何解压文件到指定的目录？

    # 不需要加密/或Windows下一步解压，就用这个
    tar -cvf ***.tar /source
    tar -xvf ***.tar
压缩
    
    tar -czvf *name*.tar.gz /source
    tar -cjvf *name*.tar.bz2 /source
    
    tar -czvf 3000.tar.gz 3000/   #举例
解压缩

    tar -xzvf ***.tar.gz
    tar -xjvf ***.tar.bz2
参数解析

    -c: compress建立压缩档案
    -x：解压
    -t：tex 查看内容
    -v: view 查看过程
    -f: force 参数-f是必须的。使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名。
    
    -z：有gzip属性的
    -j：有bz2属性的
    

## 正则表达式
*  匹配 0 或多个字符

?  匹配任意一个字符
   
    mv *.* ./1000/
    mv 6???.* ./6000/
    
## pip install xxx 太慢
    pip install xxx -i https://pypi.tuna.tsinghua.edu.cn/simple


## du查看目录大小，df查看磁盘使用情况。
    df -lh
    du -lh
    
## screen 命令详解
    yum install -y screen	    安装screen工具。
    screen	                  打开一个screen会话
    screen -S <name>          建立一个screen会话，名字是:name
    先按Ctrl+a，再按d	        退出screen会话。
    screen -ls	              查看打开的screen会话。
    screen -r 编号	          退出后再次登录某个会话。
    Ctrl+d或exit	             结束screen会话。


# shell命令
    for i in `ls templates/*.mp4`;do
    name=`basename $i .mp4`
    if [ ! -d templates/$name ];then
    python image2video_fp.py templates/$i templates/$name
    fi
    python main.py $name
    python image2video_fp.py results/${name}_sijiali results/${name}_sijiali.mp4 25
    echo $i
    done
    
basename是指去掉 .mp4后的base名词

#如果文件夹不存在，创建文件夹

    if [ ! -d "/myfolder" ]; then
      mkdir /myfolder
    fi

## shell去掉后缀了前面的路径都可以用basename
    username=$(basename $username) 去掉前置路径
    username=$(basename $username .jpg) 增加去掉后缀


## splitext去掉后缀，basename去掉前置路径，python
    os.path.splitext()[0]
    os.path.basename()
    # 两个连用，只剩名词
    target_name = os.path.splitext(os.path.basename(target_path))[0]
    
    
# JD Jupyter
    ssh 打开
    sudo apt-get update
    
### linux下修改python的默认版本：即python2->python3
删除原有链接

    rm /usr/bin/python 

建立新链接

    ln -s /usr/bin/python3.6这是你想要指向的版本号 /usr/bin/python
    
## 想更新最新版软件

    /etc/apt/sources.list

先备份jd的源，然后更新清华源：

    cp sources.list sources.list2
    vim sources.list
    
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
    
更新源千万不能加sudo，不然会失败的！！！
    
    apt-get update
    完成之后，即可装最新的软件了
    
    
    
## 生成文件夹树形目录

windows下的CMD命令tree可以很方便的得到文件夹目录树

    tree /f>list.txt
    
    
## glob.glob(*) 类似正则表达式一样的，找寻目录
    a = glob.glob('*')
    print(a)
    :: ['Audio', 'batch_run.py', 'Data', 'Deep3DFaceReconstruction', 'pipeline.jpg', 'readme.md', 'render-to-video', 'requirements.txt', 'requirements_colab.txt', 'test.py']
