
clc
close all
clear all

img = rgb2gray(imread('15_SG flow 方法.bmp'));

[u,Time] = SobLap4img(img);

figure;
subplot(121);imshow(img,[]);
subplot(122);imshow(u,[]);

function [u,Time] = SobLap4img(image)
% This code reproduces the results from the article:
%
% Y. Lou, S.H. Kang, S. Soatto and A. L. Bertozzi, "Video stabilization of atmospheric turbulence distortion."
% Inverse Problems in Imaging, Special Issue in honor of Tony Chan,7(3), pp. 839 - 861, August 2013.
% https://sites.google.com/site/louyifei/research/turbulence
% 
% It processes a video sequence and outputs another sequence 
%
% Please email louyifei@gmail.com for any questions. 

tic
% parameters 
maxIter =70;
alpha = 20; lambda =10; mu = 1; dt = 1;
[M,N]=size(image);

%% compute norm of gradient at u0
D = zeros(M,N);
for m = 1:M
    for n = 1:N
        D(m,n) = sin(pi*(n-1)/N)^2+sin(pi*(m-1)/M)^2;
    end
end


f = image; G =fft2(f);
normGradu0 = abs(sum(sum(D.*conj(G).*G)));



%% start iterations
u = image; 
uhat = u;


uhat=fft2(u);


for it = 1:maxIter
   
    
    if it>2 && abs(tmp-er(it-2))<5e-3
        break;
    end
 
    tmp = 0; 

        f = uhat; 
        normGradu =  abs(sum(sum(D.*conj(f).*f)));
        const = normGradu/normGradu0-alpha;
        
        tmp = tmp+const; 
        
        
        uhat = (uhat.*(1-const*dt*4*D./(1+4*lambda*D))+dt*mu*(uhat+uhat))...
            ./(1+2*dt*mu);
     
       
     er(it)=tmp;
    
                     
end

    u = ifft2(uhat);

Time = toc;
end
