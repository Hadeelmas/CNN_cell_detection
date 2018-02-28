function contrast_img = random_contrast(img)

    low_bound = -0.3;
    upp_bound = 0.2;
    contrast = (upp_bound-low_bound).*rand(1) + low_bound;

    contrast_img = img + contrast;
    
end

