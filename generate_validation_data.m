% Script to generate validation data
nbr_of_validation = 10;


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

