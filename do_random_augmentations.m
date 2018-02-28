function cell_with_augmented_data = do_random_augmentations(cells, nbr_of_datacells)
  
N = length(cells);
cell_with_augmented_data = cells;
cell_with_augmented_data{nbr_of_datacells} = [];

for i = N+1:nbr_of_datacells
    cell_idx = randi(N);
    img = cells{cell_idx};
    
    nbr_of_augmentations = randi(5);
    augmentation_choser = randperm(5,nbr_of_augmentations);
    for j = 1:nbr_of_augmentations
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
        end
    end  
    cell_with_augmented_data{i} = img;
end
end

