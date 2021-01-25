import pytorch_ssim
import torch
from torch.autograd import Variable
import cv2
import os
import sys


def function():
    src = os.path.join("/export2/data/", dataset_src)
    tgt = os.path.join("/export2/data/cvpr_result/alignment", dataset, method)

    flag = 0
    if dataset_src == 'FFHQ/images1024x1024_align':
        flag = 1

    save_log = os.path.join("cvpr_results_align/", dataset, method + ".txt")

    path = os.path.join("cvpr_results_align/", dataset)
    if not os.path.exists(path):
        os.makedirs(path)

    img_list = os.listdir(tgt)

    logFile = open(save_log, 'w')

    for img2_name in img_list:
        if '_mask' in img2_name:
            continue

        try:
            img1_name = img2_name.split('-')[1]
            if flag:
                img1_name = img1_name[:-3] + "png"


        except:
            print("img1_name = img2_name.split('-')[1]")
            print("IndexError: list index out of range")
            continue

        img1 = cv2.imread(os.path.join(src, img1_name))
        img2 = cv2.imread(os.path.join(tgt, img2_name))

        img1 = torch.from_numpy(img1).float().unsqueeze(0).cuda()
        img2 = torch.from_numpy(img2).float().unsqueeze(0).cuda()

        ssim = pytorch_ssim.ssim(img1, img2)
        ssim = ssim.item()
        print("{} SSIM is: {}".format(img2_name, ssim))
        logFile.write(str(ssim))
        logFile.write('\n')

    logFile.close()


if __name__ == '__main__':
    # 第一个参数是数据集的名称如：celeba
    # 第二个参数是方法名称如：fsgan
    dataset = sys.argv[1]
    method = sys.argv[2]
    dataset_src = sys.argv[3]
    function()
