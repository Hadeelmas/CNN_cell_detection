function layers = cnn_classifier(patch_size)


     layers = [
        imageInputLayer(patch_size, 'Normalization', 'none');
        convolution2dLayer([3,3], 10);
        batchNormalizationLayer();
        reluLayer();
        dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
        convolution2dLayer([3,3], 20);
        batchNormalizationLayer();
        maxPooling2dLayer([2,2], 'Stride', 2, 'Padding',[1 0 1 0] );
        convolution2dLayer([3,3], 40);
        batchNormalizationLayer();
        reluLayer();
        maxPooling2dLayer([2,2], 'Stride', 2);
        dropoutLayer(0.1);
        convolution2dLayer([3,3], 80);
        batchNormalizationLayer();
        reluLayer();
        convolution2dLayer([3,3], 160);
        batchNormalizationLayer();
        %maxPooling2dLayer([2,2], 'Stride', 2);
        convolution2dLayer([2,2], 2);
        softmaxLayer();
        pixelClassificationLayer()];

end

% dropoutLayer
% patch size 27 x 27 (i think?)
%      layers = [
%         imageInputLayer(patch_size, 'Normalization', 'none');
%         convolution2dLayer([3,3], 10);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
%         convolution2dLayer([3,3], 20);
%         maxPooling2dLayer([2,2], 'Stride', 2);
%         convolution2dLayer([3,3], 40);
%         batchNormalizationLayer();
%         reluLayer();
%         maxPooling2dLayer([2,2], 'Stride', 2);
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         convolution2dLayer([3,3], 2);
%         reluLayer();
%         softmaxLayer();
%         pixelClassificationLayer()];
