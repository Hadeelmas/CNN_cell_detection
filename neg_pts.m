function [x,y] = neg_pts(cells, size, n_pts, radius, threshold)
% Function for extracting indexes that are outside a radius (threshold) 
% from a positive cell centra. Radius is the bounds of the image (image
% size - the radius of the patch we want to extract to prevent it from
% generating indexes outside of an extractable index)

    i = 0;
    lower_bound = radius+1;
    upper_bound_x = size(2)-radius-1;
    upper_bound_y = size(1) - radius-1;
    x = zeros(1,n_pts);
    y = zeros(1,n_pts);

    while i < n_pts
         % Generate random index that are inside of the image
         x_tmp = rand*(upper_bound_x-lower_bound) + lower_bound; 
         y_tmp = rand*(upper_bound_y-lower_bound) + lower_bound;
         point = [x_tmp;y_tmp];
         dist = vecnorm(cells-point);
         distance_threshold = sum(dist < threshold);
        % If the distance is outside of the radius (threshold) of a cell
        % center then add it to the set of negative indexes
        if (distance_threshold == 0)
            i = i + 1;
            x(i) = x_tmp;
            y(i) = y_tmp;
        end

    end
end

