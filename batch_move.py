import os
import shutil
import glob


def move(src_file, tgt_dir):
    if not os.path.exists(tgt_dir):
        os.mkdir(tgt_dir)

    src_dir, file_name = os.path.split(src_file)
    tgt_file = os.path.join(tgt_dir, file_name)
    # 这里可以重命名file
    tgt_file = tgt_file[:-7] + 'txt'

    shutil.move(src_file, tgt_file)


if __name__ == '__main__':
    images = glob.glob('106人脸-汇总数据-2390张\\*\\*.txt')
    tgt_dir = 'testset_realMask\\landmark\\'

    for i in range(len(images)):
        move(images[i], tgt_dir)
