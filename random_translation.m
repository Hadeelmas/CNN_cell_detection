function translated_img = random_translation(img)
 
    upper_bound = 5;
    t = randi(2*upper_bound, 1, 2)-upper_bound;
    translated_img = imtranslate(img,t);

end

