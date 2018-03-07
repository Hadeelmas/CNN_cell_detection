% Script that takes training images that were wrongly classified by the net
% and stores them for reuse in training later

% Begin by checking the training data has a 'hard' field and creates it if
% it doesnt already exist.
if ~isfield(training, 'hard')
    training.hard.image = zeros([patch_size, maximum_length_of_hard_examples]);
    training.hard.label = categorical(zeros(1, maximum_length_of_hard_examples));
    training.hard.length = 0;
end

% Make predictions using the net and stores the one that were wrongly
% classified.
for j = 1:length(training.image)
    pred = net.classify(training.image(:,:,:,j));
    if (pred ~= training.label(j))
        
        if training.hard.length < maximum_length_of_hard_examples
            training.hard.length = training.hard.length + 1;
            training.hard.image(:,:,:,training.hard.length) = training.image(:,:,:,j);
            training.hard.label(training.hard.length) =  training.label(j);
        end
        % cleanup the correct classifications
        if training.hard.length == maximum_length_of_hard_examples
           disp(['Hard dataset above ' num2str(maximum_length_of_hard_examples)])
           disp(['Attemtping to remove the patches which has become easy to classify'])
           for k = maximum_length_of_hard_examples:-1:1
               pred_cleanup = net.classify(training.hard.image(:,:,:,k));
                if (pred_cleanup ~= training.hard.label(k))
                    training.hard.image(:,:,:,k) = [];
                    training.hard.label(k) = [];
                    training.hard.length = training.hard.length - 1;
                end
           end
           nbr_removed = abs(maximum_length_of_hard_examples - training.hard.length);
           disp(['successfully removed ' num2str(nbr_removed) ' patches'])
           if nbr_removed < clean_hard
               disp(['Failed to remove more than ' num2str(clean_hard) ' patches'])
               nbr_to_clean_hard = clean_hard - nbr_removed;
               disp(['Removing the ' num2str(nbr_to_clean_hard) ' earliest patches'])
               
               training.hard.image(:,:,:,1:nbr_to_clean_hard) = [];
               training.hard.labels(1:nbr_to_clean_hard) = [];
               training.hard.length = training.hard.labels - nbr_to_clean_hard;
           end
           % finally zeropad
           length_of_set = size(training.hard.label, 2);
           
           training.hard.image = cat(4, training.hard.image, zeros([patch_size, maximum_length_of_hard_examples - length_of_set]));
           training.hard.label = [training.hard.label, categorical(zeros(1, (maximum_length_of_hard_examples-length_of_set)))];
           % and change the flag variable in main
           length_of_hard = training.hard.length;
        end
    end
end