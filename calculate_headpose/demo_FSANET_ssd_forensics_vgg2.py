import os
import cv2
import sys

sys.path.append('..')
import numpy as np
from math import cos, sin
# from moviepy.editor import *
from lib.FSANET_model import *
import numpy as np
from keras.layers import Average


# from moviepy.editor import *
# from mtcnn.mtcnn import MTCNN

def draw_axis(img, yaw, pitch, roll, tdx=None, tdy=None, size=50):
    print(yaw, roll, pitch)
    pitch = pitch * np.pi / 180
    yaw = -(yaw * np.pi / 180)
    roll = roll * np.pi / 180

    if tdx != None and tdy != None:
        tdx = tdx
        tdy = tdy
    else:
        height, width = img.shape[:2]
        tdx = width / 2
        tdy = height / 2

    # X-Axis pointing to right. drawn in red
    x1 = size * (cos(yaw) * cos(roll)) + tdx
    y1 = size * (cos(pitch) * sin(roll) + cos(roll) * sin(pitch) * sin(yaw)) + tdy

    # Y-Axis | drawn in green
    #        v
    x2 = size * (-cos(yaw) * sin(roll)) + tdx
    y2 = size * (cos(pitch) * cos(roll) - sin(pitch) * sin(yaw) * sin(roll)) + tdy

    # Z-Axis (out of the screen) drawn in blue
    x3 = size * (sin(yaw)) + tdx
    y3 = size * (-cos(yaw) * sin(pitch)) + tdy

    cv2.line(img, (int(tdx), int(tdy)), (int(x1), int(y1)), (0, 0, 255), 3)
    cv2.line(img, (int(tdx), int(tdy)), (int(x2), int(y2)), (0, 255, 0), 3)
    cv2.line(img, (int(tdx), int(tdy)), (int(x3), int(y3)), (255, 0, 0), 2)

    return img


def draw_results_ssd(detected, input_img, faces, ad, img_size, img_w, img_h, model, time_detection, time_network,
                     time_plot):
    # loop over the detections
    if detected.shape[2] > 0:
        for i in range(0, detected.shape[2]):
            # extract the confidence (i.e., probability) associated with the
            # prediction
            confidence = detected[0, 0, i, 2]

            # filter out weak detections
            if confidence > 0.5:
                # compute the (x, y)-coordinates of the bounding box for
                # the face and extract the face ROI
                (h0, w0) = input_img.shape[:2]
                box = detected[0, 0, i, 3:7] * np.array([w0, h0, w0, h0])
                (startX, startY, endX, endY) = box.astype("int")
                # print((startX, startY, endX, endY))
                x1 = startX
                y1 = startY
                w = endX - startX
                h = endY - startY

                x2 = x1 + w
                y2 = y1 + h

                xw1 = max(int(x1 - ad * w), 0)
                yw1 = max(int(y1 - ad * h), 0)
                xw2 = min(int(x2 + ad * w), img_w - 1)
                yw2 = min(int(y2 + ad * h), img_h - 1)

                faces[i, :, :, :] = cv2.resize(input_img[yw1:yw2 + 1, xw1:xw2 + 1, :], (img_size, img_size))
                faces[i, :, :, :] = cv2.normalize(faces[i, :, :, :], None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX)

                face = np.expand_dims(faces[i, :, :, :], axis=0)
                p_result = model.predict(face)

                face = face.squeeze()

                # print(p_result[0][0], p_result[0][1], p_result[0][2])

                # img = draw_axis(input_img[yw1:yw2 + 1, xw1:xw2 + 1, :], p_result[0][0], p_result[0][1], p_result[0][2])

                # input_img[yw1:yw2 + 1, xw1:xw2 + 1, :] = img
                break

    # cv2.imshow("result", input_img)
    try:
        return input_img, [p_result[0][0], p_result[0][1], p_result[0][2]]  # ,time_network,time_plot
    except:
        return


