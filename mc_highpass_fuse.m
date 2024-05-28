function  result=mc_highpass_fuse(input , link_strength)
% input 
A = abs(input);
LS =  link_strength;
[m,n,num] = size(A);

%% parameter settings
%  计算输入矩阵的 标准差 、最大值 和 Otsu阈值
parfor i= 1:num
    stt(i) = std2(A(:,:,i));   % 标准差
    SS(i) = max(max(A(:,:,i)));   %最大值
    Sgt(i) =graythresh(A(:,:,i));  % Otsu阈值
    x1(i) = SS(i)/Sgt(i);    
end
%% 多通道自适应参数设置
Para.alpha_f = log10(1.0*num/sum(stt));
Para.lambda = (sum(x1) - num)/6/num;
Para.v_e =exp(-Para.alpha_f) +1 + 6*Para.lambda;
Para.m = (1-exp(-3* Para.alpha_f ))/(1- exp(-Para.alpha_f ))+6*Para.lambda*exp(-Para.alpha_f );
Para.alpha_e = log(num*Para.v_e/sum(Sgt)/Para.m);
Para.iter = 200;
%%  执行PA_MCPCNN
result = PA_MCPCNN(input,LS,Para);

end