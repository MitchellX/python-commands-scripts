import pandas as pd
import os

image_list = []

# 这是你可以改的标注团队的文件夹名词
root = "106人脸-汇总数据-2390张\\"

folders = os.listdir(root)
folders.remove("images_draw")
for folder in folders:
    images = os.listdir(os.path.join(root, folder))
    images = sorted(images)
    for i in range(0, len(images), 2):
        image_list.append(images[i])

# 字典中的key值即为csv中列名
dataframe = pd.DataFrame({'图片名字': image_list})

# 将DataFrame存储为csv,index表示是否显示行名，default=True
dataframe.to_csv("test.csv", index=False, sep=',')
