"""
@author: Mingcan Xiang (向明灿)
"""
import os

def delete_files(path):
    files_name = os.listdir(path)
    for name in files_name:
        if '_beauty.jpg' in name:
            os.remove(os.path.join(path, name))


# test
if __name__ == '__main__':
    path = r"E:\JDIntern\image_results\facebeauty_results\\"
    delete_files(path)