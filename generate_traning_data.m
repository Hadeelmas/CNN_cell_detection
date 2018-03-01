% Script that genereates training data for training a neural network.

%% Begin by extracting some positives
global patch_size
% Set the desired number of positive training images per set and number
% of extractions from each image.
nrb_of_positives_per_set = 3000;
nbr_of_pos_extraction_per_image = 30;
% Initializing parameters
data_set_length = length(data.image);
training_set = randperm(data_set_length);
radius = 25;
cropped_radius = 13;
positives = cell(1,nbr_of_pos_extraction_per_image*data_set_length);
% Extract the positives
for i = 1:length(training_set)
    training_index = training_set(i); 
    idx_positives = ((i-1)*nbr_of_pos_extraction_per_image+1):i*nbr_of_pos_extraction_per_image;
    positives(idx_positives) = extract_random_positives(data.image{training_index}, ...
                                         data.cellcenters{training_index}, ...
                                         radius, nbr_of_pos_extraction_per_image);
    
end
cell_with_augmented_data = do_random_augmentations(positives, nrb_of_positives_per_set);
%cell_with_augmented_data = positives;
augmeted_training_set = crop_cells(cell_with_augmented_data,cropped_radius);
augmeted_training_set_labels = ones(1,nrb_of_positives_per_set);
patch_size = size(augmeted_training_set{1});



%% 
nbr_of_negatives_per_set = 3000;
nbr_of_neg_extraction_per_image = ceil(nbr_of_negatives_per_set/length(training_set));
nbr_of_actual_negatives_per_set = length(training_set)*nbr_of_neg_extraction_per_image;
negatives = cell(1,nbr_of_actual_negatives_per_set);
% Get random negative points, they do not get augmented.
for i = 1:length(training_set)
    training_index = training_set(i);
    idx_negatives = (((i-1)*nbr_of_neg_extraction_per_image+1):i*nbr_of_neg_extraction_per_image);
    negatives(idx_negatives) = extract_random_negatives(data.image{training_index}, ...
                                         data.cellcenters{training_index}, ...
                                         cropped_radius, nbr_of_neg_extraction_per_image);

end

negative_training_set_labels = zeros(1,nbr_of_actual_negatives_per_set);
training_image = [augmeted_training_set, negatives];
training_label = [augmeted_training_set_labels, negative_training_set_labels];

training.image = cat(4, training_image{:});
training.label = categorical(training_label);