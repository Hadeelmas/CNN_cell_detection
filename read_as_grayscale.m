function img_gray = read_as_grayscale( path_to_file )

img = read_image(path_to_file);
img_gray = mean(img, 3);

end

