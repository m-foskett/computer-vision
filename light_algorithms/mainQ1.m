%% Computer Vision Assignment 1
% Author: Mark Foskett
% Date Created: 13/08/19
%
%% Question 1: Photometric Stereo
% Using your recovered surface normals for each of the face datasets, 
% develop an algorithm for recovering a 3D height image of each subject’s 
% face using numerical integration across the image in the x and y 
% directions. 

% Load in the face datasets
n = '1'; % n = 1, 2, 5 or 7
load('facedata_yaleB07.mat');
% load('yaleB05_albedo_normals.mat');

% Using the image intensities, the light directions, acquire albedo and
% surface normals
[albedo, normals, residuals] = photometricStereo(im_array, light_dirs);

% Recover a 3D height image of face dataset
[heightMap] = recoverHeight(albedo, normals);

% Construct 3D height map
display_face_model(albedo, heightMap);

