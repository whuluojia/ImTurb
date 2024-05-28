function xhat = batud(y)

% Load real blurry image
load('data/Otis_door.mat');
%  y = double(imread('data/img_0001.png'))./255;
% Define callback function to show results during processing
callback = @(t, xhat, kernel, a_coeffs, changes) ...
    cb_blind_deblurring(t, y, xhat, kernel, changes);

% Run blind deblurring using BATUD and the defined callback function
xhat = batud(y, [], 'callback', callback);
end




