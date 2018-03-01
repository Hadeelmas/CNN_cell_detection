function [x, y] = extract_patch(midpoint, radius, img_size)
% Function for extracting a patch of an image from a midpoint with  a
% certain radius. If the indexes is out of the bounds of the image, sets
% the indexes to the boarders.

    minX = midpoint(1)-radius;
    maxX = minX + 2*radius;
    minY = midpoint(2)-radius;
    maxY = minY + 2*radius;
    % Border conditions
    if minX < 1
        minX = 1;
    end
    if minY < 1
        minY = 1;
    end
    if maxX > img_size(2)
        maxX = img_size(2);
    end
    if maxY > img_size(1)
        maxY = img_size(1);
    end
    % Generate x and y
    x = minX:maxX;
    y = minY:maxY;
    
end

