% Script to generate validation data


if ~exist('data','var')
    load_images
end
% Removes the images used for validation from the training set.
if ~exist('validation','var')
    validation_set = randperm(length(data.image),nbr_of_validation);
    validation.image = data.image(validation_set);
    validation.cellcenters = data.cellcenters(validation_set);
    data.image(validation_set) = [];
    data.cellcenters(validation_set) = [];
end
validation.patches.image = {};
validation.patches.label = [];
% Generate validation patches
for i = 1:nbr_of_validation
    img = validation.image{i};
    cell_indexes = validation.cellcenters{i};
    [positives, ~, edge_positives] = extract_all_positives(img, ...
                                                    cell_indexes,radius);
    negatives = extract_random_negatives(img, cell_indexes, ... 
                                            radius, nbr_of_negatives);
                                        
    validation.patches.image = [validation.patches.image, positives, ...
                                negatives];
    validation.patches.label = [validation.patches.label,  ...
                                ones(1,length(positives)), ...
                                zeros(1, nbr_of_negatives)];
end

validation.patches.image = cat(4, validation.patches.image{:});
validation.patches.label = categorical(validation.patches.label);
validation.patches.length = length(validation.patches.label);