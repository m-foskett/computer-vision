function [albedo, normals, residuals] = photometricStereo(image_obs, light_dirs)
    
    %Photometric Stereo
    % the vector g(x,y) for each pixel in the scene can be solved for when
    % at least three different lightings are available and a least-squares
    % estimate can be computed when more than three are available:
    %
    % I = Sg(x,y) ==> g(x,y) = S/I
    % 
    % The magnitude of the vector g(x,y) is the albedo of the point (x,y)
    % assuming k = 1
    % Acquire the dimensions of the images in the dataset and the number of
    % images
    [h, w, N] = size(image_obs);
    % Initialise the albedo vector and the surface normals vector
    albedo = zeros(h,w);
    normals = zeros(h,w,3);
    
    % Scan each column of the image
    for col = 1:w
        % Scan each row of the image
        for row = 1:h
            % Convert each image into a double array with range from 0 to 1
            I = reshape(double(image_obs(row,col,:))/255,N,1);
            S = light_dirs; % The point-light source directions vector
            % The vector g contains the albedo value for the pixel and the
            % surface normals vector for the current pixel 
            g = S\I; 
            % Acquire the albedo value from the current pixel
            albedo(row,col) = norm(g);
            % Acquire the surface normals of the current pixel
            normals(row, col, :) = g/norm(g);
        end
    end

    % Improve the accuracy of your approach by developing an outlier 
    % detection and rejection system in your code for recovering the 
    % surface normals
    % For each pixel (x,y), compute the residual between the measured pixel
    % brightness and the pixel brightness predicted by your values for 
    % albedo, surface normal and lighting direction
    % Residual = Observed - Predicted

    % Initialise the predicted image set
    image_pred = uint8(zeros(h, w, N));
    % Loop through the vector of point-light sources
    for i = 1:size(S,1)
        % Acquire a value for the dot product of normals and light source
        dotProd = reshape(normals(:,:,:), h * w, 3) * S(i,:)';
        % Reshape into array
        dotProd = reshape(dotProd, h, w);
        % Given the albedo of the image, multiply with dotProd
        currentImage = uint8(immultiply(albedo, dotProd) * 255);
        % Store image in predicted image set
        image_pred(:,:,i) = currentImage;
    end
    
    
    % Plot the predicted images alongside the observed images
    figure(1);
    subplot(1,2,1);
    montage(reshape(image_obs, h,w,1,N),'Size',[8,8]);
    title('Observed');
    subplot(1,2,2);
    montage(reshape(image_pred, h,w,1,N),'Size',[8,8]);
    title('Predicted');
    
    % Compute the residual between measured and observed pixel brightness
    residuals = uint8(zeros(h, w, N));
    for i = 1:N
        for j = 1:w
            for k = 1:h
                residuals(k,j,i) = image_obs(k,j,i) - image_pred(k,j,i);
            end
        end
    end
    residuals = double(residuals);
    % Produce a plot, for each pixel in each face image (try using montage) 
    % that highlights image regions for which the residual is greater than 
    % two times the standard deviation of residuals for that pixel. 
    highlightImages = uint8(zeros(h,w,N));
    adjustedObs = image_obs;
    for i = 1:N
        for j = 1:w
            for k = 1:h
                res = std(residuals(k,j,:));
                if residuals(k,j,i) > (2*res)
                    highlightImages(k,j,i) = 255;
                    adjustedObs(k,j,i) = 0;
                end
            end
        end
    end
    figure(2);
    montage(reshape(highlightImages, h,w,1,N),'Size',[8,8]);
    title('Residual Outliers');
    % Reimplementing the normals calculation to not use outliers
    % Scan each column of the image
    for col = 1:w
        % Scan each row of the image
        for row = 1:h
            % Convert each image into a double array with range from 0 to 1
            I = reshape(double(adjustedObs(row,col,:))/255,N,1);
            S = light_dirs; % The point-light source directions vector
            % The vector g contains the albedo value for the pixel and the
            % surface normals vector for the current pixel 
            g = S\I; 
            % Acquire the albedo value from the current pixel
            albedo(row,col) = norm(g);
            % Acquire the surface normals of the current pixel
            normals(row, col, :) = g/norm(g);
        end
    end
    
    
    
    % Plotting
    figure(3);
    subplot(2,2,1), imshow(albedo);
    title('Albedo');
    subplot(2,2,2);
    imagesc(normals(:,:,1),[-1,1]);
    title('Surface Normals Horizontal');
    subplot(2,2,3);
    imagesc(normals(:,:,2),[-1,1]);
    title('Surface Normals Vertical');
    subplot(2,2,4);
    imagesc(albedo);
    title('Albedo Colour');

end