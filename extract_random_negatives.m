function negatives = extract_random_negatives(img, cell_indexes, ... 
                                            radius, nbr_of_negatives)
% Function for extract random negative patches. The patches must not be
% any closer to a positive centre 

    threshold = radius;
    img_size = size(img);
    % Extract the midpoint of N number of negative patches that are not too
    % close to a cell centre
    [x_mid,y_mid] = neg_pts(cell_indexes, img_size, nbr_of_negatives, ...
                            radius, threshold);
    % Generate N number of negative patches
    N = length(x_mid);
    negatives = cell (1,N);
    for i = 1:N
        x_mid = round(x_mid); y_mid = round(y_mid);
        [x, y] = extract_patch([x_mid(i),y_mid(i)], radius, img_size(1:2));
        % Add them all in to a cell of negative patches
        negative = img(y,x,:);
        if rand > 0.7
            negative = random_translation(negative);
        end
        negatives{i} = negative;
    end
end

