function cropped_image = crop_patch(image,radius)
% CROP_PATCH: crops an image to a patch of certain radius around the middle
% of the image.

    img_size = size(image);
    mid_point = round(img_size(1:2)/2);
    [cropped_x, cropped_y] = extract_patch(mid_point, radius, img_size);
    cropped_image = image(cropped_x,cropped_y,:);

end

