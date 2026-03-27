import cv2
import os
import numpy as np


def draw_single_pic(image, txt):
    # cv2读有中文路径的图片
    img = cv2.imdecode(np.fromfile(image, dtype=np.uint8), -1)

    with open(txt) as f:
        num = f.readline()
        print(num)
        for i in range(106):
            num = f.readline()
            # print((int(num.split(' ')[0]), int(num.split(' ')[1])))
            cv2.circle(img, (int(num.split(' ')[0]), int(num.split(' ')[1])), 1, (255, 0, 0), -1)

    # cv2.imwrite('output.jpg', img)
    return img


if __name__ == '__main__':
    # 这是你可以改的标注团队的文件夹名词
    file_name = "test01\\"
    root = os.path.join("E:\\Python-project\\mask\\team_biaozhu\\", file_name)

    # 不存在，则新建目录
    if not os.path.exists(os.path.join(root + "images_draw")):
        os.makedirs(os.path.join(root + "images_draw"))

    for folder in os.listdir(root):
        images = os.listdir(os.path.join(root, folder))
        images = sorted(images)
        for i in range(0, len(images), 2):
            img = draw_single_pic(os.path.join(root, folder, images[i]),
                                  os.path.join(root, folder, images[i+1]))

            # cv2保存文件，按照对应的目录格式
            write_path = os.path.join(root, "images_draw", folder)
            if not os.path.exists(write_path):
                os.makedirs(write_path)
            cv2.imencode('.jpg', img)[1].tofile(os.path.join(write_path, images[i]))
