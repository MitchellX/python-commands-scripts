# Record Commands & Scripts
This repository aims to record some frequently-used commands, including Linux and python commands & archive some frequently-used python scripts.


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
    # 指定端口
    scp -P 7022 ./nyu_v2.zip tongping@keb310-useast.xttech.tech:/home/tongping/dataset/
    
### 传输多个文件夹
    2-0
    scp -r root@192.168.1.104:/usr/local/nginx/html/webs/\{index,json\} ./
    
    2-1 从本地文件复制多个文件到远程主机（多个文件使用空格分隔开）
    先进入本地目录下，然后运行如下命令：
    scp index.css json.js root@192.168.1.104:/usr/local/nginx/html/webs

### rsync
    rsync -rvz -e 'ssh -p **22' --exclude='*.model' dir/ host:/dir

    -a or --archive: archive mode, which preserves permissions, ownership, timestamps, and links.
    -v or --verbose: verbose output, which displays the progress of the transfer.
    -z or --compress: compresses the data during transfer, which can help to reduce the amount of data being transferred over the network.
    -P or --partial --progress: shows the progress of the transfer and resumes partially transferred files.
    -r recurse into directories
    -e 使用 ssh 作为远程 shell，这样所有的东西都被加密
    --exclude='*.out' ：排除匹配模式的文件，例如 *.out 或 *.c 等。
    
    要跳过已有传输可使用rsync：rsync -aWPu local root@host:remote，参数解释：
    -a：档案模式，保留源文件的所有属性，并递归传输目录
    -W：跳过增量传输算法，直接传输整个文件，在带宽较高时适用
    -P：显示传输进度
    -u：仅当源主机文件比目标主机中的文件更新时才传输

    
### 查看系统的版本
    centOS：
    cat /etc/redhat-release
    Ubuntu:
    lsb_release -a
    
### 查看系统cpu型号

    cat /proc/cpuinfo
    
### 查看Linux系统型号
Ubuntu：

    lsb_release -a
    uname -a
centOS：

    cat /etc/redhat-release
    rpm -q centos-release
    
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




# Git Command

## 查看不同分支操作（红色表示远程仓库的
    git branch 查看本地分支
    git branch -r 查看远程分支
    git branch -a 查看所有分支

## 创建分支并切换到新的分支
    git branch [branch name]
    git checkout [branch name] 切换到新的分支
可以一条命令执行

    git checkout -b [branch name] 创建+切换分支
    
## 将新分支推送到github
    git push origin [branch name]
    
## 分支的删除
删除本地分支

    git branch -d [branch name]
    
删除github远程分支，分支名前的冒号代表删除。

    git push origin :[branch name]
    
## git pull 取回远程分支
 
若只想取回某一部分，则用：
    
    git pull [repo的website地址] [branch name]
    
## download：
    git clone https://github.com/MitchellX/testImage.git
    
## upload：
    git add .        （注：别忘记后面的.，此操作是把Test文件夹下面的文件都添加进来
    git commit  -m  "提交信息"  （注：“提交信息”里面换成你需要，如“first commit”）
    git push -u origin master   （注：此操作目的是把本地仓库push到github上面，此步骤需要你输入帐号和密码）

一条指令完成

    git add . && git commit -m "update" && git push
    
## 清除分支
    git rm -r --cached .

## update--(git强制覆盖)：
    git fetch --all
    git reset --hard origin/main
    git pull
    
然后有两种方法来把你的代码和远程仓库中的代码合并

-a. git pull这样就直接把你本地仓库中的代码进行更新但问题是可能会有冲突(conflicts)，个人不推荐

-b. 先git fetch origin（把远程仓库中origin最新代码取回），再git merge origin/master（把本地代码和已取得的远程仓库最新代码合并），如果你的改动和远程仓库中最新代码有冲突，会提示，再去一个一个解决冲突，最后再从1开始

如果没有冲突，git push origin master，把你的改动推送到远程仓库中

