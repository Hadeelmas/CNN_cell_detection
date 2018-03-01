function rescales_img = random_rescale(img)
% Random rescaling an image without stretching it too hard
    % Random boundries pulled out of my ass.
    low_bound = 0.8; 
    upp_bound = 1.2;
    scale = (upp_bound-low_bound).*rand(1) + low_bound;
    rescales_img = imresize(img, scale, 'bilinear');
end

