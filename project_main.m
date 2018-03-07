
%% Load all images and their corresponding cell centers
load_images
%%
FALSE = logical(false);
TRUE = logical(true);


benchmark.harditeration = [];
benchmark.numberofmissclassifications = [];
%% generate validation set
nbr_of_validation = 10;
radius = 15;
nbr_of_negatives = 150;

generate_validation_data

%% generate training data
cropped_radius = radius;

generate_traning_data

%% Set up option parameters for initial training
iterations_since_not_improving = 50; % one Epoch is 50 iterations
options = trainingOptions('sgdm', 'MaxEpoch',10, 'OutputFcn',       ...
                @(info)stopIfTrainingAccuracyNotImproving(info,     ...
                iterations_since_not_improving));

%% Initial training of network
random_indexes = randperm(length(training.image));
layers = cnn_classifier(patch_size);
net = trainNetwork(training.image(:,:,:,random_indexes),            ...
                   training.label(random_indexes), layers, options);


%% Setup parameters for training the network
iterations_since_not_improving = 30;
opt_normal_ex = trainingOptions('sgdm', ...
                                'MaxEpoch', 5,   ...
                                'LearnRateDropFactor', 0.2, ...
                                'LearnRateDropPeriod', 2, ...
                                'OutputFcn',  ...
                    @(info)stopIfTrainingAccuracyNotImproving(info, ...
                    iterations_since_not_improving));
                
opt_hard_ex = trainingOptions('sgdm', ...
                              'MaxEpoch', 100, ...
                              'LearnRateDropFactor', 0.2, ...
                              'LearnRateDropPeriod', 10, ...
                              'OutputFcn',    ...
                    @(info)stopIfTrainingAccuracyNotImproving(info,     ...
                    iterations_since_not_improving));
            
learn_rate = 0.01;
decrement_factor = 10;

initial_prob_train_easy_data = 1;
probability_dec_rate = 0.9;
break_threshold = 1;
maximum_length_of_hard_examples = 4000;
clean_hard = 400;
nbr_max_iterations = 200;
hard_training_off = FALSE;
breaking_conditions_reached = FALSE;
hard_training_flag = FALSE;
breaking_iterations = 5;

prob_train_easy_data = initial_prob_train_easy_data;
iter = 0;
%% Train the network
for i = 1:nbr_max_iterations
    disp(['Commencing iteration ' num2str(i)])
    iter = i;
    if (~isfield(training, 'hard') || rand < prob_train_easy_data) || hard_training_off
        generate_traning_data
        random_indexes = randperm(length(training.image));
        training_data = training.image(:,:,:,random_indexes);
        training_labels = training.label(random_indexes);
        store_hard = 1;
        options = opt_normal_ex;
        prob_train_easy_data = probability_dec_rate*prob_train_easy_data;
        benchmark.harditeration = [benchmark.harditeration, FALSE];
        if training.hard.length < 300
            prob_train_easy_data = initial_prob_train_easy_data;
        end
    else
        hard_training_flag = TRUE;
        disp('Doing some hard data iterations');
        disp(['The current hard dataset has length ' num2str(training.hard.length)])

        random_indexes = randperm(length(training.hard.label));
        training_data = training.hard.image(:,:,:,random_indexes);
        training_labels = training.hard.label(random_indexes);
        store_hard = 0;
        options = opt_hard_ex;
        prob_train_easy_data = initial_prob_train_easy_data;
        benchmark.harditeration = [benchmark.harditeration, TRUE];
        
    end
    
    % Generate the new network
    net = trainNetwork(training_data, training_labels, net.Layers, options);
    
    % Store the examples that are missclassified when training on "easy"
    % data
    
    if store_hard == 1
        if (~isfield(training, 'hard'))
            length_of_hard = 0;
        else
            length_of_hard = training.hard.length;
        end

        
        disp('Generating hard data')
        generate_hard_training_data
        disp('Done!')
        disp(['The hard dataset currently contains ' num2str(training.hard.length) ' elements'])


        % If not enough hard data are added, we are satisfied with the
        % network.
        if hard_training_flag && ((training.hard.length - length_of_hard) < break_threshold)
            disp('Too few missclassifications')
            disp('Loop breaking conditions reached')
            hard_training_off = TRUE;
            breaking_conditions_reached = TRUE;
            learn_rate = learn_rate/decrement_factor;
            opt_normal_ex = trainingOptions('sgdm', ...
                'MaxEpoch',5,   ...
                'LearnRateDropFactor', 0.2, ...
                'LearnRateDropPeriod', 1, ...
                'InitialLearnRate', learn_rate, ... 
                'OutputFcn',          ...
                    @(info)stopIfTrainingAccuracyNotImproving(info,     ...
                    iterations_since_not_improving));
            disp(['Do ' num2str(breaking_iterations) ' more training iterations on "easy" data with an initial learning rate of ' num2str(learn_rate)])
        end
        
        if breaking_conditions_reached
            if breaking_iterations <= 0
                break
            else
            breaking_iterations = breaking_iterations - 1;
            end
        end
        
    end
end

disp([num2str(iter) ' iterations made'])
load gong.mat;
sound(y, Fs);

%% Evaluate the network
evaluate_network_on_patches

%%

stride = 1;
probmap = sliding_cnn(net, data.image{1}, stride);

img = data.image{1};
index_val = data.cellcenters{1};
imsize = size(img);
B = probmap(:,:,2);

%%
close all
gaussian_std = 2;
maxima = strict_local_maxima(B, 0.5, gaussian_std);
x_maxima = (maxima(1,:) - 1) * stride + 1;
y_maxima = (maxima(2,:) - 1) * stride + 1;
%%
% -------------------------------------------------- %
% REFINING THE MAXIMA

refined_maxima = refine_maxima(maxima, B, gaussian_std);
x_refmaxima = (refined_maxima(1,:) - 1) * stride + 1;
y_refmaxima = (refined_maxima(2,:) - 1) * stride + 1;
% -------------------------------------------------- %
%%
figure(1)
imagesc(img);
hold on
scatter(x_maxima,y_maxima)
scatter(x_refmaxima,y_refmaxima)
scatter(index_val(1,:), index_val(2,:))
legend('Maxima', 'Refined Maxima', 'Validation indexes')
hold off

threshold = 5;
generated_indexes = [x_maxima; y_maxima];
generated_indexes_refined = [x_refmaxima; y_refmaxima];
[cell_count_diff,nbr_of_outliers, residuals] = ...
    loss_function(generated_indexes,index_val, threshold);
[cell_count_diff_refined,nbr_of_outliers_refined, residuals_refined] = ...
    loss_function(generated_indexes_refined,index_val, threshold);

figure(2)
plot(benchmark.numberofmissclassifications)
hold on
benchmark.harditeration(benchmark.harditeration == 0) = NaN;
scatter(1:length(benchmark.harditeration), 20*benchmark.harditeration)
xlabel('Iteration number')
ylabel('Number of missclassifications')
legend('Neural network', 'Hard dataset training iteration')



disp(['The number of cells counted is ' num2str(cell_count_diff) ' less than the real value'])
disp(['The number of outlier generated (threshold = ' num2str(threshold) ') on the non refined set is ' num2str(nbr_of_outliers)])
disp(['The residuals on the non refined set is ' num2str(residuals)])
disp(['The number of outlier generated (threshold = ' num2str(threshold) ') on the refined set is ' num2str(nbr_of_outliers_refined)])
disp(['The residuals on the refined set is ' num2str(residuals_refined)])
load handel.mat;
sound(y, Fs);
%%
