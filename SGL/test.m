
clear all
close all
clc

% videoSource = VideoReader('D:\论文\湍流图像重建\结果\论文\0_源数据制作\airplane1.avi');
% i = 0;
% while hasFrame(videoSource)
%     i=i+1;
%     video(:,:,i) = double(rgb2gray(readFrame(videoSource)));
% end

load scene31_f.mat
for i =1:80
    
video1(:,:,i) = imresize(squeeze(s_move(:,:,1,i)),[400 400]);
video2(:,:,i) = imresize(squeeze(s_move(:,:,2,i)),[400 400]);
video3(:,:,i) = imresize(squeeze(s_move(:,:,3,i)),[400 400]);
% video1 = squeeze(s_move(:,:,1,:));
% video2 = squeeze(s_move(:,:,2,:));
% video3 = squeeze(s_move(:,:,3,:));


end
% video =reshape(S,[256,256,100]);




[u1,Time1] = SobLap4video(video1);
[u2,Time2] = SobLap4video(video2);
[u3,Time3] = SobLap4video(video3);
% u = cat(3,u1,u2,u3);
figure;
mean_u = mean(video1,3);

for i = 1:80
%     u4(:,:,1) = mat2gray(abs(u1(:,:,i)));
%     u4(:,:,2) = mat2gray(abs(u2(:,:,i))); 
    u = abs(u2(:,:,i));
    Rmatch = imhist(video2(:,:,i));
    u = histeq(u,Rmatch);
%     u4(:,:,3) = mat2gray(abs(u3(:,:,i)));
    subplot(221);imshow(video2(:,:,i),[]);
    subplot(222);imshow(u,[]);
    subplot(223);imshow(mean_u,[]);
    pause(0.1);
%     u(:,:,:,i) = u4;
end
save scene_u.mat u