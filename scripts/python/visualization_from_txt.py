import cv2
import os
import numpy as np

def draw_single_pic(image, txt):
    # img = cv2.imread("..\\mask\\images_by_det\\Angelababy\\Angelababy_mask_11_0_0.jpg")
    # with open("..\\mask\\images_by_det_face_info\\Angelababy\\Angelababy_mask_11_0_0.txt") as f:
    #     num = f.readline()

    # img = cv2.imread(image)
    # cv2读有中文路径的图片
    img = cv2.imdecode(np.fromfile(image, dtype=np.uint8), -1)
    with open(txt) as f:
        num = f.readline()

    # 将txt中的数字转换为字符串列表
    num = num.split(",")

    # python3 将str列表转换成int
    num = list(map(int, num))

    # x, y分别坐标
    num2 = num[4:]
    list_x = num2[::2]
    list_y = num2[1:][::2]
    z = list(zip(list_x, list_y))
    print(len(z))


    # 按照左上、右下的坐标画检测框
    cv2.rectangle(img, (num[0], num[1]), (num[2], num[3]), (0, 255, 0), 1)

    # 106 key points
    for point in z:
        cv2.circle(img, point, 2, (0,255,255), -1)

    # cv2.imwrite('output.jpg', img)
    return img


if __name__ == '__main__':
    root = "E:\\Python-project\\mask\\"
    image_folder = "images_by_det"
    txt_folder = "images_by_det_face_info"

    for folder in os.listdir(root + image_folder):
        for image_name in os.listdir(os.path.join(root, image_folder, folder)):
            image = os.path.join(root, image_folder, folder, image_name)
            txt_name = image_name.split(".jpg")[0] + '.txt'
            txt = os.path.join(root, txt_folder, folder, txt_name)

            # 不存在，则新建目录
            if not os.path.exists(os.path.join(root + "images_draw", folder)):
                os.makedirs(os.path.join(root + "images_draw", folder))

            # 画过图片了，则跳过
            write_path = os.path.join(root + "images_draw", folder, image_name)
            if os.path.exists(write_path):
                continue

            img = draw_single_pic(image, txt)
            cv2.imencode('.jpg', img)[1].tofile(write_path)
