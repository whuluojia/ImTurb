function  out = optical_flow(ref,input)


alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];


for i = 1:size(input,3)

    moving = input(:,:,i);

    [~,~,warpI2] = Coarse2FineTwoFrames(ref,moving,para);


    out(:,:,i) = warpI2;
end


end