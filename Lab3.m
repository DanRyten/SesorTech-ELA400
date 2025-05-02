%% 1 Matlab Basic
img = imread('img/bob.JPG');
imshow(img);
imwrite(img, 'img/bob_saved.png');

%% 2 Image Representation
I = imread('img/bob.JPG');
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

figure
subplot(2,2,1);
imshow(I);
title('Original');
subplot(2,2,2);
imshow(R);
title('Red chanel');
subplot(2,2,3);
imshow(G);
title('Green chanel');
subplot(2,2,4);
imshow(B);
title('Blue chanel');

figure
gray_img = rgb2gray(I);
imshow(gray_img);
title('Grayscale Image');

%% 3 Threshold and Color Space
I = imread('img/bob_saved.png');
gray_img = rgb2gray(I);

thresh = adaptthresh(gray_img);
binary = imbinarize(gray_img, thresh);

figure
imshow(binary);
title('Threshold');
%% 4 Spatial operator and convolution

%% 5 Calibration and Measurement