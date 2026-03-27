# Python Commands & Scripts（重整版）

这个仓库用于沉淀常用 **Linux / Git / Python 命令** 和日常脚本。  
你提到希望能在 README 正文里直接 `Ctrl + F` 找到命令，因此本版把常用命令与脚本运行命令都集中到一个文档里（不需要再点进目录找）。

---

## 目录（可直接搜索）

- [1. 仓库结构（按功能重组）](#1-仓库结构按功能重组)
- [2. 一次性高频命令清单（Git / Linux / 环境）](#2-一次性高频命令清单git--linux--环境)
- [3. 全部脚本运行命令（可 Ctrl + F）](#3-全部脚本运行命令可-ctrl--f)
- [4. 速查：关键词索引](#4-速查关键词索引)

---

## 1. 仓库结构（按功能重组）

> 已完成一次物理重组：根目录脚本归档到 `scripts/`，杂项笔记归档到 `docs/notes/`，其余功能目录保持不变。

### A) Python 脚本（已归档）
- `scripts/python/PIL_draw.py`
- `scripts/python/batch_move.py`
- `scripts/python/convert_txt_format.py`
- `scripts/python/csv_gen.py`
- `scripts/python/delete_script.py`
- `scripts/python/image_review.py`
- `scripts/python/to_excel.py`
- `scripts/python/visualization_from_txt.py`
- `scripts/python/visualization_match_biaozhuTeam.py`

### B) 指标计算
- `calculate_ssim/`
- `calculate_headpose/`

### C) 下载工具
- `google_drive_downloader/`

### D) Shell 工具
- `scripts/shell/run.sh`
- `scripts/shell/copytxt.sh`
- `scripts/shell/rename.sh`
- `scripts/shell/doas-install.sh`

### E) 文档笔记
- `docs/notes/MacOS.md`
- `docs/notes/VS2019.md`
- `docs/notes/docker_mysql.md`
- `docs/notes/memory.md`
- `docs/notes/latex.md`
- `docs/notes/Interview_notes.md`
- `docs/notes/review.md`
- `docs/notes/test.md`
- `docs/notes/pycharm-remote-jupyter-ipy-access.md`

---

## 2. 一次性高频命令清单（Git / Linux / 环境）

> 去重后保留一份，可直接复制。

### 2.1 GCC/G++ 版本切换（update-alternatives）
```bash
sudo apt install gcc-10 g++-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```

### 2.2 Git 常用
```bash
# 新分支开发并推送
git checkout -b new-feature-branch
git add .
git commit -m "your message"
git push origin new-feature-branch

# 查看分支
git branch
git branch -r
git branch -a

# 创建并切换分支
git checkout -b <branch>

# 切换已有分支
git checkout <branch>

# 推送分支
git push origin <branch>

# 删除本地分支
git branch -d <branch>

# 删除远程分支
git push origin :<branch>

# 拉取
git pull
git pull <repo_url> <branch>

# 一条命令 add+commit+push
git add . && git commit -m "update" && git push

# 清除索引缓存
git rm -r --cached .

# 强制同步远程（谨慎）
git fetch --all && git reset --hard origin/main && git pull

# 回滚一次提交（保留历史）
git revert HEAD
git push origin master
```

### 2.3 Fork 协作（带 upstream）
```bash
git clone https://github.com/MitchellX/flash-attention.git
git remote add upstream https://github.com/Dao-AILab/flash-attention.git
git remote -v
git fetch upstream
git merge upstream/main
git push
```

### 2.4 服务器文件传输（scp / rsync）
```bash
# Linux -> Windows（示例）
scp user@host:/path/file.tar e:

# Windows -> Linux（示例）
scp -rp e:\scpdata root@10.1.22.5:/root

# 远程到本地
scp -r user@host:/remote/path /local/path

# 本地到远程
scp -r /local/path user@host:/remote/path

# 指定端口
scp -P 7022 ./nyu_v2.zip user@host:/remote/path

# 多文件
scp index.css json.js root@192.168.1.104:/usr/local/nginx/html/webs

# 多目录（花括号）
scp -r root@192.168.1.104:/usr/local/nginx/html/webs/\{index,json\} ./

# rsync（排除文件）
rsync -rvz -e 'ssh -p 22' --exclude='*.model' dir/ host:/dir

# rsync（跳过已存在且旧文件）
rsync -aWPu local/ root@host:remote/
```

### 2.5 系统信息 / 压缩 / GPU
```bash
# 系统版本
cat /etc/redhat-release
lsb_release -a
uname -a
rpm -q centos-release

# CPU
cat /proc/cpuinfo

# 磁盘
df -lh
du -lh

# GPU 监控
gpustat
watch -n 0.1 nvidia-smi
lspci | grep -i vga

# 查占用并释放 GPU
fuser -v /dev/nvidia*
nvidia-smi
kill -9 <pid>

# 指定 GPU
CUDA_VISIBLE_DEVICES=1 python your_file.py
CUDA_VISIBLE_DEVICES=0,1 python your_file.py

# tar 打包解压
tar -cvf data.tar /source
tar -xvf data.tar
tar -czvf data.tar.gz /source
tar -xzvf data.tar.gz
tar -cjvf data.tar.bz2 /source
tar -xjvf data.tar.bz2
```

### 2.6 代理/源/环境变量/虚拟环境
```bash
# 禁用代理
unset https_proxy
unset http_proxy

# 更新 apt 源
sudo apt-get update

# 环境变量（记得 source ~/.bashrc）
export PYTHONPATH=$PYTHONPATH:/your/path

# pip 国内源
pip install <pkg> -i https://pypi.tuna.tsinghua.edu.cn/simple

# conda 克隆环境
conda create -n BBB --clone AAA
conda create -n BBB --clone ~/path/to/env

# conda 新建 / 删除
conda create -n your_env_name python=3.10
conda remove -n your_env_name --all

# virtualenv
virtualenv --clear envs/test
source envs/test/bin/activate
deactivate
```

### 2.7 screen / tmux / 前后台
```bash
# screen
yum install -y screen
screen
screen -S <name>
screen -ls
screen -r <name>
screen -d -r
screen -X -S <name> quit

# tmux
yum install -y tmux
tmux new -s <name>
tmux ls
tmux attach -t <name>
tmux attach -d -t <name>
tmux kill-session -t <name>

# 前后台
jobs -l
bg
fg
kill <pid>
```

### 2.8 调试 / 常见小技巧
```bash
# ipdb
python -m ipdb your_code.py

# python 侵入式调试
import ipdb; ipdb.set_trace()

# 通配符 mv
mv *.* ./1000/
mv 6???.* ./6000/

# basename 去前缀与后缀
basename /a/b/c.jpg
basename /a/b/c.jpg .jpg

# 文件夹不存在则创建（shell）
if [ ! -d "/myfolder" ]; then mkdir /myfolder; fi
```

### 2.9 YouTube 下载与截取（notebook 风格）
```bash
pip3 install youtube-dl ffmpeg-python
youtube-dl <youtube_url> --merge-output-format mp4 -o /content/data/source_tmp.mp4
ffmpeg -y -i /content/data/source_tmp.mp4 -ss 00:01:40 -to 00:01:50 -r 25 /content/data/source.mp4
```

---

## 3. 全部脚本运行命令（可 Ctrl + F）

> 这一节覆盖仓库里可执行的 `.py/.sh`。  
> 一部分脚本是“硬编码路径”风格（没有 argparse），命令可直接跑，但通常需要先改脚本内路径变量。

### 3.1 `scripts/python/` 脚本

#### `scripts/python/PIL_draw.py`
```bash
python scripts/python/PIL_draw.py
```

#### `scripts/python/batch_move.py`
```bash
python scripts/python/batch_move.py
```

#### `scripts/python/convert_txt_format.py`
```bash
python scripts/python/convert_txt_format.py
```

#### `scripts/python/csv_gen.py`
```bash
python scripts/python/csv_gen.py
```

#### `scripts/python/delete_script.py`
```bash
python scripts/python/delete_script.py
```

#### `scripts/python/image_review.py`
```bash
python scripts/python/image_review.py
```

#### `scripts/python/to_excel.py`
```bash
python scripts/python/to_excel.py
```

#### `scripts/python/visualization_from_txt.py`
```bash
python scripts/python/visualization_from_txt.py
```

#### `scripts/python/visualization_match_biaozhuTeam.py`
```bash
python scripts/python/visualization_match_biaozhuTeam.py
```

### 3.2 SSIM 相关脚本（`calculate_ssim/`）

#### `calculate_ssim/align_ssim_celeba_ffhq.py`
```bash
python calculate_ssim/align_ssim_celeba_ffhq.py <dataset> <method> <dataset_src>
# 示例
python calculate_ssim/align_ssim_celeba_ffhq.py celeba fsgan CelebA/images
```

#### `calculate_ssim/align_ssim_forensics_vgg2.py`
```bash
python calculate_ssim/align_ssim_forensics_vgg2.py <dataset> <method> <dataset_src>
# 示例
python calculate_ssim/align_ssim_forensics_vgg2.py forensics simswap FaceForensics/original_sequences
```

#### `calculate_ssim/SSIM_quantitative.py`
```bash
python calculate_ssim/SSIM_quantitative.py
```

### 3.3 HeadPose 相关脚本（`calculate_headpose/`）

#### `calculate_headpose/demo_FSANET_ssd_celeba_ffhq.py`
```bash
python calculate_headpose/demo_FSANET_ssd_celeba_ffhq.py <dataset> <method>
# 示例
python calculate_headpose/demo_FSANET_ssd_celeba_ffhq.py celeba fsgan
```

#### `calculate_headpose/demo_FSANET_ssd_forensics_vgg2.py`
```bash
python calculate_headpose/demo_FSANET_ssd_forensics_vgg2.py <dataset> <method>
# 示例
python calculate_headpose/demo_FSANET_ssd_forensics_vgg2.py forensics simswap
```

#### `calculate_headpose/headpose_quantitative.py`
```bash
python calculate_headpose/headpose_quantitative.py
```

### 3.4 Google Drive 下载脚本（`google_drive_downloader/`）

#### `google_drive_downloader/gdrive_downloader.py`
```bash
python google_drive_downloader/gdrive_downloader.py <drive_file_id> <destination_file_path>
# 示例
python google_drive_downloader/gdrive_downloader.py 1XxbBesX4SjXGrXOCDuju9AqCr7BrqDpa ./datasets/datasets.zip
```

#### `google_drive_downloader/download_datasets.py`
```bash
python google_drive_downloader/download_datasets.py
```

#### `google_drive_downloader/download_gdrive.py`
```bash
# 作为模块被 import 使用；也可以在其他脚本里调用：
# from download_gdrive import download_file_from_google_drive
```

### 3.5 Shell 脚本

#### `scripts/shell/run.sh`
```bash
bash scripts/shell/run.sh
```

#### `scripts/shell/copytxt.sh`
```bash
bash scripts/shell/copytxt.sh
```

#### `scripts/shell/rename.sh`
```bash
bash scripts/shell/rename.sh
```

#### `scripts/shell/doas-install.sh`
```bash
bash scripts/shell/doas-install.sh -h
bash scripts/shell/doas-install.sh -e us -y
bash scripts/shell/doas-install.sh --scm -e cn
```

---

## 4. 速查：关键词索引

为了 `Ctrl + F`，这里列常搜关键词（含新目录路径）：

- `git fetch --all && git reset --hard origin/main && git pull`
- `rsync -aWPu`
- `CUDA_VISIBLE_DEVICES`
- `screen -d -r`
- `tmux attach -d -t`
- `python calculate_ssim/align_ssim_celeba_ffhq.py`
- `python calculate_headpose/demo_FSANET_ssd_forensics_vgg2.py`
- `python scripts/python/visualization_from_txt.py`
- `bash scripts/shell/run.sh`
- `python google_drive_downloader/gdrive_downloader.py`
- `youtube-dl`
- `ffmpeg -ss -to`

---

当前重组已完成；后续如果你想再做“按任务域二级拆分”（例如 `scripts/face_landmark/`, `scripts/metrics/`, `scripts/io/`），可以继续迭代。
