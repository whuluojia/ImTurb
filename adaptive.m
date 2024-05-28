function selected = adaptive(avgFrame, input, rangei, rangej, rangek, totalFrame, mseGain, gradGain1, 0)

if doFrameSelection
    [height, width, totalFrame] = size(input);
    rangei = 1:height;
    rangej = 1:width;
    rangek = 1:totalFrame;
    [valcostSelect, indcostSelect] = findGoodFrame(avgFrame, input, rangei, rangej, rangek, totalFrame, sharpMethod, 0, ...
        mseGain, gradGain1, 0);
else
    indcostSelect = 1:totalFrame;
end

if doFrameSelection
    [height, width, totalFrame] = size(input);
    rangei = 1:height;
    rangej = 1:width;
    rangek = 1:totalFrame;
    [valcostSelect, indcostSelect] = findGoodFrame(avgFrame, input, rangei, rangej, rangek, totalFrame, sharpMethod, 0, ...
        mseGain, gradGain1, 0);
else
    indcostSelect = 1:totalFrame;
end

if doFrameSelection
    halfval = (mseGain+gradGain2)/2; % half of max costSelect
    [~,numFrametoUse] = min(abs(valcostSelect-halfval));
    numFrametoUse = min(numFrametoUse,maxFrameused);

    % reduce input to only good selected frames
    input = input(:,:,indcostSelectupdate(1:numFrametoUse));
    if ~isempty(inputU)
        inputU = inputU(:,:,indcostSelectupdate(1:numFrametoUse));
        inputV = inputV(:,:,indcostSelectupdate(1:numFrametoUse));
    end
end