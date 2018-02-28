function cropped = crop_cells(cell,radius)
    N = length(cell);
    for i = 1:N
        cell{i} = crop_patch(cell{i},radius);
    end
    cropped = cell;
end

