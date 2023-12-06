function [class_labels, dataFeatures] = assign2_sceneclassifier(image_path)
    
    % Create the Model 
    [KNN, imageSet] = createModel;
    % Extract features from current image
    im = imread(image_path);
    dataFeatures = extractDataFeatures(im);
    % Identify the image
    predictedLabel = predict(KNN, dataFeatures);
    class_labels = predictedLabel;
    fprintf('Prediction: %s \n', char(predictedLabel));
    
end
