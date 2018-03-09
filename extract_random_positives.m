function positives = extract_random_positives(img,cell_indexes,radius, nbr_of_positives)
% Function for extracting some random positive cell patches from an image
% of cells.

    % Extract all positive patches
    positive = extract_all_positives_zeropadded(img,cell_indexes,radius);
    N = length(positive);
    idx = randperm(N,nbr_of_positives);
    % choose some at random
    positives = positive(idx);

end

