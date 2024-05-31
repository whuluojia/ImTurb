# ImTurb  
Implementation of the paper: Deformation-aware image restoration from atmospheric turbulence based on quasiconformal geometry and pulse-coupled neural network 

![demostration of experimental results](https://github.com/whuluojia/ImTurb/blob/main/Door__.gif）
# Abstract  
Atmospheric turbulence is a major factor in image degradation issues such as blurring, distortion and intensity fluctuations when monitoring long-range targets. The randomness, spatiotemporal variation and perturbations of turbulence make it challenging to restore vision-friendly and credible images from degraded image sequences. In this work, we address the problem by proposing a deformation-aware image restoration algorithm based on quasiconformal geometry and pulse-coupled neural network (PCNN). To accurately measure the magnitude of geometric deformation caused by turbulence, the deformation within degraded images is specified in a non-conformal distortion that disrupts local geometry. The Beltrami coefficient uniquely associated with the quasiconformal maps is applied to quantify the average distortion degree. The deformation-aware measurement minimizes registration errors in aligning degraded images by more reliable reconstruction of reference frames. Additionally, an improved PCNN model inspired by the primary visual cortex is developed to boost the perceptual quality of the restored image with lucky image fusion. The absence of manual parameter tuning and the ability to simultaneously process image sequences in the PCNN model enhance the robustness of the restoration algorithm. The performance of our algorithm is validated by experiments on physically simulated and real data, which contain 220 sequences with 22928 frames. The results show that our algorithm can yield a superior restoration through atmospheric turbulence compared with several state-of-the-art methods.  

![image](https://github.com/whuluojia/ImTurb/blob/main/Fig2_diagram.png)
Diagram of the proposed image restoration algorithm from atmospheric turbulence  
![image](https://github.com/whuluojia/ImTurb/blob/main/Figure3.jpg)  
Illustration of the geometric deformation measurement in images degraded by atmospheric turbulence  
![image](https://github.com/whuluojia/ImTurb/blob/main/Table1.jpg)

Data avaliability  
The Heat Chamber Dataset can be downloaded from: 
https://drive.google.com/file/d/14iVachB95bCCtke8ONPD9CCH20JO75v2/view?usp=sharing    
Open Turbulent Image Set (OTIS) can be downloaded from: https://zenodo.org/communities/otis/  
Hirsh's dataset can be downloaded from:
https://pui-nantheera.github.io/research/Heathaze/CLEAR.html



