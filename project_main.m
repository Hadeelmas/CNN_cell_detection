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
probability_to_train_on_hard = 0.7;


for i = 1:10
    
    if (~isfield(training, 'hard') || rand < probability_to_train_on_hard)
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
    generate_hard_training_data
end
% 

%%
% koda bild för speglad padding redigera koordinater
probmap = sliding_cnn(net, data.image{1}, 1);

img = data.image{1};
index_val = data.cellcenters{1};
imsize = size (img);
%B = imresize(probmap(:,:,2),imsize(1:2));
%%
% kolla för nära en cell 
maxima = strict_local_maxima(probmap(:,:,2), 0.5, 1);

imagesc(img);
hold on
scatter(maxima(1,:),maxima(2,:))
scatter(index_val(1,:), index_val(2,:))
hold off
%%

