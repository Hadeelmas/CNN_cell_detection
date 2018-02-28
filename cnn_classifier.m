function layers = cnn_classifier(patch_size)
%BASIC_CNN_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

     layers = [
        imageInputLayer(patch_size, 'Normalization', 'none');
        convolution2dLayer([5,5], 20);
        batchNormalizationLayer();
        reluLayer();
        maxPooling2dLayer([2,2], 'Stride', 2);
        convolution2dLayer([5,5], 40);
        batchNormalizationLayer();
        reluLayer();
        maxPooling2dLayer([2,2], 'Stride', 2);
        fullyConnectedLayer(2);
        softmaxLayer();
        pixelClassificationLayer()];

end
