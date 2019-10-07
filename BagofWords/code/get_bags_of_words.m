% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_words(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x feature vector length
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct feature descriptors here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% feature descriptors will look very different from a smaller version of the same
% image.
    load('vocab.mat')
    vocab_size = size(vocab, 1);
    d = size(vocab,2);
    
    [N,m] = size(image_paths);
    image_feats = zeros(N,vocab_size); % or (N,d)?
    
    for j=1:N % for each image
        image = im2single(imread(char(image_paths(j))));
        [r,c] = size(image);
        [X,Y] = meshgrid(1:10:r, 1:10:c);
        X = X(:);
        Y = Y(:);
        feat = extractHOGFeatures(image,[X,Y],'CellSize',[16 16]);
        % feat 380 x 36: 36 dimensions, 380 features, 
        % vocab 200 x 36: 36 dimensions, 200 vocabularies
        n = size(feat,1);
        H = zeros(1,vocab_size);
        for i=1:n
            % compute the distance between the feature vector and vocab
            % features
            currentfeat = feat(i,:);
            % compute which vocab the currentfeat falls into
            D = zeros(vocab_size,1);
            for k=1:vocab_size
                dist = sum((vocab(k,:) - currentfeat).^2);
                D(k) = dist; % distance between current feature and all the vocab feats
            end
            [y,index] = sort(D);
            a = index(1);
            H(a) = H(a) + 1;
        end
        H_normalized = H/sum(H);
        image_feats(j,:) = H_normalized;    
    end
end



