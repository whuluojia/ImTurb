% Deformation-aware image restoration from atmospheric turbulence
% based on quasiconformal geometry and pulse-coupled neural network
% Created by Nantheera Anantrasirichai,  Wuhan University
% 20/05/2024 yinjie0522@whu.edu.cn

clc
close all
clear all

addpath(genpath('nsst_toolbox'));
addpath(genpath('batud'));
addpath(genpath('optical_flow'));
addpath(genpath('SGL'));

dirnameroot = 'D:\论文\湍流图像重建\湍流数据集\img\static\Door\';
dirname = dirnameroot;
extfile = 'png';
startFrame = 1;
totalFrame = length(dir([dirnameroot,'*.',extfile]));
% -------------------------------------------------------------------------
% 参数
% -------------------------------------------------------------------------
resizeRatio = 1.0;
doFrameSelection = true;   % true if i) speed up, ii) need stabilisation
doPostprocess = true;      % true - sharpening and denoising;
doEnhance = true;           % false;

mseGain = 1;
gradGain1 = 1;
gradGain2 = 1;
infoGain2 = 20;

levels = 4;

numFrameRegis = 100;
maxFrameused = 50;
clipLimit = 0.002;
useBigAreaInfo = false;     % true;

%% 读入输入
[input, inputU, inputV] = loadInput(dirname, extfile,startFrame, totalFrame, resizeRatio);

input = imresize(input,0.5);

disp('Done read inputs')

avgFrame = findRefFrame(input, refFrameType);

%%  执行自适应帧选择

selected = adapttive(avgFrame, input, rangei, rangej, rangek, totalFrame, mseGain, gradGain1, 0);


%% 执行SGL视频稳像

[u1,Time1] = SobLap4video(input);

%% 执行光流配准

ref = mean(abs(u1),3);
registed = optical_flow(ref,abs(u1));

%% 执行NSST-PAMCPCNN序列图像融合

fused = pamcpcnn_fusion(registed);

%% 执行batud 盲卷积

zrest = batud(fused);

%% 对比度增强

if doEnhance
    zrest = adapthisteq(uint8(zrest), 'clipLimit',clipLimit);
end
% -------------------------------------------------------------------------
% final result
% -------------------------------------------------------------------------
zrest = imresize(zrest,[size(input(:,:,1),1),size(input(:,:,1),2)]);
figure; imshow([input(:,:,1),zrest]); title('退化图像和重建图像');

% muxin1 = zrest;
% save jupter1.mat muxin1
if ~isempty(inputU)
    zrest(:,:,2) = mean(inputU,3);
    zrest(:,:,3) = mean(inputV,3);
    zrest = ycbcr2rgb(uint8(zrest));
end
if strcmp(fusionMethod, 'pixel')
    imwrite(uint8(zrest), 'results\fusionResultPixel.png','png');
else
    imwrite(uint8(zrest), 'results\fusionResultRegion.png','png');
end