import os


def convert_txt_format(src_txt, tgt_txt):
    # cv2读有中文路径的图片
    with open(src_txt) as f:
        num = f.readline()


    # 将txt中的数字转换为字符串列表
    num = num.split(",")
    num = num[4:]
    print(num.__len__())


    with open(tgt_txt, "w") as f:
        f.write("106\n")
        for i in range(0, len(num), 2):
            f.write(num[i])
            f.write(" ")
            f.write(num[i+1])
            f.write("\n")


if __name__ == '__main__':
    root = "E:\\Python-project\\mask\\images_by_det_face_info\\"
    cnt = 0

    for folder_name in os.listdir(root):
        for txt_name in os.listdir(os.path.join(root, folder_name)):
            src_txt = os.path.join(root, folder_name, txt_name)

            # 不存在写的目录，则新建目录
            write_folder = "E:\\Python-project\\mask\\images_txt\\"
            if not os.path.exists(os.path.join(write_folder, folder_name)):
                os.makedirs(os.path.join(write_folder, folder_name))

            convert_txt_format(src_txt, os.path.join(write_folder, folder_name, txt_name))
            cnt += 1
    print(cnt)
