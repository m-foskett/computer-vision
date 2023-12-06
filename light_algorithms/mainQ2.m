%% Computer Vision Assignment 1
% Author: Mark Foskett
% Date Created: 13/08/19
%
%% Question 2: Lego Block Colour-based Tracking

% Load Images
RGB = imread('legobricks001.jpg');
% RGB = imread('bricksjoined004.jpg');
% Colour-based Tracking Algorithm - Lego Bricks
[locations, dims, labels] = colourTrackBricks(RGB);
algorithm_data.colours = labels;
algorithm_data.center = locations;
algorithm_data.box_size = dims;
% Colour-based Tracking Algorithm - Lego Bricks Joined
% [locations, dims, labels] = colourTrackBricksJoined(RGB);

% Calculate Tracking Accuracy using validation data
load('legobrick_validation.mat');
trackingAccuracy(algorithm_data, validation_data);