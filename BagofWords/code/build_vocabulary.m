% Starter code prepared by James Hays for CSCI 1430 Computer Vision

% This function will extract a set of feature descriptors from the training images,
% cluster them into a visual vocabulary with k-means,
% and then return the cluster centers.

% Notes:
% - To save computation time, we might consider sampling from the set of training images.
% - Per image, we could randomly sample descriptors, or densely sample descriptors,
% or even try extracting descriptors at interest points.
% - For dense sampling, we can set a stride or step side, e.g., extract a feature every 20 pixels.
% - Recommended first feature descriptor to try: HOG.

% Function inputs: 
% - 'image_paths': a N x 1 cell array of image paths.
% - 'vocab_size' the size of the vocabulary.

% Function outputs:
% - 'vocab' should be vocab_size x descriptor length. Each row is a cluster centroid / visual word.

function vocab = build_vocabulary( image_paths, vocab_size )
    features = [];
    for i=1:size(image_paths,1)
        image = im2single(imread(char(image_paths(i))));
        [r,c] = size(image);
        [X,Y] = meshgrid(1:40:r,1:40:c);
        X = X(:);
        Y = Y(:);
        feat = extractHOGFeatures(image,[X,Y],'CellSize',[16 16]);
        features = cat(1,features,feat); 
    end
    [~, index] = kmeans(features, vocab_size,'MaxIter',5000);
    vocab = index;
end

