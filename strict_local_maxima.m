function maxima = strict_local_maxima(image, threshold, gaussian_std)
%STRICT_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here

image = imgaussfilt(image, gaussian_std);


filter_size = 9;
maximum = filter_size*filter_size;
filter_max = ones(filter_size,filter_size);

B = ordfilt2(image,maximum,filter_max, 'symmetric');


filt_mat = ones(filter_size, filter_size);
midpoint = round(size(filt_mat)/2);
filt_mat(midpoint(1),midpoint(2)) = 0;
temp_adj = ordfilt2(image, maximum-1, filt_mat, 'symmetric');
temp_adj = (B>temp_adj).*B;
maxima = (temp_adj > threshold);
[A, B] = find(maxima == 1);
maxima = [B';A'];

end

