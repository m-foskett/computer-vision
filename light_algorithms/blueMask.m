function [BW,maskedRGBImage] = blueMask(RGB)

% Convert RGB image to chosen color space
I = RGB;
blue = [];
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 100.000;
blue(1,1) = channel1Min;
blue(1,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 31.000;
channel2Max = 223.000;
blue(1,3) = channel2Min;
blue(1,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 133.000;
channel3Max = 255.000;
blue(1,5) = channel3Min;
blue(1,6) = channel3Max;
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 108.000;
blue(2,1) = channel1Min;
blue(2,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 63.000;
channel2Max = 255.000;
blue(2,3) = channel2Min;
blue(2,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 98.000;
channel3Max = 255.000;
blue(2,5) = channel3Min;
blue(2,6) = channel3Max;


% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
