function [maskLines, branchPointsAll] = ct_deleteCorners(maskLines)

    display('finding the branch points...')

    % detect corners with Harris Corner Detectors
    corners = detectHarrisFeatures(maskLines,'FilterSize',9);
    
    maskLines = double(maskLines);
    
    locAll = corners.Location; % location of the corners
    strenghtAll = corners.Metric; % get the metric
    [~,ind] = sort(strenghtAll,'descend');
    locAll = locAll(ind,:); % sort based on the metric (descend)

    Corners = struct;
    count = 0;
    branchPointsAll = [];
    cornerPointsAll = [];
    
    for i = 1: length(locAll) % for each corner point location
        locIns = round(locAll(i,:));
        
        % check whether it is corner of interest
        [maskLines,Corners,flag,count] = ct_checkCorner(maskLines,locIns,Corners,count);
        
        if flag == 1 % if it is a corner
            branchPointsAll = vertcat(branchPointsAll,Corners(count).branchesImg);
            cornerPointsAll = vertcat(cornerPointsAll,locIns);
        end
    end
end