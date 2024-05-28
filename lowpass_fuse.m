function F = my_lowpass_fuse(img)

disp('Process in Lowpass subband...')

% EA strategy

[m,n,num] = size(img);

a = 4;
t = 3;

for k = 1:num
    X1 = img(:,:,k);
    mB = mean(X1(:));
    MB = median(X1(:));
    G = (mB+MB)/2;
    w(:,:,k) = exp(a*abs(X1-G));
end

sum_w = sum(w,3);

F = zeros(m,n);

for i = 1:num
    X1 = img(:,:,i);
    w2 = w(:,:,i)./sum_w;
    F= X1.*w2+F;
end

end
