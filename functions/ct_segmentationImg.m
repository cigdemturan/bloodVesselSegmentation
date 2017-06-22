function [mask, maskLines] = ct_segmentationImg(img,im)
    
    display('segmentation...')
    img = imresize(img, 0.7); %resize image
    imgG = img(:,:,2); %obtain green channel
    
    %some more prepocessing
    imgG = imsharpen(imgG,'Radius',1,'Amount',2); 
    imgG = imgaussfilt(imgG,2);
    
    imgBW = im2bw(imgG,60/255); %threshold the image
    
    %dilation, erosion and filling the holes in the vessels
    if im == 1
        imgBW = imdilate(imgBW,strel('disk',2));
        imgBW = imerode(imgBW,strel('disk',2));
        imgBW = imfill(imgBW,'holes');
    elseif im == 2
        imgBW = imerode(imgBW,strel('disk',1));
        imgBW = imdilate(imgBW,strel('disk',1));
    end

    CC = bwconncomp(imgBW); %finding connected components
    indConnected = [];
    for c = 1 : CC.NumObjects %check every connected components
        %consider it if it is more than a certain pixel number
        if length(CC.PixelIdxList{c}) > 1300 
            indConnected = vertcat(indConnected,CC.PixelIdxList{c});
        end
    end
    mask = double(zeros(size(imgG,1),size(imgG,2)));
    mask(indConnected) = 1; %create the mask with the selected connected components

    %%%%% if you would like to see the segmentedImg, you can uncomment %%%%
    %%%%% this section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % segmentedImg = imgG;
    % segmentedImg(~logical(mask)) = 0;
    % figure; imshow(segmentedImg,[]); title('segmentedImg');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    maskLines = bwmorph(mask,'thin',inf); % find the center lines in the blood vessels
end