## reset & revert 回滚到上个版本的代码
    https://zhuanlan.zhihu.com/p/137856034
    https://stackoverflow.com/questions/6084483/what-should-i-do-when-git-revert-aborts-with-an-error-message

# git强制覆盖本地命令（单条执行）：

    git fetch --all && git reset --hard origin/main && git pull


 git 删除远程分支上的某次提交
    git revert HEAD
    git push origin master
    删除最后一次提交，但是查看git log 会有记录
    




   
## 前后台切换命令
https://blog.csdn.net/u011630575/article/details/48288663

    fg          回到上一个进程
    bg          将一个在后台暂停的命令，变成继续执行。如果后台中有多个命令，可以用bg %jobnumber将选中的命令调出
    jobs -l     查看当前所有进程，并显示pid
    kill pid    杀死pid进程
    
## 监控GPU使用情况
    gpustat     最简单的
    watch -n 0.1 nvidia-smi   实时监控 -n设置间隔
    
    lspci | grep -i vga
    
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





# 2020-10-22 开始记录京东的笔记


## make cmake 装完包记得 更新一下
    sudo make install
    
## 禁止代理
    unset https_proxy
    unset http_proxy

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


    

## 正则表达式
*  匹配 0 或多个字符

?  匹配任意一个字符
   
    mv *.* ./1000/
    mv 6???.* ./6000/
    
## pip install xxx 太慢
    pip install xxx -i https://pypi.tuna.tsinghua.edu.cn/simple
    
### 使用ipdb调试
    python -m ipdb your_code.py
    
