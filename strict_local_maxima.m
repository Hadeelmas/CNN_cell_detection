function maxima = strict_local_maxima(image, threshold, gaussian_std)
% STRICT_LOCAL_MAXIMA Function that returns the coordinates of local maximas in an image.
% It gaussian filters the image and then applies the threshold.
% After doing that it finds local maximas in the image.
    % Maxima is a [2,N] large vector of positions of the center of the
    % detected objects.
% Gaussian filter, using Matlab's inbuilt function
gaus_img = imgaussfilt(image, gaussian_std);
% Max filtering of the image
max_img = ordfilt2(gaus_img,9,ones(3,3), 'symmetric');
% Finding the max neighbours
filt_mat = [1 1 1; 1 0 1; 1 1 1];
neighbours_img = ordfilt2(gaus_img,8,filt_mat, 'symmetric');
% Extract the true local maximas
lmax_img = (max_img>neighbours_img).*max_img;
% Apply the threshold
tlmax_img = (lmax_img > threshold);
% Create the maxima vector using the find function.
[A, B] = find(tlmax_img==1);
maxima=[B';A'];
end

