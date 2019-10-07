% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This feature is inspired by the simple tiny images used as features in 
%  80 million tiny images: a large dataset for non-parametric object and
%  scene recognition. A. Torralba, R. Fergus, W. T. Freeman. IEEE
%  Transactions on Pattern Analysis and Machine Intelligence, vol.30(11),
%  pp. 1958-1970, 2008. http://groups.csail.mit.edu/vision/TinyImages/

function image_feats = get_tiny_images(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
%  image path on the file system.
% image_feats is an N x d matrix of resized and then vectorized tiny
%  images. E.g. if the images are resized to 16x16, d would equal 256.

    N = length(image_paths);
    image_feats = zeros(N,256);
    for i=1:N
        inputImage = im2single(imread(char(image_paths(i))));
        resized_image = imresize(inputImage,[16 16]);
        B = reshape(resized_image,[1,256]);
        B = B - mean(B);
        %v = var(B);
        %B = (B - m)/v; % why would we need normalization?
        image_feats(i,:) = B;       
    end
end


% To build a tiny image feature, simply resize the original image to a very
% small square resolution, e.g. 16x16. You can either resize the images to
% square while ignoring their aspect ratio or you can crop the center
% square portion out of each image. 

% Making the tiny images zero mean and approximately unit length 
% will increase performance modestly. This is called feature scaling.
% Often, we implement 'standardization' (see page), though each approach
% has a slightly different effect.
% https://en.wikipedia.org/wiki/Feature_scaling
%
% We can do this in two ways, too, and both do different things:
% - Subtract the mean of each tiny image and scale to ~unit length.
%   This removes brightness variation in the image, which might be
%   a useful trick, but it might also be a useful feature.
% - Standardize _each feature_ across the whole dataset. Compute the
%   mean/variance feature, then subtract/divide. This is
%   computing the _mean tiny image_ and subtracting it (+ divide by
%   variance of feature). This retains that signal, and just shifts
%   the feature space into an easier number space on which to learn.



% Suggested functions: imread, imresize

