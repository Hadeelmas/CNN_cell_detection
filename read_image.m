function img = read_image( path_to_file )

raw_image = imread(path_to_file);
img = im2double(raw_image);


end

