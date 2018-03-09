function zero_padded_positives = extract_all_positives_zeropadded(img,cell_indexes,radius)

[positives, ~, edge_positives_padded] = extract_all_positives(img,cell_indexes,radius);
zero_padded_positives = [positives, edge_positives_padded];

end

