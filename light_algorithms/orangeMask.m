function [BW,maskedRGBImage] = orangeMask(RGB)

% Convert RGB image to chosen color space
I = RGB;

orange = [];
% Define thresholds for channel 1 based on histogram settings
channel1Min = 169.000;
channel1Max = 255.000;
orange(1,1) = channel1Min;
orange(1,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 73.000;
channel2Max = 146.000;
orange(1,3) = channel2Min;
orange(1,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 71.000;
orange(1,5) = channel3Min;
orange(1,6) = channel3Max;
% Define thresholds for channel 1 based on histogram settings
channel1Min = 101.000;
channel1Max = 179.000;
orange(2,1) = channel1Min;
orange(2,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 35.000;
channel2Max = 81.000;
orange(2,3) = channel2Min;
orange(2,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 43.000;
orange(2,1) = channel3Min;
orange(2,2) = channel3Max;



% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
