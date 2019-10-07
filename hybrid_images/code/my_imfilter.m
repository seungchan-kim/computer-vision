function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
    [f1, f2] = size(filter);
    if (mod(f1,2) == 0) || (mod(f2,2) == 0) % if any of filter size is even
        % throw error message
        error("filter size should be odd");        
    else
        % check whether the filter is identity filter
        X = zeros(f1,f2);
        X((f1+1)/2, (f2+1)/2) = 1;
        if (f1 == f2) && all(all(filter == X)) % if the filter is square, and identity filter
            output = image; % return the image
        else
            convolution_filter = rot90(filter,2); % 180 degree rotation
            % now support grayscale & color images
            s = size(size(image)); % dimension of image
            if s(1,2) == 2 % if image is gray image -> dim = 2
                [m,n] = size(image);
                % we will create zero padded image
            
                padded_image = zeros(m+f1-1, n+f2-1);
                padded_image((f1-1)/2+1:(f1-1)/2+1+(m-1),(f2-1)/2+1:(f2-1)/2+1+(n-1)) = im2double(image);
                %padded_image = padarray(image, [(f1-1)/2, (f2-1)/2]);
                filtered_image = zeros(m,n);
                
                
                for i=1:m
                    for j=1:n
                        s = 0;
                        for k=1:f1
                            for l=1:f2
                                s = s + convolution_filter(k,l) * padded_image(i-1+k,j-1+l);
                                %s = s + filter(k,l) * padded_image(i+f1-k,j+f2-l);
                                % convolution
                            end
                        end
                        filtered_image(i,j) = s;                
                    end
                end           
            elseif s(1,2) == 3 % if image is color image -> dim = 3
                [m,n,p] = size(image); % p should be 3
            
                filtered_image = zeros(m,n,3);
                padded_image = zeros(m+f1-1,n+f2-1,3);
                for a=1:3
                    padded_image((f1-1)/2+1:(f1-1)/2+1+(m-1),(f2-1)/2+1:(f2-1)/2+1+(n-1),a) = im2double(image(:,:,a));
                end
            
                for a=1:3 % three RGB channels
                    for i=1:m
                        for j=1:n
                            s = 0;
                            for k=1:f1
                                for l=1:f2
                                    s = s + convolution_filter(k,l) * padded_image(i-1+k,j-1+l,a);
                                    %s = s + filter(k,l)* padded_image(i+f1-k,j+f2-1,a);
                                end
                            end
                            filtered_image(i,j,a) = s;
                        end
                    end
                end
            end        
            output = filtered_image;   
        end
    end
end






