function detections = run_detector(img)

    addpath(genpath(fileparts(which('run_detector.m'))));
    net_path = ['my_network.mat'];
    load(net_path)
    stride = 4; % From 2 maximum pooling 2x2 
    probmap = sliding_fcn(net, img);
    probmap_pos = probmap(:,:,2);
    gaussian_std = 1;
    
    maxima = strict_local_maxima(probmap_pos, 0.5, gaussian_std);
    refined_maxima = refine_maxima(maxima, probmap_pos, gaussian_std);
    x_refmaxima = (refined_maxima(1,:) - 1) * stride + 1;
    y_refmaxima = (refined_maxima(2,:) - 1) * stride + 1;
    detections = [x_refmaxima; y_refmaxima];
    
end

