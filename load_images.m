% Script for loading all images and data in CNN-cell_counting.
% CNN-cell_counting must be in the same folder as this script

addpath(genpath(fileparts(which('load_images.m'))));
clear all

for i = 1:50
    img_filename = ['img_' num2str(i) '.png'];
    data.image{i} = read_image(img_filename);
    load(['img_' num2str(i) '.mat']);
    data.cellcenters{i} = cells;
end
