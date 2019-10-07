% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

% Useful functions:
%  matching_indices = strcmp(string, cell_array_of_strings)
%    This can tell you which indices in train_labels match a particular
%    category. Not necessary for simple one nearest neighbor classifier.
 
%   [Y,I] = MIN(X) if you're only doing 1 nearest neighbor, or
%   [Y,I] = SORT(X) if you're going to be reasoning about many nearest
%   neighbors 

% Nearest Neighbor Classification
% given a test_image, compare it with all the training examples

[m,d] = size(test_image_feats);% m test images, d dimensions
[n,d] = size(train_image_feats); % n training images, d dimensions
predicted_categories = cell(m,1);

for i=1:m
    % for each image, compute the L2 distance with the features of
    % training_examples
    D = zeros(n,1);
    for j=1:n
        dist = sum((train_image_feats(j,:) - test_image_feats(i,:)).^2);
        D(j) = dist;
    end
    [y,index] = sort(D);
    predicted_categories(i) = train_labels(index(1));
end

end






