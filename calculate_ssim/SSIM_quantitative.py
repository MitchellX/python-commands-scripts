import os
import numpy as np

root = 'cvpr_results_align\\'
datasets = ['celeba', 'ffhq', 'forensics', 'vgg2']

write_log = open('ssim_results.txt', 'w')

for dataset in datasets:
    file_names = sorted(os.listdir(root + dataset))

    for file_name in file_names:
        with open(os.path.join(root, dataset, file_name)) as f:
            results = f.readlines()
            results = list(map(float, results))

            results_mean = np.mean(results)
            results_var = np.var(results)
            results_std = np.std(results)

            # write the logfile to save the results
            write_log.write(os.path.join(root, dataset, file_name) + ":\n")
            write_log.write("mean: " + str(results_mean) + '\n')
            write_log.write("var: " + str(results_var) + '\n')
            write_log.write("std: " + str(results_std) + '\n\n')

write_log.close()

