function translated_img = random_translation(img)
 
    upper_bound = 5;
    t = randi(upper_bound, 1, 2);
    translated_img = imtranslate(img,t);

end

