function positives = extract_random_positives(img,cell_indexes,radius, nbr_of_positives)

% total_extracted = 0;
% 
% 
% while total_extraced < nbr_of_positives
%     
%     idx = randi(length(cell_indexes));
%     extraction_idx = cell_indexes(:,idx);
%     cell_indexes(:,idx) = [];
%     [x, y] = extract_patch(round(extraction_idx), radius, size(img));
%     if size(x, 2) < normal_patch_size || size(y, 2) < size(x, 2)
%     
% end


[positive, ~] = extract_all_positives(img,cell_indexes,radius);
N = length(positive);
idx = randperm(N,nbr_of_positives);
positives = positive(idx);

end

