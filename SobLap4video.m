function [u,Time] = SobLap4video(video)
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
maxIter =40;
alpha = 3; lambda = 0.5; mu = 1; dt = 1;
[M,N,K]=size(video);

%% compute norm of gradient at u0
D = zeros(M,N);
for m = 1:M
    for n = 1:N
        D(m,n) = sin(pi*(n-1)/N)^2+sin(pi*(m-1)/M)^2;
    end
end

for k = 1:K
    f = video(:,:,k); G =fft2(f);
    normGradu0(k) = abs(sum(sum(D.*conj(G).*G)));
end


%% start iterations
u = video; 
uhat = u;

for k = 1:K
    uhat(:,:,k)=fft2(u(:,:,k));
end

for it = 1:maxIter
   
    
    if it>2 && abs(tmp-er(it-2))<5e-3
        break;
    end
      
 
    tmp = 0; 
    for k = 2:K-1
        f = uhat(:,:,k); 
        normGradu =  abs(sum(sum(D.*conj(f).*f)));
        const = normGradu/normGradu0(k)-alpha;
        
        tmp = tmp+const; 
        
        
        uhat(:,:,k) = (uhat(:,:,k).*(1-const*dt*4*D./(1+4*lambda*D))+dt*mu*(uhat(:,:,k+1)+uhat(:,:,k-1)))...
            ./(1+2*dt*mu);
    end
    
    k = 1; f = uhat(:,:,k); normGradu =  abs(sum(sum(D.*conj(f).*f)));
    const = normGradu/normGradu0(k)-alpha;
    
    tmp = tmp+const; 
    
    uhat(:,:,1) = (uhat(:,:,k).*(1-const*dt*4*D./(1+4*lambda*D))+dt*mu*(uhat(:,:,2)))...
            ./(1+dt*mu);
        
    k = K;     f = uhat(:,:,k); normGradu =  abs(sum(sum(D.*conj(f).*f)));
    const = normGradu/normGradu0(k)-alpha;
    tmp = tmp+const;   
    
    
     uhat(:,:,end) = (uhat(:,:,end).*(1-const*dt*4*D./(1+4*lambda*D))+dt*mu*(uhat(:,:,end-1)))...
            ./(1+dt*mu);   
        
       
     er(it)=tmp;
    
                     
end

for k = 1:K
    u(:,:,k) = ifft2(uhat(:,:,k));
end

Time = toc;
