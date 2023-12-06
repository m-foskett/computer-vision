function [dataFeatures] = extractDataFeatures(rgb)

        gray = rgb2gray(rgb); % convert to grayscale
        [m,n,o] = size(rgb);
        rows = m; % number of rows
        cols = n; % number of cols
        %% Spatial Histogram/RGB Histogram - Columns and Rows
        
        % For each row of current image
        for j = 1:rows
            % Spatial - Horizontal Histogram

            % Colour - Red Histogram
            redRowHist(1,j) = sum(rgb(j,:,1));
            % Colour - Green Histogram
            greenRowHist(1,j) = sum(rgb(j,:,2));
            % Colour - Blue Histogram
            blueRowHist(1,j) = sum(rgb(j,:,3));
            
        end
        % Normalise the values
        redRowHist(:,:) = redRowHist(:,:) / max(redRowHist(:,:));
        greenRowHist(:,:) = greenRowHist(:,:) / max(greenRowHist(:,:));
        blueRowHist(:,:) = blueRowHist(:,:) / max(blueRowHist(:,:));
        % Get average values
        rrAvg = mean(redRowHist);
        grAvg = mean(greenRowHist);
        brAvg = mean(blueRowHist);
        % Column Spatial Histogram

        % For each row of current image
        for k = 1:cols
            % Horizontal Histogram

            % Colour - Red Histogram
            redColHist(1,k) = sum(rgb(:,k,1));
            % Colour - Green Histogram
            greenColHist(1,k) = sum(rgb(:,k,2));
            % Colour - Blue Histogram
            blueColHist(1,k) = sum(rgb(:,k,3));
        end
        % Normalise the values
        redColHist(:,:) = redColHist(:,:) / max(redColHist(:,:));
        greenColHist(:,:) = greenColHist(:,:) / max(greenColHist(:,:));
        blueColHist(:,:) = blueColHist(:,:) / max(blueColHist(:,:));
        % Get average values
        rcAvg = mean(redColHist);
        gcAvg = mean(greenColHist);
        bcAvg = mean(blueColHist);
        
        %% Circular Hough Transform
        radius = [15 40]; % radius range of circles in image
        objPolarity = 'bright'; % bright or dark circles compared to BG
        sensitivity = 0.85; % higher value for finding weaker circles
        % Find the centers of the bright circles in the image [X Y]
        [centersBright, radii] = imfindcircles(gray,radius,'ObjectPolarity',objPolarity,'Sensitivity',sensitivity); 
        [numCentersBright,ccb] = size(centersBright);
        % Find the centers of the bright circles in the image [X Y]
        objPolarity = 'dark'; % bright or dark circles compared to BG
        [centersDark, radii] = imfindcircles(gray,radius,'ObjectPolarity',objPolarity,'Sensitivity',sensitivity); 
        [numCentersDark,ccb] = size(centersDark);
        % Increase the weight of the circle features by increasing number
        nc = rows;
        circleFeaturesBright = zeros(1,nc);
        circleFeaturesDark = zeros(1,nc);
        for i = 1:nc
            circleFeaturesBright(1,i) = numCentersBright;
            circleFeaturesDark(1,i) = numCentersDark;
        end
        

        %% Edge Detection
        binary = imbinarize(gray); % binarize the image
        method = 'canny'; % use the Canny method
        thresh = []; % Sensitivity thresholds for Canny Method
        sigma = sqrt(2); % Standard deviation of Gaussian filter
        BW = edge(binary,method,thresh,sigma); % perform edge detection
        [SHT,theta,rho] = hough(BW); % perform Hough transform

        % Find the peaks in the Hough Transform matrix above threshold
        numPeaks = 8; % max number of peaks to identify
        houghThreshold = ceil(0.2*max(SHT(:)));
        peaks  = houghpeaks(SHT,numPeaks,'Threshold', houghThreshold);
        % Find line segements from the Hough Transform matrix
        lines = houghlines(BW,theta,rho,peaks);
        nl = length(lines)/10; % normalise value
        % Increase the weight of the edge features by increasing number
        ne = rows;
        edgeFeatures = zeros(1,ne);
        for e = 1:ne
            edgeFeatures(1,e) = nl;
        end
        
        %% Rectangle Detection
        BW = ~imbinarize(gray, graythresh(gray));
        filled = imfill(BW,'holes');
        % Remove small objects from binary image that are smaller than p
        objectSize = 50;
        cleared = bwareaopen(filled, objectSize); 
        labels = bwlabel(cleared);
        regProps = regionprops(labels,'boundingbox');
        scaleFactor = 100; % Adjust this value to change scaled value
        nrec = length(regProps)/scaleFactor;
        nr = rows; % adjust value to adjust weight of features
        rectangleFeatures = zeros(1,nr);
        for recCount = 1:nr
            rectangleFeatures(1,recCount) = nrec;
        end

        %% Texture Filter
        

        
        
        %% Store the extracted data features
        dataFeatures = [redRowHist greenRowHist blueRowHist ... 
    redColHist greenColHist blueColHist circleFeaturesBright circleFeaturesDark edgeFeatures ...
    rectangleFeatures];

end