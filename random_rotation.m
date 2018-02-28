function rotated_img = random_rotation(img)
angle = randi(360);
rotated_img = imrotate(img, angle);
end

