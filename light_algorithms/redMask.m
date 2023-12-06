function [BW,maskedRGBImage] = redMask(RGB)
%redMask

% Convert RGB image to chosen color space
I = RGB;
red = [];
% Define thresholds for channel 1 based on histogram settings
channel1Min = 44.000;
channel1Max = 255.000;
red(1,1) = channel1Min;
red(1,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 77.000;
red(1,3) = channel2Min;
red(1,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 78.000;
red(1,5) = channel3Min;
red(1,6) = channel3Max;
% Define thresholds for channel 1 based on histogram settings
channel1Min = 53.000;
channel1Max = 132.000;
red(2,1) = channel1Min;
red(2,2) = channel1Max;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 25.000;
red(2,3) = channel2Min;
red(2,4) = channel2Max;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 3.000;
channel3Max = 38.000;
red(2,5) = channel3Min;
red(2,6) = channel3Max;



% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
