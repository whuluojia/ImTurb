function F = pamcpcnn_fuse(img)
%% NSST decomposition
pfilt = 'maxflat';
shear_parameters.dcomp =[3,3,4,4];
shear_parameters.dsize =[8,8,16,16];
num = size(img,3);
[~,shear_f]=nsst_dec2(img(:,:,1),shear_parameters,pfilt);
for i = 1:num
    [y{i},~]=nsst_dec2(img(:,:,i),shear_parameters,pfilt);
end

for i = 1:num
    y_lowpass(:,:,i) =  y{1,i}{1,1};
end

% Para.iterTimes=200;
% Para.link_arrange=7;
% Para.alpha_L=0.02;
% Para.alpha_Theta=3;
% Para.beta=3;
% Para.vL=1;
% Para.vTheta=20;
t = 3;
%% fusion
% lowpass_fusion
y1{1} = lowpass_fuse(y_lowpass);

kk = 0;
% highpass_fusion
for m=2:length(shear_parameters.dcomp)+1
    temp=size((y{1}{m}));
    temp=temp(3);
    for n=1:temp
        kk = kk + 1;
        for k = 1:num
             y_high(:,:,k) =  y{k}{m}(:,:,n);
        end
        yy{kk} = y_high;
    end
end

for i = 1:kk
       yyy = yy{i};
      yy_high(:,:,i)  = highpass_fuse2(yyy,t);
end 

kk = 0;
for m=2:length(shear_parameters.dcomp)+1
    temp=size((y{1}{m}));
    temp=temp(3);
    for n=1:temp
        kk = kk +1 ;
            y1{m}(:,:,n) = yy_high(:,:,kk);
    end
end

%%  NSST reconstruction
F=nsst_rec2(y1,shear_f,pfilt);
end