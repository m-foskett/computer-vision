function [imageSet] = acquireImageSet(scene)

    % Image path
    filePrefix = 'dataset';
%     scenes = {'ball_pit', 'desert', 'park', 'road', 'sky', 'snow', 'urban'};
%     i = 1;
    image_path = [filePrefix,'\',char(scene)];
    images = fullfile(image_path, '*.jpg');
    % Create the image struct
    nameSet = dir(images);
    [m,n] = size(nameSet);
    images = [];
    imageSet = [];
    for i=1:m
        images = [images; nameSet(i).name];
    end
    for i=1:m
        currImage = fullfile(image_path, images(i,:));
        imageSet = cat(4,imageSet,imread(currImage));
    end
end