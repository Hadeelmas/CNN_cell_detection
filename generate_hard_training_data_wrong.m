precision = 2;
radius = 13;
nbr_of_random_images = 3;
random_images_index = randperm(length(data.image),nbr_of_random_images);


hard_training_data = {};

for i = 1:nbr_of_random_images
    img = data.image{random_images_index(i)};
    img_size = size(img);
    probmap = sliding_cnn(net, img, 4);
    probmap_img = imresize(probmap(:,:,2),img_size(1:2));
    maxima = strict_local_maxima(B, 0.5, 1);
    index_val = data.cellcenters{random_images_index(i)};
    for j = 1:length(maxima)
        maxima_xy = maxima(:,j);
        distance = vecnorm(index_val - maxima_xy);
        if sum(distance < precision) == 0
           [x, y] = extract_patch(maxima_xy, radius, img_size);
           if (size(x,2) == radius*2+1) && (radius*2+1 == size(y,2))
               hard_training_data = [hard_training_data, img(y,x,:)];
           end
        end
    end
    
    
end
    

