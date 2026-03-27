# Record Commands & Scripts

一个用于沉淀「常用命令 + 常用脚本」的仓库。  
This repo collects frequently used Linux/Git/Python command snippets and small utility scripts.

---

## Repo Reorg (2026-03)

为了减少根目录杂乱、避免 README 重复内容，本次做了以下整理：

- `docs/notes/`：统一存放历史笔记类 `.md` 文件。
- `scripts/shell/`：统一存放 `.sh` 脚本。
- `scripts/python/`：统一存放根目录下的独立 Python 工具脚本。
- 保留原有专题子目录：
  - `calculate_ssim/`
  - `calculate_headpose/`
  - `google_drive_downloader/`

---

## Quick Index

### 1) Git 常用

```bash
# 创建并切换分支
git checkout -b <branch>

# 一条命令 add + commit + push
git add . && git commit -m "update" && git push

# 强制同步远端（谨慎）
git fetch --all && git reset --hard origin/main && git pull

# 回滚最近一次提交（保留历史）
git revert HEAD && git push origin <branch>
```

### 2) 文件传输（scp / rsync）

```bash
# 远程 -> 本地
scp -r user@host:/remote/path /local/path

# 本地 -> 远程
scp -r /local/path user@host:/remote/path

# 指定端口
scp -P 7022 file.zip user@host:/remote/path

# 断点友好同步
rsync -aWPu local_dir/ user@host:/remote_dir/
```

### 3) 压缩与解压（tar）

```bash
# 打包（不压缩）
tar -cvf archive.tar /source

# gzip 压缩
tar -czvf archive.tar.gz /source

# 解压
tar -xvf archive.tar
tar -xzvf archive.tar.gz
```

### 4) GPU / 进程排查

```bash
# 实时看 GPU
watch -n 0.1 nvidia-smi

# 查占用 GPU 的进程
fuser -v /dev/nvidia*

# 杀进程
kill -9 <pid>

# 指定 GPU 运行
CUDA_VISIBLE_DEVICES=0 python your_script.py
```

### 5) 环境与调试

```bash
# conda 克隆环境
conda create -n BBB --clone AAA

# 使用清华源安装 pip 包
pip install <pkg> -i https://pypi.tuna.tsinghua.edu.cn/simple

# ipdb 调试
python -m ipdb your_code.py
```

---

## Tips

### 切换 gcc/g++ 版本（update-alternatives）

```bash
sudo apt install gcc-10 g++-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```

### shell / python 路径处理

```bash
# shell
basename "$path"
basename "$path" .jpg
```

```python
import os
name = os.path.splitext(os.path.basename(target_path))[0]
```

---

## Notes & Scripts

- 历史笔记：`docs/notes/`
- Shell 脚本：`scripts/shell/`
- Python 脚本：`scripts/python/`
- SSIM 相关：`calculate_ssim/`
- Head pose 相关：`calculate_headpose/`
- Google Drive 下载工具：`google_drive_downloader/`

---

## TODO

- [ ] 给每个 Python 脚本补充用法示例（输入参数、输出文件、依赖）。
- [ ] 为 `scripts/` 增加统一 CLI 入口（可选：`argparse` + `Makefile`）。
- [ ] 将高频命令按「场景」拆成独立文档（Git / Linux / DeepLearning）。
