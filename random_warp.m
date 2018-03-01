function warped = random_warp(img)
% function for doing a random small affine warping of an image while
% simultaneously keeping the cells as centered as possible

    target_size = size(img);

    b = rand(1)/4;
    c = rand(1)/4;
    
    % Affine transformation matrix
    A = [1 b;
        c 1];
    t = [- b*target_size(1);
         - c*target_size(2)];
    t = round(t);
    
    target_size(1:2) =  target_size(1:2)+abs(flip(t))';
    warped = affine_warp(target_size, img, A, t);


end

