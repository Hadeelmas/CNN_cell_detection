

for i = 1:50
    img_filename = ['img_' num2str(i) '.png'];
    data.image{i} = read_image(img_filename);
    load(['img_' num2str(i) '.mat']);
    data.cellcenters{i} = cells;
end
