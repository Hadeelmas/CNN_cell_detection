function negatives = extract_random_negatives(img,cell_indexes,radius, nbr_of_negatives)
threshold = radius;
img_size = size(img);
[x_mid,y_mid] = neg_pts(cell_indexes, img_size, nbr_of_negatives, radius, threshold);
N = length(x_mid);
negatives = cell (1,N);
for i = 1:N
    x_mid = round(x_mid); y_mid = round(y_mid);
    [x, y] = extract_patch([x_mid(i),y_mid(i)], radius, img_size(1:2));
    negatives{i} = img(y,x,:);
end
end

