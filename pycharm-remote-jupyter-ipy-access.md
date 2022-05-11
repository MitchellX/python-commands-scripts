3. Jupyter NoteBook连接远程服务器
3.1 服务器端的设置
## 步骤一 检查配置文件

​ 连接好服务器后，检查是否存在配置文件，一般为在隐藏文件夹 .jupyter 里的文件jupyter_notebook_config.py

​ 若不存在在终端输入以下命令生成配置文件

```
pip install -U jupyter
jupyter notebook --generate-config
```

## 步骤二 生成密码


## 步骤三 修改配置文件以及jupyter默认工作目录

接下来我们就需要修改相应的配置文件啦
输入以下命令：vim ~/.jupyter/jupyter_notebook_config.py
在文件最末端添加以下代码(补充跳转到文件末尾的方法：按esc键，然后输入:$ 即可跳转到文件末尾)：
```
c.NotebookApp.ip = '*' # 允许访问此服务器的 IP，星号表示任意 IP
c.NotebookApp.password = u'sha1:xxx:xxx' # 之前生成的密码 hash 字串, 粘贴进去
c.NotebookApp.open_browser = False # 运行时不打开本机浏览器
c.NotebookApp.port = 8890 # 使用的端口，随意设置
c.NotebookApp.enable_mathjax = True # 启用 MathJax
c.NotebookApp.allow_remote_access = True #允许远程访问
c.NotebookApp.notebook_dir = '/home/deepblue/xyf_work/' # 设置默认工作目录
```


## 步骤四 启动jupyter服务

终端输入命令 
`jupyter notebook 启动服务`

## 3.2 本机设置
使用以下命令将本地端口与服务器端相映射

8155是本地的端口（随意设置）
8890是我们刚才在服务器端的配置文件里面的设置
ssh -L [本地端口]:localhost:[远程端口] [远程用户名]@[远程IP] -p [ssh连接端口]

例如
`ssh -L 8855:localhost:8899 tongping@keb310-useast.xttech.tech -p 7022`

## pycharm 配置
pycharm中右上角, 点击configure server, http://localhost:8855
