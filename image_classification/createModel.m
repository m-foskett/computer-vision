function [KNN, imageSet] = createModel

    %% Data Set Collection
    % Get image data
    scenes = {'ball_pit', 'desert', 'park', 'road', 'sky', 'snow', 'urban'};
    s = 7; % seven scenes
    imageSet = []; % set of images
    GTlabels = []; % ground truth labels
    for i =1:s % for all the scenes
        imageSet = cat(4, imageSet, acquireImageSet(scenes(i)));
        a = 50*(i-1);
%         figure(i);
%         montage(imageSet(:,:,:,(1+a):(50+a)));
        title(char(scenes(i)));
        [m,n,o,p] = size(imageSet);
        b = p/i;
        for N=1:b % for all the 
            GTlabels = [GTlabels; scenes(i)];
        end
    end
    % Extract a random subset of images
    numImages = p; % number of images to use
    perm = randperm(p,numImages);
    imageSet = imageSet(:,:,:,perm);
    GTlabels = GTlabels(perm,1);
        
    %% Pre-processing
    % Colourspace
    % Data is currently in RGB colourspace
    
    % Histogram Equalisation
    % Mean and Standard Deviation Normalisation
    % Alignment, skewing, warping
    
    %% Feature Extraction
    
    % Data Features variable 
    dataFeatures = [];
    
    % Account for poor resolution of raw data
    %% Gaussian Filter for Blurring
    sigma = 0.5; % stddev
    imageSet = imgaussfilt(imageSet, sigma);

    % For each image
    for N = 1:numImages
        
        % Acquire current RGB image
        rgb = imageSet(:,:,:,N); % current RGB image
        
        % Store the extracted data features
        dataFeatures = [dataFeatures; extractDataFeatures(rgb)];
        
    end   
    
    %% Model Training
    % KNN
    sub = 0.8 * numImages;
    KNN = fitcknn(dataFeatures(1:sub,:), GTlabels(1:sub));
    pred = predict(KNN, dataFeatures((sub+1):end, :));
    
    
    %% Metrics
    % [confmat, acc, prec, rec, f1score] = ML_AnalyseModel(pred, labels);
    correct = 0;
    false = 0;
    for i = (sub+1):length(GTlabels)
        % Display correct guess
        fprintf('%d: Pred: %s GT: %s \n',(i - sub), char(pred(i-sub)), char(GTlabels(i)));
        if strcmp(char(pred(i - sub)),char(GTlabels(i)))
            correct = correct + 1;
            
        else
            false = false + 1;
        end
    end
    successRate = correct/(correct + false) * 100;
    fprintf('Success Rate: %0.2f %% (%d/%d) \n', successRate, correct, (correct + false));
    
    
    
    
    
    
    
    
    
    
    %% Model Validation


end