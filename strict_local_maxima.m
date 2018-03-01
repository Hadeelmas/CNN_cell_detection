function maxima = strict_local_maxima(image, threshold, gaussian_std)
% STRICT_LOCAL_MAXIMA Function that returns the coordinates of local maximas in an image.
% It gaussian filters the image and then applies the threshold.
% After doing that it finds local maximas in the image.
    % Maxima is a [2,N] large vector of positions of the center of the
    % detected objects.
% Gaussian filter, using Matlab's inbuilt function
gaus_img = imgaussfilt(image, gaussian_std);
% n by n you want to do non maximum supression on. Must be odd!
n = 3;
% Max filtering of the image
max_img = ordfilt2(gaus_img,n*n,ones(n), 'symmetric');
% Finding the max neighbours
filt_mat = ones(n); filt_mat(round(n/2),round(n/2)) = 0;
neighbours_img = ordfilt2(gaus_img,n*n-1,filt_mat, 'symmetric');
% Extract the true local maximas
lmax_img = (max_img>neighbours_img).*max_img;
% Apply the threshold
tlmax_img = (lmax_img > threshold);
% Create the maxima vector using the find function.
[A, B] = find(tlmax_img==1);
maxima=[B';A'];
end

