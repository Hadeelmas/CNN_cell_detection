function [x, y] = subpixel_precision(patch)
%SUBPIXEL_MAX Takes in a 3x3 patch and approximates the position of the 
%local maxima using second order Taylor expansion and returns the 
% coordinate of the true local_maxima
%   Assuming that the 5th element (middle element) is the local maxima
%   (x;y) = - H^-1*delta*f

% Use quotient approximations
% First order derivatives:
f_x = (patch(3,2) - patch(1,2))/2;
f_y = (patch(2,3) - patch(2,1))/2;
grad = [f_x;f_y];
% Second order derivatives:
f_xy = (patch(3,3) + patch(3,1) - patch(1,1) - patch(1,3))/4;
f_xx = (patch(2,1) + patch(2,3) - 2*patch(2,2))/1^2;
f_yy = (patch(1,2) + patch(3,2) - 2*patch(2,2))/1^2;
H = [f_xx, f_xy;
    f_xy, f_yy];
approx = -inv(H)*grad;
x = approx(1); 
y = approx(2);
end

