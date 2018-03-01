precision = 2;
radius = 13;
training_image_index = randi(length(data.image));


convolutional_training.data = {};
convolutional_training.label = [];

    img = data.image{training_image_index};
    img_size = size(img);
    striding_lvl = 1;
    
    fprintf(['Doing sliding window on image ' num2str(training_image_index) '\n' ...
    'Striding level ' num2str(striding_lvl) '\n' 'This might take a while \n'])
    
    probmap = sliding_cnn(net, img, 1);
    
    disp('Sliding window: done')
    
    probmap_img = imresize(probmap(:,:,2),img_size(1:2));
    maxima = strict_local_maxima(probmap_img, 0.5, 1);
    index_val = data.cellcenters{training_image_index};
    
    disp('Aquire false positive patches')
    
    for j = 1:length(maxima)
        maxima_xy = maxima(:,j);
        distance = vecnorm(index_val - maxima_xy);
        
        if sum(distance < precision) == 0
            
           [x, y] = extract_patch(maxima_xy, radius, img_size);
           
           if (size(x,2) == radius*2+1) && (radius*2+1 == size(y,2))
               convolutional_training.data = [convolutional_training.data, img(y,x,:)];
               convolutional_training.label = [convolutional_training.label, 0];
           end
        end
    end
    
    disp('Aquire missed positive patches')
    
    for j = 1:length(index_val)
        distance = vecnorm(maxima - index_val(:,j));
        
        if sum(distance < precision) == 0
            
           [x, y] = extract_patch(maxima_xy, radius, img_size);
           
           if (size(x,2) == radius*2+1) && (radius*2+1 == size(y,2))
               convolutional_training.data = [convolutional_training.data, img(y,x,:)];
               convolutional_training.label = [convolutional_training.label, 1];
           end
        end
    end
    
    convolutional_training.data = cat(4,convolutional_training.data{:});
    convolutional_training.label = categorical(convolutional_training.label);
