function [positives, edge_positives] = extract_all_positives(img,cell_indexes,radius)
   
    N = length(cell_indexes);
    edge_positives_idx = 1;
    positives_idx = 1;
    normal_patch_size = 2*radius+1;
    
    for i = 1:N
        [x, y] = extract_patch(round(cell_indexes(:,i)), radius, size(img));
        if size(x, 2) < normal_patch_size || size(y, 2) < size(x, 2)
            edge_positives{edge_positives_idx} = img(y,x,:);
            edge_positives_idx = edge_positives_idx + 1;
        else
            positives{positives_idx} = img(y,x,:);
            positives_idx = positives_idx + 1;
        end
    end
    
    
end

