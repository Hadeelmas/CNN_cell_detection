% Script that takes training images that were wrongly classified by the net
% and stores them for reuse in training later

% Begin by checking the training data has a 'hard' field and creates it if
% it doesnt already exist.
if ~isfield(training, 'hard')
    training.hard.image = [];
    training.hard.label = [];
end

% Make predictions using the net and stores the one that were wrongly
% classified.
for j = 1:length(training.image)
    pred = net.classify(training.image(:,:,:,j));
    if (pred ~= training.label(j))
        training.hard.image = cat(4, training.hard.image ,training.image(:,:,:,j));
        training.hard.label = [training.hard.label, training.label(j)];
    end
end

training.hard.length = length(training.hard.label);