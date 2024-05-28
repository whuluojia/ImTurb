clear all
close all
clc

workingDir = 'D:\论文\湍流图像重建\方法比较\SGL\Pattern7\';
imageNames = dir(fullfile(workingDir,'*.png'));
imageNames = {imageNames.name}';
K =length(imageNames );
for i = 1:K*0.1
    
   temp = imread(fullfile(workingDir,imageNames{i})); 
    video(:,:,i)=double(rgb2gray(temp)).*255;
end

u = Aniso4video(video);


function u =  Aniso4video(sequence)



maxIter =30;
alpha = 5; lambda = 5; mu = 1; dt = 1;
[M,N,K]=size(sequence);

for i = 1:K
      kkk(i) = calc_k(sequence(:,:,i));
end

out = sequence;

for i= 1:maxIter
  
    for j =2:K-1
        
       f = out(:,:,j);
    
       out(:,:,j) = sharpen1(f)+  out(:,:,j+1)+out(:,:,j-1)-2*out(:,:,j);
           
    
    end
    out(:,:,1) = sharpen1(out(:,:,1))+  out(:,:,j+1)-out(:,:,j);
    out(:,:,K) = sharpen1(out(:,:,1)) +out(:,:,j-1)-out(:,:,j);
end


u = (sequence - out)*2 + sequence;  
    
    
    
end

function x = sharpen1(img)

kk = calc_k(img);    
    
ss = grad_f1(img);

g = grad_f2(ss,kk);

gg = grad_f3(g,ss);

x = img + gg;

end


function ss = grad_f1(img)
    img = padarray(img,[1,1],0);
    [m,n] =size(img);    
    ss(:,:,1)  = img(1:m-2,2:n-1)-img(2:m-1,2:n-1);
    ss(:,:,2)  = img(2:m-1,2:n-1)-img(1:m-2,2:n-1);
    ss(:,:,3)  = img(2:m-1,2:n-1)-img(2:m-1,1:n-2);
    ss(:,:,4)  = img(2:m-1,1:n-2)-img(2:m-1,2:n-1);
end

function g = grad_f2(ss,K)

g(:,:,1) = 1./(1+(ss(:,:,1)/K).^2);
g(:,:,2) = 1./(1+(ss(:,:,2)/K).^2);
g(:,:,3) = 1./(1+(ss(:,:,3)/K).^2);
g(:,:,4) = 1./(1+(ss(:,:,4)/K).^2);

end


function gg = grad_f3(g,ss)

gg = 0.25*(ss(:,:,1).*g(:,:,1)+ss(:,:,2).*g(:,:,2)+ss(:,:,3).*g(:,:,3)+ss(:,:,4).*g(:,:,4));

end

function kkk = calc_k(img)

    mean_f = mean(img(:));
    std_f = std(img(:));
    kkk = 2*(mean_f/(0.75*std_f));   % 参数k

end