function scaled_patch = rescale_patch(patch, scale)
%AUGMENT_SCALE The function takes in a NxMxd large image PATCH and scales to
%SCALE. The output SCALED_PATCH is also NxMxd large.
%   Function used to augment data in order to get more data before training
%   a classifier/ neural network.

% Extract information about the size of the image
[N, M, d] = size(patch);
% The scaling is done using bilinear interpolation
if scale == 1
    scaled_patch = patch;
elseif scale < 1
    error('Scale needs to be atleast 1');
else

        % Bilinear interpolation
        scaled_patch = imresize(patch, scale, 'bilinear');
end

end