或者侵入式调试，可以进入os.system('命令')

    import ipdb
    ipdb.set_trace()


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
    
    # "no screen to be resumed", but indeed exist
    screen -d -r
    
    # 强制结束一些，你结束不了的session
    screen -X -S [session # you want to kill] quit



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

## 路径不存在, 创建路径
    if not os.path.exists(args.dest):
        os.mkdir(args.dest)


## splitext去掉后缀，basename去掉前置路径，python
    os.path.splitext()[0]
    os.path.basename()
    # 两个连用，只剩名词
    target_name = os.path.splitext(os.path.basename(target_path))[0]
    
### os.path.split()分割文件和上级目录
    landmark_txt = os.path.split(image_path)[1][:-3] + 'txt'
    upper_folder = os.path.split(os.path.split(image_path)[0])[0]
    
### str.split('-', 1 );  以'-'为分隔符，分隔成两个，避免出现多个'-'的情况

### str.rsplit('-', 1), 从后外前开始分割，用法和上面的一致
    
    
# JD Jupyter
    打开ssh端口     bash ~/notespace/xmc
    更新软件源       sudo apt-get update
    激活虚拟环境      source ~/envs/digitalman/bin/activate
    卸载并重装dlib       pip3 uninstall dlib     pip3 install dlib
    设置root密码        sudo passwd
    
### linux下修改python的默认版本：即python2->python3
删除原有链接

    rm /usr/bin/python 

建立新链接

    ln -s /usr/bin/python3.6这是你想要指向的版本号 /usr/bin/python
    
    ln [参数][源文件或目录][目标文件或目录]
    ln -s src/ ./
    
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
    
之后想从清华源下载的话，就用-i 指定路径：
    
    pip install virtualenv -i https://pypi.tuna.tsinghua.edu.cn/simple


### virtualenv 创建新的虚拟环境

    virtualenv --clear envs/test
    source envs/test/bin/activate
    deactivate
    
    
## 生成文件夹树形目录

windows下的CMD命令tree可以很方便的得到文件夹目录树

    tree /f>list.txt
    
### 将ls展示内容保存
    ls -v > list.txt    
    
## glob.glob(*) 类似正则表达式一样的，找寻目录
    a = glob.glob('*')
    print(a)
    :: ['Audio', 'batch_run.py', 'Data', 'Deep3DFaceReconstruction', 'pipeline.jpg', 'readme.md', 'render-to-video', 'requirements.txt', 'requirements_colab.txt', 'test.py']
    
    
    
## ls 查看文件数量
    ls | wc -l
    
## Windows下编辑的shell脚本在Linux下报错syntax错误
这是编码格式ff（fileformat）的问题，vim进去按照下面指令修改文件格式即可
    
    :set ff=unix
    
## pytorch的Tensor转成int or float
    tensor1.item()
    如何要转成字符串形式：
    str(tensor1.item())
    
## 把tensor多加一个维度
以numpy读入的图片（3, 256, 256） -> (1, 3, 256,256)为例

    img2 = torch.from_numpy(img2).float().unsqueeze(0).cuda()
    
## 用Python将list中的string转换为int
    results = list(map(int, results))
    还能将字符串后面的转义字符'\n \t'去除
    
    
## 将[1, 2 ,3] 转换成string并且作为文件的写入参数
    a = [1, 2, 3]
    log.write(' '.join(map(str, a)))

    
## Python, Numpy求 list 数组均值，方差，标准差
    arr_mean = np.mean(array) 求均值
    # 求按列求均值，只剩一行。axis=1时候，按照行取均值，只剩一列
    arr_mean = np.mean(array, axis=0) 
    arr_var = np.var(array)求方差
    arr_std = np.std(array,ddof=1)求标准差



### 计算欧氏距离Euclidean distance

    dist = np.linalg.norm(vec1-vec2)
    distance= np.sqrt(np.sum(np.square(vec1-vec2)))

### pip 导出当前环境的所有包
    
    pip freeze > ./requirements.txt

    # if pip freeze creates some weird path instead of the package version
    pip list --format=freeze > requirements.txt
    
### linux下解压7z
    sudo apt-get install p7zip-full
    7za x filename.7z

### python 添加上级/下级目录到finding path中
但是要记住这个代码要放在最上面

    sys.path.append('..')   # 添加上级目录
    sys.path.append('code/')   # 添加下级code/目录
    
    # 是在找不到当前目录下的文件, 就添加绝对路径.
    import sys
    sys.path.append("/home/tiger/bytegnn/python/bytegnn/ros_data")


    
### cv2在图片中添加文字
    # 各参数依次是：照片/添加的文字/左上角坐标/字体/字体大小/颜色/字体粗细
    cv2.putText(I,'there 0 error(s):',(50,150),cv2.FONT_HERSHEY_COMPLEX,6,(0,0,255),25)
    
### PIL在图片中添加文字（小字体）
具体请看文件：PIL_draw.py
    fontsize = 8
    font = ImageFont.truetype("arial.ttf", fontsize)
    draw.text((x, y), str(cnt), fill=(0, 255, 255), font=font)  # 利用ImageDraw的内置函数，在图片上写入文字

    
### cv2.imread()读取通道顺序，以及转换颜色通道
    img = cv2.imread(fengmian)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB) # cv2默认为bgr顺序
    h, w, _ = img.shape #返回height，width，以及通道数，不用所以省略掉
    
### np.array的RGB形式，用cv2去写BGR
    cv2.imwrite('test2.jpg', img[..., ::-1])
或者这样写，意思主要是将RGB三通道逆序：

    img[:, :, ::-1]
    
### cv2如果要读取4通道的rgba数据，要加-1表示读到最后一位，不然的话平常只会读前三维
    cv2.imread(img, -1)
    
### cv2裁剪坐标, numpy 切片
    cropped = img[0:128, 0:512]  # 裁剪坐标为[y0:y1, x0:x1]，先width后height
    
### cv2图片简单拼接 hconcat vconcat函数使用
    img =cv2.imread(file_path[i])
    img=cv2.hconcat([img,img,img])#水平拼接
    img=cv2.vconcat([img,img,img])#垂直拼接
    
