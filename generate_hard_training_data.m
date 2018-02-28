    
if ~isfield(training, 'hard')
    training.hard.image = [];
    training.hard.label = [];
end


for j = 1:length(training.image)
    pred = net.classify(training.image(:,:,:,j));
    if (pred ~= training.label(j))
        training.hard.image = cat(4, training.hard.image ,training.image(:,:,:,j));
        training.hard.label = [training.hard.label, training.label(j)];
    end
end