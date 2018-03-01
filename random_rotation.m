function rotated_img = random_rotation(img)
% Function for random rotating an image. Gets zeropadded to a square
    % Random angle to rotate
    angle = randi(360);
    rotated_img = imrotate(img, angle);
end

