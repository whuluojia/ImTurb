function cp =my_highpass_fuse2(img,t)
%% 采用的是PA-MCPCNN进行高频子图的融合
% 需要注意的是  逐帧处理的
[m,n,num] = size(img);
for i = 1:num
    % 多尺度形态学处理   图像边缘   图像聚焦测量
    Img(:,:,i) = abs(img(:,:,i));
    MSMG_A(:,:,i)=multiscale_morph(Img(:,:,i),t);
    %  归一化  将值归一化置 0~1 之间
    MSMG_A(:,:,i) = (MSMG_A(:,:,i)-  min(min(MSMG_A(:,:,i))) + 1)./ ...
        (max(max(MSMG_A(:,:,i))) - min(min(MSMG_A(:,:,i))) +2);
    % 执行参数自适应多通道PCNN    其中的连接强度采用MSMG边缘的聚焦测量
    
end
cp = mc_highpass_fuse (img,MSMG_A);

end