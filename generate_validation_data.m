
nbr_of_validation = 10;


if ~exist('data','var')
    load_images
end

if ~exist('validation','var')
    validation_set = randperm(length(data.image),nbr_of_validation);
    validation.image = data.image(validation_set);
    validation.cellcenters = data.cellcenters(validation_set);
    data.image(validation_set) = [];
    data.cellcenters(validation_set) = [];
end

