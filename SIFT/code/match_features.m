% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
%num_features = min(size(features1, 1), size(features2,1));
matches = [];
confidences =[];

num_match = 0;
threshold = 0.85;
l = size(features1,1);
m = size(features2,1);

for i=1:l
    subtract = repmat(features1(i,:),m,1) - features2;
    euc_dist = sqrt(sum((subtract).^2,2));
    [distance index] = sort(euc_dist);
    NNDR = distance(1)/distance(2);
    if NNDR < threshold
      num_match = num_match + 1;
      matches = [matches ; [i index(1)]];
      confidences = [confidences; 1 - NNDR];
    end
end


% Sort the matches so that the most confident onces are at the top of the
% list. You should not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);
end