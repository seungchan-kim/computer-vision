% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
 function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)
%function a = get_interest_points(image,feature_width)
% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

%close all
% Implementation of codes
% Let's assume that the input image is grayscale image

imageSize = size(image);
row = imageSize(1);
column = imageSize(2);

% 1. blur the input image first 
%gfilt = fspecial('gaussian',[5 5], 3);
%image = imfilter(image, gfilt);

% 1. Image derivatives
h = fspecial('sobel');
v = h';
x_derivative = imfilter(image,h);
y_derivative = imfilter(image,v);

% 2. Square of Image derivatives
Ixx = x_derivative .* x_derivative;
Iyy = y_derivative .* y_derivative;
Ixy = x_derivative .* y_derivative;


% 3. Gaussian Blur 
gaussian_filter = fspecial('gaussian',[5 5], 3);
gIxx = imfilter(Ixx,gaussian_filter); % 'conv'
gIyy = imfilter(Iyy,gaussian_filter);
gIxy = imfilter(Ixy,gaussian_filter);

% 4. Calculate cornerness function
alpha = 0.04;
har = gIxx.*gIxy - (gIxy).^2 - alpha*(gIxx+gIyy).^2;

%figure()
%imshow(har)
%figure()
%imshow(har*20)

% 5. Non-maxima suppression

% exclude border points! 

threshold = 0.005;
har_max = colfilt(har,[feature_width/4,feature_width/4],'sliding',@max);
%figure()
%imshow(har_max)
%result = har_max & (har > threshold);
result = (har_max == har) & (har > threshold);
%figure()
%imshow(result)
% Placeholder that you can delete -- random points
%x = ceil(rand(500,1) * size(image,2));
%y = ceil(rand(500,1) * size(image,1));
[x y] = find(result);
tempx = [];
tempy = [];
for i=1:length(x)
    if ~((x(i) <=7) || (x(i)+8 > row) || (y(i) <= 7) || (y(i)+8>column))
        tempx = [tempx x(i)];
        tempy = [tempy y(i)];
    end
end
x = tempx;
y = tempy;



%imshow(image);
%hold on;
%plot(y,x,'r+')
%a = size(find(har>0.1));
end

