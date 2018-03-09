function cell_with_augmented_data = do_random_augmentations(cells, nbr_of_datacells)
%DO_RANDOM_AUGMENTATIONS Inputs: CELLS list cells, in each cell is an image
% nbr_of_datacells is the total number of data cells that will be used for
% training the network, augmented and not augmented.
N = length(cells);
cell_with_augmented_data = cells;
cell_with_augmented_data{nbr_of_datacells} = [];

for i = N+1:nbr_of_datacells
    cell_idx = randi(N);
    img = cells{cell_idx};
    % Randomly choose which augmentations to do on each image that is to be
    % augmented.
    nbr_of_aug_func = 6;
    nbr_of_aug = randi(nbr_of_aug_func);
    augmentation_choser = randperm(nbr_of_aug_func,nbr_of_aug);
    if rand > 2
        augmentation_choser = [augmentation_choser, 7];
    end
    for j = 1:length(augmentation_choser)
        switch augmentation_choser(j)
            case 1
                img = random_rotation(img);
            case 2
                img = random_warp(img);
            case 3
                img = random_rescale(img);
            case 4
                img = random_contrast(img);
            case 5
                img = random_noise(img);
            case 6
                img = random_smoothing(img);
            case 7
                img = random_translation(img);
        end
    end  
    % Append the augmented image.
    cell_with_augmented_data{i} = img;
end
end

