This code is for Abosorbing Markov Chain Trakcer which is introduced in

"Superpixel-based Tracking-by-Segmentation using Markov Chains." CVPR (2017).
Donghun Yeo, Jeany Son, Bohyung Han, Joonhee Han.

To run code for tracking.

  RunCode_Tracking_Batch.m 
  
The input and output file paths are written in 

  RunCode_VAMC.m
  
Input frame and ground truth are located in each folder as image files in the order of frame number.
You must use the same names for input and ground truth corresponding to the same frame.
I recemmend you to set the frame name as frame number, for example, 00001.jpg, 00002.jpg ... 02038.jpg.

Datasets are given by the following link:
https://postechackr-my.sharepoint.com/:u:/g/personal/hanulbog_postech_ac_kr/EfG9ZHNePRJBhEgGPHtpamUBS0yCjDoJLSRYzDbG0wgJVw?e=R8eFsW

DAVIS dataset is not included please download the DAVIS dataset from official page and change the directories as the following structures.

Image path:
ImageRootName/VideoName/FrameName

GT path:
GTRootName/VideoName/FrameName

  Any questions are welcome.


Should-be-updated lists.

This code is not completed without CNN extraction feature code which is in
https://github.com/wasidennis/ObjectFlow


We will add the code.
