%% Computer Vision - Assignment 2
% Author: Mark Foskett
% Date Created: 4th September 2018
%% Question 2 - Scene Classification
% Develop a machine learning algorithm that can perform scene 
% classification based on RGB images
% 
% Systematic Approach:
% - Data preprocessing
% - Feature Extraction
% - Model Training and Validation
% - Parameter Selection
%
% Algorithm Input
% - RGB Image
% Algorithm Output
% - Scene Labels in order of confidence
% Function Prototype
% [class_labels] = assign2_sceneclassifier(image_path);
% where:
%       - image_path: path to an image file
%       - class_labels: 1xN cell array of strings representing scene labels
%       in order of confidence
%% Implementation
% Load the images
scenes = {'ball_pit', 'desert', 'park', 'road', 'sky', 'snow', 'urban'};
i = 1;
image_path = ['dataset\',char(scenes(i)),'\00000003','.jpg'];

% Scene Classification Algorithm
[class_labels, dataFeatures] = assign2_sceneclassifier(image_path);