### cv2用np.concatenate去拼接图片
    np.concatenate((img, img, img), axis=1) 
    axis=0表示只剩一列，axis=1表示只剩一行，注意这里！里面是括号，tuple元组的形式
    
### cv2获取图像的三通道，并且写视频cv2.VideoWriter()
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    w, h, c = test_img.shape
    video_writer = cv2.VideoWriter(save_name, fourcc, fps, (h, w))
    
    for img in imgs:
        if img[-3:] != 'jpg' and img[-3:] != 'png':
            continue
        imgname = os.path.join(imgs_dir, img)
        frame = cv2.imread(imgname, -1)
        video_writer.write(frame)

    video_writer.release()
    
### cv2读取带有中文的文件路径
    # cv2读有中文路径的图片
    img = cv2.imdecode(np.fromfile(image, dtype=np.uint8), -1)


### python调用shell命令
    import os
    os.system("cmd")
    
    
### Python 随机数生成
    import random
    x = random.randint(0,9)
    
### CSV中文文本乱码问题

打开 UTF-8 编码的 CSV 文件的方法：

1) 打开 Excel 

2) 执行“数据”->“自文本”

3) 选择 CSV 文件，出现文本导入向导

4) 选择“分隔符号”，下一步

5) 勾选“逗号”，去掉“ Tab 键”，下一步，完成

6）在“导入数据”对话框里，直接点确定


### pd.read_csv()中文乱码问题
    data = pd.read_csv('sample.csv', encoding='GB18030')

### 对list进行切片
    L = ['Adam', 'Lisa', 'Bart', 'Paul', 'a', 'b']
    print(L[::2])
    output: ['Adam', 'Bart', 'a']
    print(L[1::2])      
    output: ['Lisa', 'Paul', 'b']
    
### list双重中括号，可以任意点索引
    get_landmark[[52, 53, 54, 55, 56, 61, 66, 88]]

### 用numpy 存储和读取字典
    for filesName in filesNames:
        dictionary[filesName] = '{:0>4d}'.format(i)
        i += 1
    np.save("name_diction.npy", dictionary)

    read_dic = np.load('name_diction.npy', allow_pickle=True).item()
    print(read_dic)

### windows查找文件夹下所有文件的内容
    findstr /s /i "string" *.*  
上面的命令表示，当前目录以及当前目录的所有子目录下的所有文件中查找"string"这个字符串。

### pandas读取csv格式文件
    import pandas as pd

    df = pd.read_csv('board.csv')
    print(len(df))
    print(df.head())
    # read the title of dataFrame
    header = df.columns.values.tolist()
    print(header)



    for i in range(len(df)):
        print(df[header[0]][i])
        print(df[header[1]][i])
        print(df[header[2]][i])
        print(df[header[3]][i])
        print(df[header[4]][i])
 
### 向量相乘维度对不上(1920,1080,3) * (1920,1080) 
    mask[:, :, np.newaxis]
    np.expand_dims(x, 2)
    
    # 扩充width、height
    self.IMG_MEAN[np.newaxis, np.newaxis, :]
    
### strip() 和 split()函数
    line.strip().split()
    strip() 方法用于移除字符串头尾指定的字符（默认为空格）或字符序列。注意：该方法只能删除开头或是结尾的字符，不能删除中间部分的字符。
    split() 默认为所有的空字符，包括空格、换行(\n)、制表符(\t)等

### 删除多的.ipy文件夹
    for i in `ls`;do if [ -d $i/.ipynb_checkpoints ];then echo $i; fi; done
    rm -rf M030_angry_3_003/.ipynb_checkpoints/

### ffmpeg合并音频和视频(没有声音)
    ffmpeg -i 4_concate.avi -i all.mp3 -c:v copy -c:a aac -strict experimental output.mp4
    
### ffmpeg合并音频和视频(视频有声音)
audio音频替换video中的音频

    ffmpeg -i video.mp4 -i audio.wav -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 output.mp4


