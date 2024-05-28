clc
close all
clear all
addpath(genpath('example'));
addpath(genpath('mycode'));
addpath(genpath('flowColorCode'));

static1 = mat2gray((imread('gt.jpg')));
moving1 = mat2gray((imread('0.png')));


static = imresize(rgb2gray(static1),[300 300]);
moving = imresize(rgb2gray(moving1),[300 300]);


tic

[height,width]= size(moving);
[x,y] = meshgrid(0:height-1, 0:width-1);
vertex = [x(:),y(:),1+0*x(:)]; % 顶点 
face = delaunay(x(:),y(:));  % 三角格网剖分的三角形

DT = delaunayTriangulation(x(:),y(:));

[IC,r] = incenter(DT);
% figure;
% triplot(DT)

[map,map_mu,register] = my_QCIR(moving,static,'plot',1,'level',4);





