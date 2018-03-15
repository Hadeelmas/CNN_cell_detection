function contrast_img = random_brightness(img)
%Function for adding some random brightness to the image without making it
%totally black or white

    low_bound = -0.3;
    upp_bound = 0.3;
    contrast = (upp_bound-low_bound).*rand(1) + low_bound;
    % add the contrast (e.g. a number offset to the image
    contrast_img = img + contrast;
    
end

