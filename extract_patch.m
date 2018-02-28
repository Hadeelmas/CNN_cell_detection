function [x, y] = extract_patch(midpoint, radius, img_size)
    
    minX = midpoint(1)-radius;
    maxX = minX + 2*radius;
    minY = midpoint(2)-radius;
    maxY = minY + 2*radius;
    
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
    
    x = minX:maxX;
    y = minY:maxY;
    
end

