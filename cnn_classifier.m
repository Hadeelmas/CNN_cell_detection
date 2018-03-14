function layers = cnn_classifier(patch_size)

layers = [
        imageInputLayer(patch_size, 'Normalization', 'none');
        convolution2dLayer([3,3], 20);
        batchNormalizationLayer();
        reluLayer();
        dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
        convolution2dLayer([3,3], 40);
        batchNormalizationLayer();
        
        convolution2dLayer([3,3], 80);
        %batchNormalizationLayer();
        %reluLayer();
        %maxPooling2dLayer([2,2], 'Stride', 2);
        maxPooling2dLayer([2,2], 'Stride', 2, 'Padding',[1 0 1 0] );
        dropoutLayer(0.1);
        convolution2dLayer([3,3], 160);
        batchNormalizationLayer();
        reluLayer();
        dropoutLayer(0.05);
        convolution2dLayer([3,3], 320);
        batchNormalizationLayer();
        reluLayer();
        dropoutLayer(0.1);
        convolution2dLayer([3,3], 640);
        batchNormalizationLayer();
        reluLayer();
        dropoutLayer(0.05);
        convolution2dLayer([3,3], 1280);
        batchNormalizationLayer();
                reluLayer();

        dropoutLayer(0.05);
        convolution2dLayer([2,2], 2);
        batchNormalizationLayer();
        softmaxLayer();
        pixelClassificationLayer()];


end
%      layers = [
%         imageInputLayer(patch_size, 'Normalization', 'none');
%         convolution2dLayer([3,3], 10);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
%         convolution2dLayer([3,3], 20);
%         batchNormalizationLayer();
%         %maxPooling2dLayer([2,2], 'Stride', 2, 'Padding',[1 0 1 0] );
%         convolution2dLayer([3,3], 20);
%         batchNormalizationLayer();
%         reluLayer();
%         %maxPooling2dLayer([2,2], 'Stride', 2);
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 40);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 40);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 320);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 320);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         convolution2dLayer([3,3], 2);
%          batchNormalizationLayer();
% 
%         softmaxLayer();
%         pixelClassificationLayer()];

% 
%      layers = [
%         imageInputLayer(patch_size, 'Normalization', 'none');
%         convolution2dLayer([3,3], 10);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
%         convolution2dLayer([3,3], 20);
%         batchNormalizationLayer();
%         maxPooling2dLayer([2,2], 'Stride', 2, 'Padding',[1 0 1 0] );
%         convolution2dLayer([3,3], 40);
%         batchNormalizationLayer();
%         reluLayer();
%         %maxPooling2dLayer([2,2], 'Stride', 2);
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 320);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         convolution2dLayer([4,4], 2);
%         softmaxLayer();
%         pixelClassificationLayer()];

%      layers = [
%         imageInputLayer(patch_size, 'Normalization', 'none');
%         convolution2dLayer([3,3], 10);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.05); %http://mipal.snu.ac.kr/images/1/16/Dropout_ACCV2016.pdf
%         convolution2dLayer([3,3], 20);
%         batchNormalizationLayer();
%         %maxPooling2dLayer([2,2], 'Stride', 2, 'Padding',[1 0 1 0] );
%         convolution2dLayer([3,3], 40);
%         batchNormalizationLayer();
%         reluLayer();
%         %maxPooling2dLayer([2,2], 'Stride', 2);
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 80);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 160);
%         batchNormalizationLayer();
%         reluLayer();
%         dropoutLayer(0.1);
%         convolution2dLayer([3,3], 320);
%         batchNormalizationLayer();
%         %reluLayer();
%         %dropoutLayer(0.1);
%         convolution2dLayer([3,3], 2);
%         %batchNormalizationLayer();
%         %convolution2dLayer([4,4], 2);
%         softmaxLayer();
%         pixelClassificationLayer()];