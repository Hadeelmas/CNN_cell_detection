function cropped = crop_cells(cell,radius)
%CROP_CELLS Goes through all the cells and crops them to a radius, using
%the crop_patch function
N = length(cell);
    for i = 1:N
        cell{i} = crop_patch(cell{i},radius);
    end
    cropped = cell;
end

