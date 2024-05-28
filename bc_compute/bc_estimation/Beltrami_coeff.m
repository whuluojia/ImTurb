function [local_area_distoration,local_angle_distoration]= Beltrami_coeff(static,moving)
%% 计算输入图像与参考图像之间的Beltrami coefficient 贝尔特拉米系数
%% 该系数能衡量输入图像相对于参考图像几何畸变程度
% 涉及的函数有：serach_KAZE.m  //  vertex_search.m  //
% 和lbs_rect.m  // close_curve_division.m  // generalized_laplacian2D.m
% 

% 通过KAZE计算两幅图像之间的角点 并找到对应的匹配点
[target,landmark] = search_KAZE(static,moving);

%生成三角格网 和顶点
[face,vertex] = image_meshgen(size(static,1),size(static,2));  

dimension = size(static);
% 避免landmark 位于同一个格网内的情况
if size(landmark,2) == 2
    landmark = vertex_search(landmark,vertex);
end

if size(landmark,1) ~= size(target,1)
	error('Please check landmark & target input!');
end
% 确保输入图像与参考图像尺寸一致
if (sum(size(moving)-size(static))~=0)
    moving = imresize(moving,size(static),'bicubic');
end

mu = 0*face(:,1);

corner = vertex_search([...
        min(vertex(:,1)),min(vertex(:,2));
        max(vertex(:,1)),min(vertex(:,2));
        max(vertex(:,1)),max(vertex(:,2));
        min(vertex(:,1)),max(vertex(:,2))],vertex);

% 在矩形域中重建拟共形映射，并获得对应的贝尔特拉米系数
% map为拟共形映射图   update_X^
[map,update_mu] = lbs_rect(face,vertex,mu,'Landmark',landmark,...
    'Target',target,'Corner',corner,'Height',dimension(1),'Width',dimension(2));

% 局部的面积失真程度
local_area_distoration = (1+update_mu).*(1-update_mu);

%局部的角度失真程度
local_angle_distoration = (1+update_mu)./(1-update_mu);

end