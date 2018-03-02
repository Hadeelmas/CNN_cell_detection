indexes = randperm(validation.patches.length);
nbr_of_missclassifications = 0;
validation.missclassified.image = {};
validation.missclassified.label = [];
for i = 1:validation.patches.length
    pred = net.classify(validation.patches.image(:,:,:,i));

    if (pred ~= validation.patches.label(i))
        nbr_of_missclassifications = nbr_of_missclassifications + 1;
        validation.missclassified.image = [validation.missclassified.image, validation.patches.image(:,:,:,i)];
        validation.missclassified.label = [validation.missclassified.label, validation.patches.label(i)];
    end
end

missclass_nbr = ['Number of missclassifications are ' num2str(nbr_of_missclassifications)];
missclass_total = ['Total number of validation examples are ' num2str(validation.patches.length)];
missclass_precentage = ['Your network are correct in ' num2str((validation.patches.length-nbr_of_missclassifications)*100/validation.patches.length) ' % of the cases'];
disp(missclass_nbr);
disp(missclass_total);
disp(missclass_precentage);