### ffmpeg拼接多个音频
1.新建文本文档  list.txt  ，包含要拼接的音频，格式如：

    file '1.mp3'
    file '2.mp3'
2.可以用一下命令生产这个list
    
    ls *.mp3 > list.txt
    
3.拼接，命令如：

    ffmpeg -f concat -i list.txt -c copy 007.mp3




### ffmpeg音频格式转换
    ffmpeg -i input.mp3 output.wav
    ffmpeg -i input.m4a -acodec pcm_s16le -ac 1 -ar 8000 output.wav

## ffmpeg视频分出音频
    ffmpeg -i input.mp4 output.wav

### ffmpeg 将视频拆帧
    ffmpeg -i video.avi frames_%05d.jpg

### ffmpeg 将图片合成视频
    ffmpeg -i M030_angry_3_001/fake_B_%06d.jpg -vcodec mpeg4 test.avi

### ffmpeg 将图片合成视频+音频
    ffmpeg -i M030_angry_3_001/fake_B_%06d.jpg -i audio.mp3 -vcodec mpeg4 test.avi
    
### 换MP4格式也可以
输出的时候，编码器换下
    
    -vcodec libx264 输出.mp4

完整版本：
    
    ffmpeg -y -r 25 -i M030_angry_3_001/fake_B_%06d.jpg -i audio.mp3 -vcodec mpeg4 test.avi
    
    -y 表示覆盖原视频
    -r 25 表示帧数
    -i M030_angry_3_001/fake_B_%06d.jpg 表示要合成的图片的路径
    -i audio.mp3 表示要添加的音频
    
### linux 创建多级目录
    mkdir -p
   
    
### .pkl文件的读取、生成
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(data, f)    #这个data也可以是list
    
    with open(file_path, 'rb') as f:           
        file = pickle.load(f)
        
### json文件的读取
    with open(json_file, 'r') as f:
    info = json.load(f)


### .npy文件的读取、生成
    a=np.arange(5)
    np.save('test.npy',a)
    
    a=np.load('test.npy')
    
### 看音频的sample_rate
    import scipy.id.wavefile as wavfile
    sample_rate,signal=wavfile.read('stop.wav')

### Linux下的数字排序
1、2、10 排序后结果是 1、10、2。如果按照人为逻辑则是 1、2、10

    ls -lv
    
### argparse模块中的action参数
store_true就代表着一旦有这个参数，做出动作“将其值标为True”，也就是没有时，默认状态下其值为False。反之亦然，store_false也就是默认为True，一旦命令中有此参数，其值则变为False。

    parser.add_argument('--lstm', action='store_true')
    
### 查看CUDA版本
    cat /usr/local/cuda/version.txt
    nvcc --version
### 查看NVIDIA版本
    cat /proc/driver/nvidia/version

### 挂载硬盘
挂载大于2T的硬盘时候，要用GPT的命令，参考这个链接的第二条
https://www.thegeekstuff.com/2012/08/2tb-gtp-parted/

挂载小于2T（非服务器）的硬盘，参考这个就足够：
https://cloud.tencent.com/developer/article/1746763

自动挂载（重启后有效）
https://www.jianshu.com/p/336758411dbf

### anaconda多用户
anaconda多用户的安装和user添加可以参考这个链接
https://blog.csdn.net/codedancing/article/details/103936542

### cuda和cudnn的安装
Ubuntu 18.04安装CUDA（版本10.2）和cuDNN，参考：
https://blog.csdn.net/ywdll/article/details/103619130

报错：Failed to initialize NVML: Driver/library version mismatch。cuda和gpu的内核版本不一致：

### Linux用户管理
ubuntu 创建用户 删除用户 切换用户 修改密码 管理员权限
https://blog.csdn.net/superjunenaruto/article/details/110100781

### Linux权限修改
    sudo chmod 777 ××× （每个人都有读和写以及执行的权限）
    
### Linux重启命令
    reboot 需要root用户
    shutdown -r now
