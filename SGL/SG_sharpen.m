clc
close all
clear all

image = rgb2gray(imread('1.png'));
% image = mat2gray((imread('D:\论文\湍流图像重建\湍流数据集\CLEAR数据集\distorted sequences\Hirsch_data\building\y_0020.png')));
% image = image(1:120,:);
maxIter =100;
alpha = 5; lambda = 1;

[M,N]=size(image);
%% compute norm of gradient at u0
D = zeros(M,N);
for m = 1:M
    for n = 1:N
        D(m,n) = sin(pi*(n-1)/N)^2+sin(pi*(m-1)/M)^2;
    end
end

G =fft2(image);
normGradu0 = abs(sum(sum(D.*conj(G).*G)));

uhat =G;

for it = 1:maxIter
    if it>2 && abs(tmp-er(it-2))<5e-3
        break;
    end
    
    tmp = 0;
    
    f = uhat;
    normGradu =  abs(sum(sum(D.*conj(f).*f)));
    const = normGradu/normGradu0-alpha;
    tmp = tmp+const;
    uhat = uhat.*(-const*4*D./(1+4*lambda*D))./2+uhat;
    er(it)=tmp;
end
u = ifft2(uhat);
w = fspecial('gaussian',[5,5]);
img= imfilter(image,w);
figure;
subplot(121);imshow(img,[]);
subplot(122);imshow(u,[]);
saveas(gcf,['sharpen1.jpg']);

