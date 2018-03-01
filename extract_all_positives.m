function [positives, edge_positives] = extract_all_positives(img,cell_indexes,radius)
% Function for extracting all positive examples from an image given a list
% of cell center indexes

    N = length(cell_indexes);
    edge_positives_idx = 1;
    positives_idx = 1;
    normal_patch_size = 2*radius+1;
    
    % for all indexes given for positive cells
    for i = 1:N
        [x, y] = extract_patch(round(cell_indexes(:,i)), radius, size(img));
        if size(x, 2) < normal_patch_size || size(y, 2) < size(x, 2)
            % Add to a special set if they are so called "edge positives
            edge_positives{edge_positives_idx} = img(y,x,:);
            edge_positives_idx = edge_positives_idx + 1;
        else
            % if the indexes did not go outside the image border, add the
            % patch to the positives
            positives{positives_idx} = img(y,x,:);
            positives_idx = positives_idx + 1;
        end
    end
    
    
end

