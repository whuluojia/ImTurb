clc
close all
clear all
addpath(genpath('example'));
addpath(genpath('mfile'));
addpath(genpath('flowColorCode'));
addpath(genpath('mycode'));





static1 = mat2gray((imread('gt10.jpg')));
moving1 = mat2gray((imread('10.png')));


static = imresize(rgb2gray(static1),[224 224]);
moving = imresize(rgb2gray(moving1),[224 224]);


tic

[height,width]= size(moving);
[x,y] = meshgrid(0:height-1, 0:width-1);
vertex = [x(:),y(:),1+0*x(:)]; % 顶点 
face = delaunay(x(:),y(:));  % 三角格网剖分的三角形

DT = delaunayTriangulation(x(:),y(:));

[IC,r] = incenter(DT);
% figure;
% triplot(DT)

[map,map_mu,register,D] = my_QCIR(moving,static,'plot',1,'level',3);

%% 绘制形变场
x = map(:,1);
y = map(:,2);

x1 = reshape(x,[height width]);
y1 = reshape(y,[height width]);
% x1 = flipud(x1);
% y1 = flipud(y1);

resize = 14;

x2 = x1(1:resize:end,1:resize:end);

y2 = y1(1:resize:end,1:resize:end);
z2 = zeros(size(x2));
figure('Color', 'white');
mesh(x2,y2,z2,'EdgeColor',[64,150,190]/255,'FaceAlpha',0,'LineWidth',2);view(2);
axis square;axis off

figure;

imshow(flowToColor(D));
    
    %% Display estimated flow fields
%     figure;

Operator = createOperator(face,vertex);

vmu = Operator.f2v*map_mu;

mu2 = reshape(vmu,[height width]);
mu3 = abs(mu2);
figure;imshow(mu3,[]);colormap('parula');colorbar;

[mask,ximask,yimask]=roipoly;%手绘多边形特征点

hold on
plot(ximask,yimask,'bo-','LineWidth',2)%将点绘制在原图上
hold off
figure,imshow(mask)%显示roipoly 生成的掩膜
save mask.mat mask

mask(mask==0) = 1;
mask(mask==1) = 0.5;
% h = fspecial('gaussian', 3, 1);
% mask = imfilter(mask,h,'circular',"same");
mu4 = mu3.*mask;
figure;imshow(mu4,[]);colormap('parula');colorbar;

% figure;show_mesh(face,vertex,abs(map_mu));

save airport_2.mat mu2 map_mu maps


% img_11 = imresize(im2double(imread('airport_gt.png')),[224,224]);
% figure;imshow(img_11,[]);
% map2 = reshape(map(:,1:2),[224 224 2]);
% img12 = imwarp(img_11,D,'cubic');
% figure;imshow(img12,[])







