function  [target,landmark] = search_KAZE(img1,img2)
%% 采用KAZE对输入帧和参考帧寻找匹配点
% img1  参考帧
% img2  当前帧
points1 = detectKAZEFeatures(img1,'Diffusion','edge','Threshold',0.002,'NumScaleLevels',4 ,'ROI',[1 1 size(static,2) size(static,1)]);
points2 = detectKAZEFeatures(img2,'Diffusion','edge','Threshold',0.002,'NumScaleLevels',4 ,'ROI',[1 1 size(moving,2) size(moving,1)]);

[f1, vpts1] = extractFeatures(img1, points1); 
[f2, vpts2] = extractFeatures(img2, points2);
[indexPairs,matchMetric] = matchFeatures(f1, f2, 'Unique',true) ;

matched_pts1 = vpts1(indexPairs(:, 1));  
matched_pts2 = vpts2(indexPairs(:, 2));

% figure('name','result'); showMatchedFeatures(img1,img2,matched_pts1,matched_pts2,'montage'); 

target = double(matched_pts1.Location);

landmark = double(matched_pts2.Location);
end
