function [x,y] = neg_pts(cells,size,n_pts,radius,threshold)
% takes in positive pts and returns negative pts of an img

i = 0;
lower_bound = radius+1;
upper_bound_x = size(2)-radius-1;
upper_bound_y = size(1) - radius-1;
x = zeros(1,n_pts);
y = zeros(1,n_pts);

while i < n_pts
     x_tmp = rand*(upper_bound_x-lower_bound) + lower_bound; 
     y_tmp = rand*(upper_bound_y-lower_bound) + lower_bound;
     point = [x_tmp;y_tmp];
     
     dist = vecnorm(cells-point);
     
     distance_threshold = sum(dist < threshold);
     
    if (distance_threshold == 0)
        i = i + 1;
        x(i) = x_tmp;
        y(i) = y_tmp;
    end
    
end
end