### Linux系统登录新建用户时，shell开头为$
Linux系统登录新建用户时，shell开头为$，不显示用户名和路径的解决办法
https://blog.csdn.net/Du_wood/article/details/84914759?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control







# pytorch
### np转tensor
    a = torch.from_numpy()  浮点数是64位的
    a.float()               变成32位的
    
    torch.Tensor() 32位的
    
    
 ### torch.tensor 和torch.Tensor
    torch.Tensor 是torch.FloatTensor的别名，32位的
    torch.tensor 根据输入类型决定类型。
 
 ### 扩大tensor张量
    torch.Tensor.expand(shape)  相同填充
    
    
### 自定义一个loss function
    class My_mse_loss(nn.Module):
        def __init__(self):
            super(My_mse_loss, self).__init__()
            self.mse_loss_fn = nn.MSELoss(size_average=False, reduce=False)
            self.weight = np.ones([136])
            self.weight[96:] = self.weight[96:] + 1
            self.weight = torch.Tensor(self.weight).cuda()

        def forward(self, infer_lm, gt_lm):
            loss = self.mse_loss_fn(infer_lm, gt_lm)
            shape = gt_lm.shape
            self.weight = self.weight.expand(shape)
            loss_final = loss * self.weight
            loss_final = torch.mean(loss_final)
            return loss_final

### 查看网络的值
        for parameters in self.generator.parameters():
            print parameters
            break

      
 ### Linux 创建删除用户
    sudo useradd -m username -d /export4/username -s /bin/bash
    userdel username
 
 ### linux搜索命令
    find ./ -name *fsgan*
    
### Python3 求最大/小值及索引值、位置 Numpy
    list = [9, 12, 88, 14, 25]
    max_list =  max(list) # 返回最大值
    max_index = list.index(max(list))# 最大值的索引
    # 最小的话 max换成min
    
    
    FLOPS denotes the total number of floating point operations of the neural network in a forward propogation.
    FLOPs denotes the floating point operations per second.
    
### allocate the GPU cluster in Gypsum
    srun --pty --partition=1080ti-short --gres=gpu:1 --time=0-04:00:00 /bin/bash
    
    
### pycharm 卡在 updating helpers / skeleton
    cd /home/root/
    cd ./.pycharm_helpers/
    rm -rf check_all_test_suite.py
    tar -xvzf helpers.tar.gz
    
或者:
    例如C:\Program Files\JetBrains\PyCharm 2017.2.3这里面找到并且
    删掉skeletons文件夹，重新启动再配置远程环境就好了
    
### store a dictionary

    import json

    with open('my_dict.json', 'w') as f:
        json.dump(my_dict, f)

    # elsewhere...

    with open('my_dict.json') as f:
        my_dict = json.load(f)

### docker copy

    sudo docker cp mysql-5.1.32-linux-x86_64-icc-glibc23.tar.gz xenodochial_mcnulty/:/home
    
    
### plot matplot

```
import matplotlib.pyplot as plt

#折线图
x = [0,0.2,0.4,0.6,0.8]#点的横坐标
k1 = [5.86, 7.03, 10.77, 13.55, 15.98]#线1的纵坐标
k2 = [6.16, 8.59, 11.92, 14.43, 17.19]
plt.plot(x,k1,'s-',color = 'r',label="with cache")#s-:方形
plt.plot(x,k2,'o-',color = 'g',label="without cache")#o-:圆形
plt.xlabel("p (probability)")#横坐标名字
plt.ylabel("latency")#纵坐标名字
plt.legend(loc = "best")#图例
# plt.show()
plt.savefig('test.png')


plt.imshow(img)
plt.show()


```


### Linux 上查看cache大小, memory大小

    getconf -a | grep CACHE
    cat /proc/meminfo
    
### Linux 上查看用户进程
    ps -p <PID> -o user
    
