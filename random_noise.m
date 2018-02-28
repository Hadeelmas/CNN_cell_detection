function noisy_img = random_noise(img)
    
    low_bound = 0.0001;
    upp_bound = 0.005;
    
    std_dev = (upp_bound-low_bound).*rand(1) + low_bound;
    img_size = size(img);
    noisy_img = normrnd(img, std_dev, img_size);

end

