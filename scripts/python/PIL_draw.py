import cv2
import os
import numpy as np
from PIL import Image, ImageFont, ImageDraw # 导入模块

def draw_single_pic(image, txt):
    # cv2读有中文路径的图片
    im = Image.open(image)
    draw = ImageDraw.Draw(im)

    with open(txt) as f:
        num = f.readline()
        print(num)
        cnt = 1
        for i in range(106):
            num = f.readline()
            x = int(num.split(' ')[0])
            y = int(num.split(' ')[1])
            fontsize = 8
            font = ImageFont.truetype("arial.ttf", fontsize)
            draw.text((x, y), str(cnt), fill=(0, 255, 255), font=font)  # 利用ImageDraw的内置函数，在图片上写入文字
            cnt += 1

            # 黄色(0, 255, 255)        猩红色(220, 20, 60)   绿色	(113, 179, 60)      纯绿(0,255,0)
    return im


if __name__ == '__main__':
    img = draw_single_pic('陈赫_mask_0_0_0.jpg', '陈赫_mask_0_0_0.jpg.txt')
    img.save('digits.jpg')
