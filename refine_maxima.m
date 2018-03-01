function refined_maxima = refine_maxima(maxima, B)
%REFINE_MAXIMA Refines the maximas that were generated from propmap B using
%Taylor expansion at the point
%       maxima(1,:) = columns
%       maxima(2,:) = rows
refined_maxima = zeros(2,length(maxima));
for i = 1:length(maxima)
    maxima_i = maxima(:,i);
    patch = zeros(3,3);
    % The middle point is the actual maxima
    patch(2,2) = B(maxima_i(2), maxima_i(1));
    patch(1,1) = B(maxima_i(2)-1, maxima_i(1)-1);
    patch(1,2) = B(maxima_i(2)-1, maxima_i(1));
    patch(1,3) = B(maxima_i(2)-1, maxima_i(1)+1);
    patch(2,1) = B(maxima_i(2), maxima_i(1)-1);
    patch(2,3) = B(maxima_i(2), maxima_i(1)+1);
    patch(3,1) = B(maxima_i(2)+1, maxima_i(1)-1);
    patch(3,2) = B(maxima_i(2)+1, maxima_i(1));
    patch(3,3) = B(maxima_i(2)+1, maxima_i(1)+1);
    [x, y] = subpixel_precision(patch);
    refined_maxima(:,i) = round(maxima_i+[x;y]);
end

