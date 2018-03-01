function positives = extract_random_positives(img,cell_indexes,radius, nbr_of_positives)



[positive, ~] = extract_all_positives(img,cell_indexes,radius);
N = length(positive);
idx = randperm(N,nbr_of_positives);
positives = positive(idx);

end

