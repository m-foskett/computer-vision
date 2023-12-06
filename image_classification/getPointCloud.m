function worldPoints = getPointCloud(IL_C, IR, stereoParams, i)
    

    %% SURF
    % Extract interest points using the SURF (Speeded Up Robust Features) method
    ROI = [230,260,190,260]; % Region of Interest [X Y WIDTH HEIGHT] for corner detection
    metricThresh = 1000; % Threshold for selecting strongest features
    numOctaves = 1; % Number of octaves to use, 1 - 4, increase to detect larger blobs
    numScaleLevels = 3; % Number of scale levels to compute per octave, 3 - 6, increase to detect more blobs at finer scale
    IL = rgb2gray(IL_C); % Convert to grayscale
    points_L = detectSURFFeatures(IL, 'MetricThreshold', metricThresh, 'NumOctaves', numOctaves, 'NumScaleLevels', numScaleLevels);
    points_R = detectSURFFeatures(IR, 'MetricThreshold', metricThresh, 'NumOctaves', numOctaves, 'NumScaleLevels', numScaleLevels);
    
    % Extract feature vectors/descriptors from the acquired SURF points and
    % validPoints corresponding to each of the descriptors
    SURFSize = 64; % Length of the SURF descriptor, 64 or 128
    [features_L, validPoints_L] = extractFeatures(IL,points_L, 'SURFSize', SURFSize);
    [features_R, validPoints_R] = extractFeatures(IR,points_R, 'SURFSize', SURFSize);
    %%
    
    
    
    
    
    
    %% Feature Matching
    % Find the matching features across the stereo image pair by acquiring
    % indices corresponding to features most likely to match between the
    % left and right feature descriptors
    % Set the 'Unique' parameter to true to remove non-unique matches
%     method = 'Exhaustive'; % Computes pair-wise distance between the left and right features
%     matchThreshold = 5; % 0 < threshold < 100, specifies the distance threshold percentage required for the match, increase thresh for more matches
%     , 'Unique', true, 'Method', method, 'MatchThreshold', matchThreshold

    indexPairs = matchFeatures(features_L, features_R);
    matchedPoints_L = validPoints_L(indexPairs(:, 1));
    matchedPoints_R = validPoints_R(indexPairs(:, 2));
    
%     % Display corresponding feature points on the original images
%     displayMethod = 'falsecolor'; % false colour overlay of images or montage
%     figure(2); showMatchedFeatures(IL_C,IR,matchedPoints_L,matchedPoints_R, displayMethod);
%     legend('Unique matched points left','Unique matched points right');
%     titleStr = ['Stereo Pair ',num2str(i)];
%     title(titleStr);
    
    % Outlier Rejection Process
    
    % Undistort the points by correcting for lens distortion using numeric
    % non-linear least-squares optimisation
    leftParams = stereoParams.CameraParameters1;
    rightParams = stereoParams.CameraParameters2;
    undistortedPoints1 = undistortPoints(matchedPoints_L.Location, leftParams);
    undistortedPoints2 = undistortPoints(matchedPoints_R.Location, rightParams);
    
    % Estimate Fundamental Matrix, F, from corresponding points in stereo
    % images and exclude the outliers using RANSAC
    method = 'RANSAC'; % method used to compute F, can also use LMedS, least median of squares
    numTrials = 100; % number of random trials for finding the outliers (MSAC - max num, LMedS - exact num)
    distanceThreshold = 0.05; % Sampson distance threshold for finding outliers (0.01 default) (MSAC)
    confidence = 99; % Confidence percentage for finding the max number of inliers (MSAC)
    [F,inliersIndex] = estimateFundamentalMatrix(undistortedPoints1,undistortedPoints2,...
    'Method', method, 'NumTrials', numTrials, 'DistanceThreshold', distanceThreshold, 'Confidence', confidence);
    % Acquire the inliers used to calculate the fundamental matrix
    inliers = find(inliersIndex == 1);
    
    % Remove the outliers
    matchedPoints_L = matchedPoints_L(inliers,:);
    matchedPoints_R = matchedPoints_R(inliers,:);
    
    % Plot the sets of inlier correspondences
%     displayMethod = 'falsecolor'; % false colour overlay of images or montage
%     figure; showMatchedFeatures(IL_C, IR, matchedPoints_L, matchedPoints_R, displayMethod);
%     legend('Unique inlier matched points left','Unique inlier matched points right');
%     titleStr = ['Stereo Pair ',num2str(i)];
%     title(titleStr);
    
    % Use the matched feature points to produce a set of corresponding 3D
    % points in space with respect to the left camera's frame of reference for
    % the N stereo pairs
    % Find 3D locations of matching points 
    worldPoints = triangulate(matchedPoints_L, matchedPoints_R, stereoParams);

%     % Get the average
%     average = mean(worldPoints);
%     disp(average);
%     figure;
%     hold on;
%     plot3(worldPoints(:,1), worldPoints(:,3), worldPoints(:,2), 'ro');

end