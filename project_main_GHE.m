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
probability_to_train_on_hard = 0.8;


for i = 1:5
    
    if (~isfield(training, 'hard') || rand < probability_to_train_on_hard)
        generate_traning_data
        random_indexes = randperm(length(training.image));
        training_data = training.image(:,:,:,random_indexes);
        training_labels = training.label(random_indexes);
    else
        %random_indexes = randperm(length(training.hard.label));
        %training_data = training.hard.image(:,:,:,random_indexes);
        %training_labels = training.hard.label(random_indexes);
        generate_hard_training_data_wrong
        training_data = cat(4,hard_training_data{:});
        random_indexes = randperm(length(training_data));
        training_data = training_data(:,:,:,random_indexes);
        training_labels = categorical(zeros(1,length(training_data)));
    end
    
    net = trainNetwork(training_data, training_labels, net.Layers, options);
    % classify hard
%     generate_hard_training_data
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
stride = 4;
probmap = sliding_cnn(net, data.image{1}, stride);

img = data.image{1};
index_val = data.cellcenters{1};
imsize = size (img);
B = probmap(:,:,2);
%%
maxima = strict_local_maxima(B, 0.5, 1);
x_maxima = (maxima(1,:) - 1) * stride + 1;
y_maxima = (maxima(2,:) - 1) * stride + 1;
% -------------------------------------------------- %
% REFINING THE MAXIMA
refined_maxima = refine_maxima(maxima, B);
x_refmaxima = (refined_maxima(1,:) - 1) * stride + 1;
y_refmaxima = (refined_maxima(2,:) - 1) * stride + 1;
% -------------------------------------------------- %

%x = (xp - 1) * stride + 1;
%y = (yp - 1) * stride + 1;

imagesc(img);
hold on
scatter(x_maxima,y_maxima)
scatter(x_refmaxima,y_refmaxima)
scatter(index_val(1,:), index_val(2,:))
legend('Maxima', 'Refined Maxima', 'Validation indexes')
hold off
%%
