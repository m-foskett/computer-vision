%% Computer Vision - Assignment 2
% Author: Mark Foskett
% Date Created: 4th September 2018
% Question 1 - 3D Reconstruction using Underwater Stereo Vision

%% Background
% Diver Rig:
    % Cameras:
    % - One colour camera
    % - One monochrome camera
    % Positioning System:
    % - GPS
    % - Magnetometer
% Processing of stereo imagery allows 3D construction of reef model using
% imagery and sensor data
%% Parameters
% Path to the image sets
image_left_dir = 'images_left\';
image_right_dir = 'images_right\';

% Load stereo camera calibration parameters
load('stereo_calib.mat');

% Load the camera poses
% Four Fields:
% R - 3x3xN array of rotation matrices
% t - 3xN array of translation vectors
% Left_camera - Nx1 cell array of corresponding left camera filenames
% Right_camera - Nx1 cell array of corresponding right camera filenames
load('camera_pose_data.mat');

% Load the reference terrain data
% Three Variables:
% height_grid - 2D array of terrain height values
% X - vector of X position values corresponding to the rows of height_grid
% Y - vector of Y position values corresponding to the columns of
% height_grid
load('terrain.mat');
% Plot of the reference terrain
figure(1);
mesh(X,Y,height_grid);
title('Reference Terrain Model');
axis equal;
hold on;
%% Briefing
% Use the stereo pairs and R,t to build a 3D pointcloud of the underwater 
% terrain corresponding to the surfaces seen in the camera images

% For each stereo pair, extract interest points of your choice (SURF or
% Harris Corners etc.) and match these across the left and right images
% making sure to use an outlier-rejection process to remove bad matches
N = 49; % number of image pairs
worldPoints = zeros(1,4);
for i = 1:N
    % Load in the current stereo image pair
    leftImagePath = [image_left_dir, char(camera_poses.left_images(i))];
    rightImagePath = [image_right_dir, char(camera_poses.right_images(i))];
    IL_C = imread(leftImagePath);
    IR = imread(rightImagePath);
    
    % Acquire the pointcloud for the current image
    worldPoints = getPointCloud(IL_C, IR, stereoParams, i);   
%     m = size(tempWorldPoints,1);
%     tempIndex = i*ones(m,1);
%     tempPoints = cat(2,tempIndex,tempWorldPoints);
%     worldPoints = cat(1,worldPoints,tempPoints);
    
    % R' * (p' - t)
    [N, m, n, o] = size(worldPoints); % get the dimensions 
    worldFramePoints = camera_poses.R(:,:,i)' * (worldPoints(:,:,:)' - camera_poses.t(:,i));
    scatter3(worldFramePoints(1,:),worldFramePoints(2,:),-worldFramePoints(3,:),ones(1,1),'r');
    drawnow;
end

%% Produce a single pointcloud in the world reference frame using the
% pointclouds from each of the N stereo pairs.

% For each set of points, translate and rotate the points into the World
% reference frame using the camera rotation and translation data in
% camera_poses
% load('worldPoints.mat'); % Load the worldPoints for the N images



% Compare the reconstructed pointcloud to the provided reference terrain
% model

