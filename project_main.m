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
options = trainingOptions('sgdm', 'MaxEpoch',3);
probability_to_train_on_hard = 0.7;


for i = 1:1
    
    if 0 && (~isfield(training, 'hard') || rand < probability_to_train_on_hard)
        generate_traning_data
        random_indexes = randperm(length(training.image));
        training_data = training.image(:,:,:,random_indexes);
        training_labels = training.label(random_indexes);
    else
        %random_indexes = randperm(length(training.hard.label));
        %training_data = training.hard.image(:,:,:,random_indexes);
        %training_labels = training.hard.label(random_indexes);
        generate_hard_training_data_wrong
        
        random_indexes = randperm(size(training_data,4));
        training_data = convolutional_traing.data(:,:,:,random_indexes);
        training_labels = convolutional_traing.label(random_indexes);
    end
    
    net = trainNetwork(training_data, training_labels, net.Layers, options);
    % classify hard
    generate_hard_training_data
end
% 
%%
%    generate_hard_training_data
%nonaugmented_network = net;
%save nonaugmented_network

%%

%probs = sliding_fcn(net, img);
%x = (xp - 1) * stride + 1;
%y = (yp - 1) * stride + 1;
%%
probmap = sliding_cnn(net, data.image{1}, 1);

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
