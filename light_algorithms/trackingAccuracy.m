function trackingAccuracy(algorithm_data, validation_data)
    
    % Variable Substitution - for simplicity
    ad = algorithm_data;
    vd = validation_data;
    % True Positives: number of times you have correctly identified bricks 
    % (i.e. how many instances of “true” brick locations you have detected 
    % a brick within a pixel distance of 50 pixels which is of the correct 
    % colour type) 
    tp = 0;
    % True Positives (wrong colour): number of times you have correctly 
    % identified bricks (i.e. how many instances of “true” brick locations 
    % you have detected a brick within a pixel distance of 50 pixels) but 
    % incorrectly identified the brick colour.
    tpwc = 0;
    % False Positives: number of times you have detected a brick, but there
    % is no corresponding brick within 50 pixels of that centroid. 
    fp = 0;
    % False Negatives: number of “true” brick locations for which you have 
    % not detected a brick within 50 pixels of that centroid.
    fn = 0;

    % Validating the Data 
    % Check that the structs are of the same size
    n = size(vd,2);
    n2 = size(ad,2);
    if n ~= n2
        n = n2;
    end
    % Loop through the structs for the four Cases
    for i = 1:n
       % Get current image data
       a = ad(n);
       v = vd(n);
       % Get the colours of the data
       a_col = a.colours;
       v_col = v.colours;
       % Get the centroids of the data
       a_cen = a.center;
       v_cen = v.center;
       % Get the number of bricks in the current image
       nc = size(a_cen,1);
       
       % Looping Through Data
       n = 90;
       for j = 1:nc
           res = 1; % reset to false negative by default
           for k = 1:nc
                   X = [a_cen(j,1),a_cen(j,2); v_cen(k,1), v_cen(k,2)];
                   d = pdist(X, 'euclidean');
                   a_cc = string(a_col(j));
                   v_cc = string(v_col(k));
                   % True Positives Check
                   if (strcmp(a_cc,v_cc) && (d < n))
                       res = 4;
                   % True Positives (wrong colour) check
                   elseif (d < n && res ~= 4)
                       res = 3;
                   % False Positives check
                   elseif (d >= n && res ~= 3 && res ~= 4)
                       res = 2;
                   % False Negatives (covered by default)
                   end
           end
           switch res
               case 4
                   tp = tp + 1;
               case 3
                   tpwc = tpwc + 1;
               case 2
                   fp = fp + 1;
               otherwise
                   fn = fn + 1;
           end
       end    
    end
    % Print the results
    fprintf('True Positives: %d\n',tp);
    fprintf('True Positives (wrong colour): %d\n',tpwc);
    fprintf('False Positives: %d\n',fp);
    fprintf('False Negatives: %d\n',fn);
    
end