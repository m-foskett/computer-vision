function [locations, dims, colours] = colourTrackBricks(RGB)

    % Primarily using the brick colours in combination with morphological
    % properties (size and shape of segmented regions)
    %
    % Colour Thresholding: must be robust for varying ambient light
    
    % Colour Segmenting Algorithm
    originalRGB = RGB;
    hsvImage = rgb2hsv(RGB);
    H = hsvImage(:,:,1) .* 360;
    S = hsvImage(:,:,2) .* 100;
    V = hsvImage(:,:,3) .* 100;

%     figure(1);
%     subplot(2,1,1), imshow(RGB);
%     title('RGB Image');

    %% Acquire the Brick Locations, Dimensions and Labels
    
    colourThresholds = [
        % Red
        346, 14, 52, 98 22, 104;
        % Orange
        4, 36, 68, 98, 22, 104;
        % Yellow
        36, 77, 68, 98, 22, 98;
        % Dark Green
        100, 178, 68, 100, 20, 98;
        % Light Green
        72, 100, 62, 100, 50, 98;
        % Blue
        180, 235, 62, 100, 50, 98
        ];
    
    %Colours 
    colour_bank = {'red', 'orange', 'yellow', 'darkgreen', 'lightgreen', 'blue'};
    % Parameters
    colours = {};
    centroids = [];
    dims = [];
    % Loop through all the colour masks
    nc = 6; % Number of colours
    for i = 1:nc
        
        % Create mask based on chosen histogram thresholds
        if i == 1
            BW = (H >= colourThresholds(i,1) | H <= colourThresholds(i,2)) & ...
            S >= colourThresholds(i,3) & S <= colourThresholds(i,4) & ...
            V >= colourThresholds(i,5) & V <= colourThresholds(i,6);
        else
            BW = ( H >= colourThresholds(i,1) & H <= colourThresholds(i,2) ) & ...
            S >= colourThresholds(i,3) & S <= colourThresholds(i,4) & ...
            V >= colourThresholds(i,5) & V <= colourThresholds(i,6);
        end
        
        % Parameters
        string = 'square';
        n1 = 10;
        n2 = 15;
        se1 = strel(string,n1);
        se2 = strel(string,n2);
        % Cleaning Images
        BW = imdilate(BW,se1);
        BW = imclose(BW,se2);
        BW = imfill(BW,'holes');
        
        figure (2);
        imshow(BW);
        hold on;
        
        % Acquire connected components
        CC = bwconncomp(BW);
        L = bwlabel(BW);
%         % Area
        a = regionprops(CC, 'Area');
        area = [];
        area = cat(1,area,a.Area);
        n = size(area,1);
        % Loop through areas and find largest
        maxArea = 0;
        maxIdx = 1;
        for j = 1:n
            if area(j) > maxArea
                maxArea = area(j);
                maxIdx = j;
            end
        end
        
        % Centroids
        c = regionprops(CC, 'Centroid');
        current = [];
        current = cat(1,current,c.Centroid);
        centroids = cat(1,centroids,current(maxIdx,:));
        if current ~= 0
            colours = [colours colour_bank(i)];
        end
        
        % Dimensions of Bounding Box
        b = regionprops(CC, 'BoundingBox');
        current = [];
        current = cat(1,current,b.BoundingBox);
        
%         dims = cat(1,dims,dims(maxIdx,:));
    end

    % Display Binary Image with Centoids
    figure(2);
    imshow(BW);
    hold on;
    plot(centroids(:,1),centroids(:,2), 'r*');
    hold off;
    
    locations = centroids;
    % Display the colours as text on image
    originalRGB = insertText(originalRGB,locations,colours,'FontSize',18,'BoxColor','yellow','BoxOpacity',0.4,'TextColor','white');
    figure(3);
    imshow(originalRGB);
 
end