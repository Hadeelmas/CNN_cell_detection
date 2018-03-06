function refined_maxima = refine_maxima(maxima, B, std)

%REFINE_MAXIMA Refines the maximas that were generated from propmap B using
%Taylor expansion at the point
%       maxima(1,:) = columns
%       maxima(2,:) = rows
    B = imgaussfilt(B, std);
    refined_maxima = zeros(2,length(maxima));
    warning('off','all');
    for i = 1:length(maxima)
        maxima_i = maxima(:,i);
        %patch = zeros(3,3);
        % The middle point is the actual maxima
        patch = B(maxima_i(2)-1:maxima_i(2)+1, maxima_i(1)-1:maxima_i(1)+1);
        [x, y] = subpixel_precision(patch);
        refined_maxima(:,i) = (maxima_i+[x;y]);
    end

    warning('on','all');
end

