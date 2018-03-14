
%% Load all images and their corresponding cell centers
load_images
%% Defining parameters and setting up logging data
FALSE = logical(false);
TRUE = logical(true);
benchmark.harditeration = [];
benchmark.numberofmissclassifications = [];
%% generate validation set
nbr_of_validation = 10;
radius = 12;
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
% Training parameters
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
            
% Base learn rate
learn_rate = 0.01;
% Decrement factor
decrement_factor = 10;
% Initial probability to train on easy data. Should be 1
initial_prob_train_easy_data = 1;
% Probability to train on the hard data will increase after each iteration
% by a factor of:
probability_dec_rate = 0.7;
% Threshold of how many hard data elements we add to the hard dataset
% before entering break conditions
break_threshold = 1;
% Maximum size of the hard dataset before cleaningattempts (i.e correctly
% classified data are removed) are made
maximum_length_of_hard_examples = 4000;
% If unsuccessful cleaningattemt, remove the earliest xx elements
clean_hard = 400;
% Total number of iteration in the main loop as most
nbr_max_iterations = 1000;
% TRUE = turns off hard training iterations
hard_training_off = FALSE;
% After some lucky conditions when the stars are aligned, we might enter an
% if case which breaks the loop due to too few hard data samples where
% added in the hard dataset. We then do xx iterations on the easy data
breaking_iterations = 5;
% If we reach this base learning rate, we break the loop.
learn_rate_break = 10e-9;


breaking_conditions_reached = FALSE;
hard_training_flag = FALSE;
prob_train_easy_data = initial_prob_train_easy_data;
iter = 0;
%% Train the network
for i = 1:nbr_max_iterations
    disp(['Commencing iteration ' num2str(i)])
    iter = i;
    if ~isfield(training, 'hard') || (training.hard.length < 300) || (i > nbr_max_iterations - 5)
            prob_train_easy_data = 1;
    end
    if  (rand < prob_train_easy_data) || hard_training_off
        generate_traning_data
        random_indexes = randperm(length(training.image));
        training_data = training.image(:,:,:,random_indexes);
        training_labels = training.label(random_indexes);
        store_hard = 1;
        options = opt_normal_ex;
        prob_train_easy_data = probability_dec_rate*prob_train_easy_data;
        benchmark.harditeration = [benchmark.harditeration, FALSE];
        
    else
        hard_training_flag = TRUE;
        disp('Doing some hard data iterations');
        disp(['The current hard dataset has length ' num2str(training.hard.length)])

        random_indexes = randperm(training.hard.length);
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
        

        % If not enough hard data are added, we have some options of either
        % breaking the loop or lowering the learning rate
        if hard_training_flag && ((training.hard.length - length_of_hard) < break_threshold)
            learn_rate = learn_rate/decrement_factor;            
            opt_normal_ex = trainingOptions('sgdm', ...
                'MaxEpoch',5,   ...
                'LearnRateDropFactor', 0.2, ...
                'LearnRateDropPeriod', 1, ...
                'InitialLearnRate', learn_rate, ... 
                'OutputFcn',          ...
                    @(info)stopIfTrainingAccuracyNotImproving(info,     ...
                    iterations_since_not_improving));
            opt_hard_ex = trainingOptions('sgdm', ...
                              'MaxEpoch', 100, ...
                              'LearnRateDropFactor', 0.3, ...
                              'LearnRateDropPeriod', 4, ...
                              'InitialLearnRate', learn_rate, ... 
                              'OutputFcn',    ...
                    @(info)stopIfTrainingAccuracyNotImproving(info,     ...
                    iterations_since_not_improving));
                
            % If not enough hard data has been added for a while we enter
            % this section where we continue to do xx more iterations on
            % the easy dataset.
            if (benchmark.numberofmissclassifications(end-3:end)) < 4
            disp('Too few missclassifications')
            disp('Loop breaking conditions reached')
            hard_training_off = TRUE;
            breaking_conditions_reached = TRUE;
            learn_rate = learn_rate/decrement_factor;
            disp(['Do ' num2str(breaking_iterations) ' more training iterations on "easy" data with an initial learning rate of ' num2str(learn_rate)])
            end
            
        end
        if breaking_conditions_reached
            if breaking_iterations <= 0
                break
            else
            breaking_iterations = breaking_iterations - 1;
            end
        end
     
        % If we eventually lower the learning rate too much we break
        if learn_rate < learn_rate_break
            disp(['learn rate decreased below ' num2str(learn_rate_break)])
            disp('breaking...')
            break
        end
        
    end
end

disp([num2str(iter) ' iterations made'])
load gong.mat;
sound(y, Fs);

%% Evaluate the network
evaluate_network_on_patches

%% Save the network

save('my_network.mat', 'net')
%% Display how well we did on one of the validation picture
clf
i = randi(nbr_of_validation);
img = validation.image{i};
index_val = validation.cellcenters{i};
imsize = size(img);
figure(1)
imagesc(img);
hold on
detections = run_detector(img);
scatter(detections(1,:),detections(2,:))
scatter(index_val(1,:), index_val(2,:))

legend('Detections', 'Validations')

threshold = 5;

[cell_count_diff_refined,nbr_of_outliers_refined, residuals_refined] = ...
    loss_function(detections,index_val, threshold);

figure(2)
benchmark.harditeration(benchmark.harditeration == 0) = NaN;
plot(benchmark.numberofmissclassifications)
scatter(1:length(benchmark.harditeration), 20*benchmark.harditeration)
xlabel('Iteration number')
ylabel('Number of missclassifications')
legend('Neural network', 'Hard dataset training iteration')

hold off

disp(['The number of cells counted is ' num2str(cell_count_diff_refined) ' less than the real value'])
disp(['The number of outlier generated (threshold = ' num2str(threshold) ') on the refined set is ' num2str(nbr_of_outliers_refined)])
disp(['The residuals on the refined set is ' num2str(residuals_refined)])

%load handel.mat;
%sound(y, Fs);
%%
