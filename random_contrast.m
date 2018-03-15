function contrast_img = random_contrast(img)
%Function for adding some random contrast to the image without making it
%totally black or white

    low_bound = -0.5;
    upp_bound = 0.5;
    contrast = 1+(upp_bound-low_bound).*rand(1) + low_bound;
    % add the contrast (e.g. a number offset to the image
    contrast_img = img*contrast;
    
end