### 其实在Nvidia驱动确定后, 可以装不同的CUDA version, 甚至在不同的conda envs下

    conda create -n py37 python=3.7
    conda activate py37
    conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch
    conda install -c nvidia cuda

### conda清理没用的安装包
    
    conda clean -y -all //删除所有的安装包及cache
    
### du -lh排序
    du -s * | sort -hr | head 选出排在前面的10个， du -s * | sort -hr| tail 选出排在后面的10个。
    
### C++ codes export python interface

    https://pybind11.readthedocs.io/en/latest/classes.html
    g++ -O3 -Wall -shared -std=c++11 -fPIC $(python3 -m pybind11 --includes) example.cpp -o example$(python3-config --extension-suffix)
    
    
### find command 
    find ./ -name "mytest.*"

### Environment

You can build on your conda environment from the provided ```environment.yml```. Feel free to change the env name in the file.

```bash
conda env create -f environment.yml

or

conda env update --name myenv --file local.yml --prune
// prune uninstalls dependencies which were removed from local.yml
```

### Unity Cluster
    squeue --me
    scancel job_id
    
### nn.ModuleList()
    Holds submodules in a list.
    self.blocks = nn.ModuleList(self.blocks)


### tensor 的整数除法
RuntimeError: Integer division of tensors using div or / is no longer supported, and in a future release div will perform true division as in Python 3. Use true_divide or floor_divide (// in Python) instead.

Using floor division (//) will floor the result to the largest possible integer.
Using torch.true_divide(Dividend, Divisor) or numpy.true_divide(Dividend, Divisor) in stead.

    For example: 3/4 = torch.true_divide(3, 4)
    
    
## Convert a String representation of a Dictionary to a dictionary

    >>> import ast
    >>> ast.literal_eval("{'muffin' : 'lolz', 'foo' : 'kitty'}")
    {'muffin': 'lolz', 'foo': 'kitty'}

### 用list可以将pytorch的generator variables变成一个可查看的list
    list(model.modules())
    
    
### 网页端的tensorboard使用与远程访问、端口转发
    tensorboard --logdir=xmc_test_norm/ --port 8000 --bind_all
    ssh -L 16006:127.0.0.1:6006 user@hostname
    # 使用SSH将服务器的6006端口重定向到自己机器上来。其中16006:127.0.0.1代表自己机器上的16006号端口，6006是服务器上tensorboard使用的端口。
    # https://blog.csdn.net/xg123321123/article/details/81153735

### 通过pid查看代码参数
    ps -p 2711389 -o cmd=
    
### print the last line of each file
    tail -n 1 <filename>

### repeat downloading if some files fail
    wget -nc -i file_list.txt
    
### mv all the file exclude *.tar     
    mv source_directory/!(*.tar) destination_directory/

### conda create & update env from yml file
    conda env create -n ENVNAME --file requirements.yml
    conda env update --file requirements.yml --prune

### To see the full command including the arguments using PID in linux
    ps -p [pid] -o args=

## you can run all the command in the project root path after exporting the python path
```
export PYTHONPATH=$PYTHONPATH:$(pwd)
```


### Create a pull request in command line
```
git checkout -b new-feature-branch
git add .
git commit -m "A descriptive message about your changes"
git push origin new-feature-branch
```


### solve push conflicts
    git pull
    
    git config pull.rebase false
    git reset --hard HEAD~1

### cooperation on GitHub (submodule)
```
1. get the newest update from the original project
2. push your own codes even without permission
```

```
1. fork the desired project.
2. clone the fork into your local repo
    git clone https://github.com/MitchellX/flash-attention.git
3. add the original repo as upstream, so that you can pull the newest changes
    git remote add upstream https://github.com/Dao-AILab/flash-attention.git
4. see the remote choices
    git remote -v
5. get the newest changes
    git pull upstream/main
    or git fetch upstream/main + git merge upstream/main
6. push codes to remote (default: origin/main, you don't have access to upstream/main)
    git push
```
