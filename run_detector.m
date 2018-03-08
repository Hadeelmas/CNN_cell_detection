function detections = run_detector(img)

    addpath(genpath(fileparts(which('run_detector.m'))));
    net_path = ['my_network.mat'];
    load(net_path)
    
    gaussian_std = 2;
    maxima = strict_local_maxima(B, 0.5, gaussian_std);
    refined_maxima = refine_maxima(maxima, img, gaussian_std);
    x_refmaxima = (refined_maxima(1,:) - 1) * stride + 1;
    y_refmaxima = (refined_maxima(2,:) - 1) * stride + 1;
    detections = [x_refmaxima; y_refmaxima];
    
end