class FSAnet:
    # def __init__(self, input_img, nums):
    #     self.input_img = input_img
    #     self.nums = nums

    try:
        os.mkdir('./img')
    except OSError:
        pass

    # face_cascade = cv2.CascadeClassifier('lbpcascade_frontalface_improved.xml')
    # detector = MTCNN()

    # load model and weights
    img_size = 64
    stage_num = [3, 3, 3]
    lambda_local = 1
    lambda_d = 1
    img_idx = 0
    detected = ''  # make this not local variable
    time_detection = 0
    time_network = 0
    time_plot = 0
    skip_frame = 1  # every 5 frame do 1 detection and network forward propagation
    ad = 0.6

    # Parameters
    num_capsule = 3
    dim_capsule = 16
    routings = 2
    stage_num = [3, 3, 3]
    lambda_d = 1
    num_classes = 3
    image_size = 64
    num_primcaps = 7 * 3
    m_dim = 5
    S_set = [num_capsule, dim_capsule, routings, num_primcaps, m_dim]

    model1 = FSA_net_Capsule(image_size, num_classes, stage_num, lambda_d, S_set)()
    model2 = FSA_net_Var_Capsule(image_size, num_classes, stage_num, lambda_d, S_set)()

    num_primcaps = 8 * 8 * 3
    S_set = [num_capsule, dim_capsule, routings, num_primcaps, m_dim]

    model3 = FSA_net_noS_Capsule(image_size, num_classes, stage_num, lambda_d, S_set)()

    print('Loading models ...')

    weight_file1 = '../pre-trained/300W_LP_models/fsanet_capsule_3_16_2_21_5/fsanet_capsule_3_16_2_21_5.h5'
    model1.load_weights(weight_file1)
    print('Finished loading model 1.')

    weight_file2 = '../pre-trained/300W_LP_models/fsanet_var_capsule_3_16_2_21_5/fsanet_var_capsule_3_16_2_21_5.h5'
    model2.load_weights(weight_file2)
    print('Finished loading model 2.')

    weight_file3 = '../pre-trained/300W_LP_models/fsanet_noS_capsule_3_16_2_192_5/fsanet_noS_capsule_3_16_2_192_5.h5'
    model3.load_weights(weight_file3)
    print('Finished loading model 3.')

    inputs = Input(shape=(64, 64, 3))
    x1 = model1(inputs)  # 1x1
    x2 = model2(inputs)  # var
    x3 = model3(inputs)  # w/o
    avg_model = Average()([x1, x2, x3])
    model = Model(inputs=inputs, outputs=avg_model)

    # load our serialized face detector from disk
    print("[INFO] loading face detector...")
    protoPath = os.path.sep.join(["face_detector", "deploy.prototxt"])
    modelPath = os.path.sep.join(["face_detector",
                                  "res10_300x300_ssd_iter_140000.caffemodel"])
    net = cv2.dnn.readNetFromCaffe(protoPath, modelPath)

    print('Start detecting pose ...')
    detected_pre = np.empty((1, 1, 1))

    def calculate(self, input_img, number=0):

        skip_frame = self.skip_frame
        net = self.net
        detected_pre = self.detected_pre

        img_idx = number
        img_h, img_w, _ = np.shape(input_img)

        if img_idx == 1 or img_idx % skip_frame == 0:
            time_detection = 0
            time_network = 0
            time_plot = 0

            # detect faces using LBP detector
            gray_img = cv2.cvtColor(input_img, cv2.COLOR_BGR2GRAY)
            # detected = face_cascade.detectMultiScale(gray_img, 1.1)
            # detected = detector.detect_faces(input_img)
            # pass the blob through the network and obtain the detections and
            # predictions
            blob = cv2.dnn.blobFromImage(cv2.resize(input_img, (300, 300)), 1.0,
                                         (300, 300), (104.0, 177.0, 123.0))
            net.setInput(blob)
            detected = net.forward()

            if detected_pre.shape[2] > 0 and detected.shape[2] == 0:
                detected = detected_pre

            faces = np.empty((detected.shape[2], self.img_size, self.img_size, 3))
            try:

                input_img, eular_angles = draw_results_ssd(detected, input_img, faces, self.ad, self.img_size, img_w, img_h, self.model,
                                             time_detection,
                                             time_network, time_plot)
            except:
                return

            # cv2.imwrite('img/' + str(img_idx) + '.png', input_img)

        else:
            input_img, eular_angles = draw_results_ssd(self.detected, input_img, self.faces, self.ad, self.img_size, img_w, img_h,
                                         self.model, self.time_detection,
                                         self.time_network, self.time_plot)

        if detected.shape[2] > detected_pre.shape[2] or img_idx % (skip_frame * 3) == 0:
            detected_pre = detected

        key = cv2.waitKey(1)
        return eular_angles


# -------------------------------- Mitchell: for single image head pose estimation -----------------------------
if __name__ == '__main__':
    dataset = sys.argv[1]
    method = sys.argv[2]

    flag = 0
    if dataset == "forensics":
        flag = 1

    # input_img = cv2.imread('/home/xiangmingcan/notespace/cvpr_data/celeba/11663.jpg')
    src = "/home/xiangmingcan/notespace/cvpr_data/" + dataset
    tgt = "/home/xiangmingcan/notespace/cvpr_result/" + dataset + '/' + method

    save_log = os.path.join("headPose/", dataset, method + ".txt")

    path = os.path.join("headPose/", dataset)
    if not os.path.exists(path):
        os.makedirs(path)

    logFile = open(save_log, 'w')

    img_list = os.listdir(tgt)
    sorted(img_list)

    fsanet = FSAnet()


    for input_img in img_list:
        if '_mask' in input_img:
            continue


        try:
            refer_img = input_img.split('-')[1]
            if flag:
                refer_img = refer_img[:-3] + "png"


        except:
            print("img1_name = img2_name.split('-')[1]")
            print("IndexError: list index out of range")
            continue

        refer_img_folder = refer_img.split('_')[0]
        refer_img = refer_img.split(refer_img_folder)[1][1:]

        result_cv2 = cv2.imread(os.path.join(tgt, input_img))
        refer_cv2 = cv2.imread(os.path.join(src, refer_img_folder, refer_img))

        # 如果读出来的img不存在，则删去
        if refer_cv2 is None or refer_cv2 is None:
            continue

        # result image 的欧拉角
        eular_angles_result = fsanet.calculate(result_cv2)
        print(eular_angles_result)

        # reference image 的欧拉角
        eular_angles_refer = fsanet.calculate(refer_cv2)
        print(eular_angles_refer)

        if eular_angles_result is None or eular_angles_refer is None:
            continue

        vec1 = np.array(eular_angles_result)
        vec2 = np.array(eular_angles_refer)

        distance = np.linalg.norm(vec1 - vec2)
        print(distance)
        print('\n')

        logFile.write(str(distance))
        logFile.write('\n')

    logFile.close()
