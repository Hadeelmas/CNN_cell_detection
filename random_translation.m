function translated_img = random_translation(img)
 
    upper_bound = 15;
    if rand > 0.8
        t = randi(2*upper_bound, 1, 2)-upper_bound;
    else
        t = randi(2*upper_bound) - upper_bound;
        t = [t, t];
    end
    translated_img = imtranslate(img,t);

end

