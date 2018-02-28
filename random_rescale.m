function rescales_img = random_rescale(img)

low_bound = 0.8;
upp_bound = 1.2;

scale = (upp_bound-low_bound).*rand(1) + low_bound;
rescales_img = imresize(img, scale, 'bilinear');
end

