function [heightMap] = recoverHeight(albedo, normals)
    
    % recoverHeight
    % Recovers a 3D height image of each subject’s face using numerical 
    % integration across the image in the x and y directions. 
    
    
    % Set the height of the top left pixel to be zero as a starting point 
    % for each path integral. 
    [h,w,N] = size(normals);
    heightMap = zeros(h,w);
    heightMapHorizontal = heightMap;
    heightMapVertical = heightMap;
    horizontalNormals = normals(:,:,1)./normals(:,:,3);
    verticalNormals = normals(:,:,2)./normals(:,:,3);
    % Integrate in the horizontal direction along the top row first, 
    % then down each column
    heightMapHorizontal(1,:) = cumsum(horizontalNormals(1,:)) - verticalNormals(1,1);
    for i =1:w
        heightMapHorizontal(2:end,i) = heightMapHorizontal(1,i) + cumsum(verticalNormals(2:end,i));
    end
    % Integrate in the vertical direction first along the first column, 
    % then across each row
    heightMapVertical(:,1) = cumsum(verticalNormals(:,1)) - verticalNormals(1,1);
    for i =1:h
        heightMapVertical(i,2:end) = heightMapVertical(i,1) + cumsum(horizontalNormals(i,2:end));
    end
    % The average of height as computed by (a) and (b) 
    heightMap = (heightMapHorizontal + heightMapVertical)/2;

end