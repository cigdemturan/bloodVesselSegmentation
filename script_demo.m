close all
clear all
clc
warning off;

% YOU CAN CHANGE THESE VALUES
im = 1;         % image1 (1) and image2 (2)
calc = 0;       % load saved results (0) or calculate from scratch (1)
showMasks = 0;  % show the mask images (1) or not (0)

% add paths
addpath('./functions');
addpath('./results')

% the path to the image
p = './'; 
imName = [p 'image' num2str(im) '.tif']; % name of the image

% read the image
img = imread(imName); display(char(imName));

if calc == 1

    % segmentation
    [mask, maskLines] = ct_segmentationImg(img,im); 

    % delete corners from maskLines
    [maskLines, branchPoints] = ct_deleteCorners(maskLines);

    % find the image of the edges
    maskEdges = ct_findEdges(mask);

    % tract the vessel for diameter measurements
    [diaAll, maskRE] = ct_trackVessel(maskLines,maskEdges);
    
else
    
    %%% ct_trackVessel function might take a while (a minute or so) 
    %%% to process.
    %%% If you don't want to wait, you can change 'calc' as 0.
    %%% It will load the saved results.

    display('loading the results from file...')
    nameTrack = ['./results/results_image' num2str(im) '.mat'];
    load(nameTrack);
    
end

if showMasks == 1
    figure, imshow(mask,[]); title('the mask');
    figure, imshow(maskLines,[]); title('the center lines');
    figure, imshow(maskEdges,[]); title('the edges');
    figure; imshow(maskLines,[]); hold on; title('directions in a branch point');
    plot(branchPoints(:,1),branchPoints(:,2),'*r'); hold off;
    figure; imshow(maskRE,[]); title('tracking the vessel - image2');
end

% calculate the histogram
histDia = ct_calculateHist(diaAll,im);

%%% eoc %%%