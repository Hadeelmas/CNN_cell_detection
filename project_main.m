addpath(genpath(fileparts(which('project_main.m'))));
clear all
%% Load all images and their corresponding cell centers
load_images

%% generate validation set
generate_validation_data

%% generate training data
generate_traning_data

% Train network
options = trainingOptions('sgdm', 'MaxEpoch',3); %, 'OutputFcn',@(info)stopIfAccuracyNotImproving(info,3));
% first iteration
random_indexes = randperm(length(training.image));
layers = cnn_classifier(patch_size);
net = trainNetwork(training.image(:,:,:,random_indexes), training.label(random_indexes), layers, options);
options = trainingOptions('sgdm', 'MaxEpoch',2);
training.hard.image = [];
training.hard.label = [];
probability_to_train_on_hard = 0.8;

%training.image = cat(4, training_image{:});
%training.label = categorical(training_label);

for i = 1:5
    
    if (isempty(training.hard.label) || rand < probability_to_train_on_hard)
        generate_traning_data
        random_indexes = randperm(length(training.image));
        training_data = training.image(:,:,:,random_indexes);
        training_labels = training.label(random_indexes);
    else
        random_indexes = randperm(length(training.hard.label));
        training_data = training.hard.image(:,:,:,random_indexes);
        training_labels = training.hard.label(random_indexes);
    end
    
    net = trainNetwork(training_data, training_labels, net.Layers, options);
    % classify hard
    for j = 1:length(training.image)
        pred = net.classify(training.image(:,:,:,j));
        if (pred ~= training.label(j))
            training.hard.image = cat(4, training.hard.image ,training.image(:,:,:,j));
            training.hard.label = [training.hard.label, training.label(j)];
        end
    end
end
% 
% probmap = sliding_cnn(net, validation.image{1}, 4);
% img = validation.image{1};
% index_val = validation.cellcenters{1};
% imsize = size (img);
% B = imresize(probmap(:,:,2),imsize(1:2));
% maxima = strict_local_maxima(B, 0.5, 1);
%%
%    generate_hard_training_data
%nonaugmented_network = net;
%save nonaugmented_network

%%

%probs = sliding_fcn(net, img);
%x = (xp - 1) * stride + 1;
%y = (yp - 1) * stride + 1;
%%
probmap = sliding_cnn(net, data.image{1}, 4);

img = data.image{1};
index_val = data.cellcenters{1};
imsize = size (img);
B = imresize(probmap(:,:,2),imsize(1:2));
%%
maxima = strict_local_maxima(B, 0.5, 1);

imagesc(img);
hold on
scatter(maxima(1,:),maxima(2,:))
scatter(index_val(1,:), index_val(2,:))
hold off
%%
