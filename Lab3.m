%% 1 Matlab Basic
clc;
clear;

I = imread('img/bob.JPG');
imshow(I);
imwrite(I, 'img/bob_saved.png');

%% 2 Image Representation
clc;
clear;

I = imread('img/bob.JPG');
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

figure
subplot(2,3,1);
imshow(I);
title('Original');
subplot(2,3,2);
imshow(R);
title('Red chanel');
subplot(2,3,3);
imshow(G);
title('Green chanel');
subplot(2,3,4);
imshow(B);
title('Blue chanel');
subplot(2,3,5);
gray_img = rgb2gray(I);
imshow(gray_img);
title('Grayscale Image');

%% 3 Threshold and Color Space
clc;
clear;

I = imread('img/bob.JPG');
gray_img = rgb2gray(I);
thresholdValue = 128;

BinaryMask = gray_img > thresholdValue;
ThreshImg = gray_img;
ThreshImg(ThreshImg < thresholdValue) = 0;

figure;
subplot(2,1,1);
imshow(BinaryMask);
title('Binary Mask');
subplot(2,1,2);
imshow(ThreshImg);
title('Img < Threshold set to 0');

I = im2double(I);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
greenMask = (G > 0.3) & (G > R + 0.05) & (G > B + 0.05);
GreenOnly = zeros(size(I));
GreenOnly(:,:,1) = R .* greenMask;
GreenOnly(:,:,2) = G .* greenMask;
GreenOnly(:,:,3) = B .* greenMask;

% MATLAB COLOR THRESHOLD APP: HSV FUNCTION
HSV = rgb2hsv(I);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.192;
channel1Max = 0.473;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.320;
channel2Max = 1.000;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
sliderBW = (HSV(:,:,1) >= channel1Min ) & (HSV(:,:,1) <= channel1Max) & ...
           (HSV(:,:,2) >= channel2Min ) & (HSV(:,:,2) <= channel2Max) & ...
           (HSV(:,:,3) >= channel3Min ) & (HSV(:,:,3) <= channel3Max);
BW_edge = sliderBW;
% Initialize output masked image based on input image.
maskedRGBImage = I;
% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW_edge,[1 1 3])) = 0;

% Convert to RGB to HSV -> change Hue(color) -> back to RGB
HSVPic = rgb2hsv(maskedRGBImage);
HSVPic(:,:,1) = mod(HSVPic(:,:,1) + 0.35, 1);  % +0.35(around 100 degrees on colorwheel) look at HSV App
HueChange = hsv2rgb(HSVPic);

PradaBlue = I;
PradaBlue(repmat(BW_edge,[1 1 3])) = HueChange(repmat(BW_edge,[1 1 3]));

figure
subplot(2,2,1);
imshow(GreenOnly);
title('GreenMask');
subplot(2,2,2);
imshow(maskedRGBImage);
title('Green HSV filter');
subplot(2,2,3);
imshow(HueChange);
title('Blue Bag');
subplot(2,2,4);
imshow(PradaBlue);
title('New Prada Bag');

%% 4 Spatial operator and convolution
clc;
clear;
I = imread("img\calendar_speckle10.jpg");
Idoub = im2double(I);

% --- MATLAB built in edge-functions ---
BW_edge = edge(Idoub,"sobel");
BW_edge_blurred = imgaussfilt(double(BW_edge),1);

% --- Own convolution edgedetection ---
sobel_x = fspecial('sobel');
sobel_y = sobel_x';
Ix = conv2(Idoub, sobel_x, 'same');
Iy = conv2(Idoub, sobel_y, 'same');
gradmag = sqrt(Ix.^2 + Iy.^2);
gradmag_norm = gradmag / max(gradmag(:));
gauss_filter = fspecial('gaussian', [5 5], 1);
gradmag_blurred = imfilter(gradmag_norm, gauss_filter, 'same');

% --- Plot Result ---

figure;
sgtitle('Compare between edge detection');
subplot(2,2,1);
imshow(BW_edge);
title('Edge() Sobel');
subplot(2,2,2);
imshow(gradmag, []);
title('Conv2 + fspecial (Sobel)');
subplot(2,2,3);
imshow(BW_edge_blurred);
title('Edge + Gaussian');
subplot(2,2,4);
imshow(gradmag_blurred, []);
title('Conv2 + fspecial + Gaussian');

sobel = fspecial('sobel');
gauss = fspecial('gaussian', [5 5], 1);
n = 1000;
% A = (I*s)*g Img*sobel then * gauss
tic
for i = 1:n
    temp = conv2(Idoub, sobel, "same");
    A = conv2(temp, gauss,"same");
end
tA = toc;

% B = I*(s*g) combine sobel + gauss then one instance of conv with img
% Sobel + Gauss creates a new filter that we use instead for faster conv
sob_Gauss = conv2(sobel,gauss, "same");
tic
for i = 1:n
    B = conv2(Idoub, sob_Gauss, "same");
end
tB = toc;

disp(['Time A:',num2str(tA)]);
disp(['Time B:',num2str(tB)]);
diff = abs(A - B);

figure;
imshow(diff, []);
title('Differense in Conv order');
%% 5 Calibration and Measurement

%imshow('img\pen1.JPG');
imshow('img\pen2.JPG');
I1 = imread('img\pen1.JPG');
I2 = imread('img\pen2.JPG');
%datacursormode on

x1 = 1589;
x2 = 1094;
y1 = 50;
y2 = 41;
x3 = 1552;
x4 = 1024;
y3 = 854;
y4 = 863;

h1 = sqrt((x2 - x1)^2 + (y2 - y1)^2);
h2 = sqrt((x4 - x3)^2 + (y4 - y3)^2);
H = 140;
f = 1000;

Z1 = f*(H/h1);
Z2 = f*(H/h2);

U1 = undistortImage(I1,cameraParams,'OutputView','full');
U2 = undistortImage(I2,cameraParams,'OutputView','full');
imshow(U2);

ux1 = 2177;
ux2 = 1638;
uy1 = 1465;
uy2 = 1469;
u2x1 = 2245;
u2x2 = 1690;
u2y1 = 537;
u2y2 = 537;

Zu1 = sqrt((ux2 - ux1)^2 + (uy2 - uy1)^2);
Zu2 = sqrt((u2x2 - u2x1)^2 + (u2y2 - u2y1)^2);

fprintf("Z1 (före undistort): %.2f mm\n", Z1);
fprintf("Z2 (före undistort): %.2f mm\n", Z2);
fprintf("Zu1 (efter undistort): %.2f mm\n", Zu1);
fprintf("Zu2 (efter undistort): %.2f mm\n", Zu2);