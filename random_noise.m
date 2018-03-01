function noisy_img = random_noise(img)
% Function for adding some small random gaussian noise to an image without
% totally corrupting the data
    % Some bounds i pulled out of my anus
    low_bound = 0.0001;
    upp_bound = 0.005;
    std_dev = (upp_bound-low_bound).*rand(1) + low_bound;
    img_size = size(img);
    % Add the noise to the image
    noisy_img = normrnd(img, std_dev, img_size);

end

