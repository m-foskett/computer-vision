function [BW,maskedRGBImage] = lightGreenMask(RGB)

% Convert RGB image to chosen color space
I = RGB;
lightGreen = [];
% Define thresholds for channel 1 based on histogram settings
channel1Min = 32.000;
channel1Max = 101.000;
% lightGreen(1,1) = 
% Define thresholds for channel 2 based on histogram settings
channel2Min = 113.000;
channel2Max = 185.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 78.000;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 29.000;
channel1Max = 130.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 121.000;
channel2Max = 193.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 73.000;


% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
