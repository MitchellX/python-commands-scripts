import PIL.Image as Image
import os
import glob

# 定义图像拼接函数 raw * column
def image_compose(image_names, row, column, result_path):
    img_total = Image.new('RGB', (column * width, row * height))  # 创建一个新图
    # 循环遍历，把每张图片按顺序粘贴到对应位置上
    i, j = 0, 0
    for image_name in image_names:
        image_path = IMG_FOLDER + image_name
        # occlude the marks
        if 'mask' in image_name:
            continue

        image = Image.open(image_path)
        image = image.resize((width, height))

        # draw the sub image
        img_total.paste(image, (i * width, j * height))
        i += 1
        if i == column:
            j += 1
            i = 0

        src_name = image_name[:-4].split('-')[0]
        tag_name = image_name[:-4].split('-')[1]

        # 判断是否存在文件夹如果不存在则创建为文件夹
        if not os.path.exists(OUT_FOLDER):
            os.makedirs(OUT_FOLDER)
        # 存储对应图片名的文件pair.txt
        with open(OUT_FOLDER + 'results.txt', 'a') as f:   # 没有文件则创建，添加写
            f.write(src_name)
            f.write('\t')
            f.write(tag_name)
            f.write('\n')

    return img_total.save(result_path)  # 保存新图


if __name__ == '__main__':
    # 因为视频是9：16的，所以建议按照这个比例
    height = 270
    width = 480
    IMG_FOLDER = 'D:\\cvpr_result\\forensics\\c3net_wo_blending\\'
    OUT_FOLDER = 'D:\\cvpr_result\\forensics\\pair_results\\'
    if os.path.exists(OUT_FOLDER + "results.txt"):
        os.remove(OUT_FOLDER + "results.txt")

    # read all the images in this folder
    image_names = os.listdir(IMG_FOLDER)
    row = 5
    column = 5
    # draw i张 graphs
    for i in range(len(image_names) // row * column):
        result_path = os.path.join(OUT_FOLDER, '{}.png'.format(i))
        # each graph has row*column张 subImage
        # 因为一张图，对应一张mask所以这里可以简单乘2,即可排除掉mask带来的数量的影响
        image_compose(image_names[i * row * column * 2: (i + 1) * row * column * 2], row, column, result_path)

