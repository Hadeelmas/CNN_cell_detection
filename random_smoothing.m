function smoothed = random_smoothing(img)
% Do a random gaussian smoothing of an image patch
    low_bound = 0.5; 
    upp_bound = 3;
    std_dev = (upp_bound-low_bound).*rand(1) + low_bound;
    
    smoothed = imgaussfilt(img, std_dev);

end

