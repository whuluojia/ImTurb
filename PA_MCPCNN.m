function R=PA_MCPCNN(input,LS,Para)
%Code for PA_MCPCNN
%Absolute values can be used
alpha_f = Para.alpha_f ;
lambda = Para.lambda;
V_E = Para.v_e;
m = Para.m;
alpha_e = Para.alpha_e;
iter = Para.iter;
A = abs(input);
%PA_MCPCNN

[p,q,num]=size(A);
U=zeros(p,q);
Y=zeros(p,q);
E=ones(p,q);
W=[0.5 1 0.5;1 0 1;0.5 1 0.5];

for it=1:iter
    K1 = conv2(Y,W,'same');
    K=(K1>0); 
    for k = 1:num
        U1(:,:,k)=A(:,:,k).* (1 + LS(:,:,k) .* K);
    end
    % max
    [t1,x1] = max(U1,[],3);
    for i  = 1:p
        for j = 1:q
            U2(i,j) = U1(i,j,x1(i,j));
        end
    end
    
    U = exp(-alpha_f) * U + U2;
    Y = im2double( U > E );
    E = exp(-alpha_e) * E + V_E * Y;
end
[t2,x2] = max(U1,[],3);

for i  = 1:p
    for j = 1:q
        R(i,j) = input(i,j,x2(i,j));
    end
end

end
