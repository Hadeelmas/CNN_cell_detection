function translated_img = random_translation(img)
    % Random translation of an image. This function is to create negative
    % edge samples
    upper_bound = 13;
    if rand > 0.8
        t = randi(2*upper_bound, 1, 2)-upper_bound;
    else
        t = randi(2*upper_bound) - upper_bound;
        t = [t, t];
    end
    translated_img = imtranslate(img,t);

end

