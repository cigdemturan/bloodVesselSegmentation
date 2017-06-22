function [insLines,Corners,flag,i] = ct_checkCorner(insLines,locIns,Corners,i)
    % choose the image region to check if it is a corner
    rect = [locIns(1)-3, locIns(2)-3,6,6];
    % crop the image
    branchIns = double(imcrop(insLines,rect));
    
    % find how many 
    cornerFilter = [1,1,1;1,0,1;1,1,1];
    centerP = imfilter(branchIns,cornerFilter);
    centerP(branchIns == 0) = 0; % discard the zero pixel values

    flag = 1; % assume it is a corner
    neighFilter = [-1,-1;-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1];
    
    % find the 3s in the filtered region
    [r3, c3] = find(centerP == 3); 
    
    neig = struct;
    if length(r3) == 3 % if there is three 3s
        
        i = i + 1; % increase the number of corners
        
        Corners(i).branches = zeros(length(r3),2); % initialization
        Corners(i).middles = horzcat(c3,r3); % to be deleted
        
        if isempty(find(centerP == 4)) % if there is no 4s
            
            for b = 1 : 3 % for each 3s
                
                nameN = ['branch_' num2str(b)];
                % find neighboring pixels
                insVec = ct_neighborVector(centerP,[r3(b),c3(b)]);
                % check whether there is any numbers rather than 0s and 3s
                neig.(nameN) = insVec ~= 0 & insVec ~= 3;
                % add to the branch points
                Corners(i).branches(b,:) =  horzcat(c3(b) + neighFilter(neig.(nameN),2), ...
                    r3(b) + neighFilter(neig.(nameN),1));
            end
            
        else

            for b = 1 : 3
                
                nameN = ['branch_' num2str(b)];
                % find neighboring pixels
                insVec = ct_neighborVector(centerP,[r3(b),c3(b)]);
                % check whether there is any numbers rather than 0s, 3s, 4s 
                neig.(nameN) = insVec ~= 0 & insVec ~= 3 & insVec ~= 4;
                
                if length(find(neig.(nameN) == 1)) ~= 1 % if there is no other numbers
                    % then 4 is a branch point
                    neig.(nameN) = insVec ~= 0 & insVec ~= 3;
                end
                
                % add to the branch points
                Corners(i).branches(b,:) =  horzcat(c3(b) + neighFilter(neig.(nameN),2), ...
                    r3(b) + neighFilter(neig.(nameN),1));
                
            end
            
        end
        
    elseif length(r3) == 2 % if there is two 3s

        i = i + 1; % increase the number of corners
        
        Corners(i).branches = zeros(length(r3),2); % initialization
        Corners(i).middles = horzcat(c3,r3); % to be deleted
        
        % first 3s
        nameN = ['branch_' num2str(1)];
        % find neighboring pixels
        insVec = ct_neighborVector(centerP,[r3(1),c3(1)]);
        % check whether there is any numbers rather than 0s and 3s
        neig.(nameN) = insVec ~= 0 & insVec ~= 3;
        
        countCC = length(find(neig.(nameN) == 1)); % find how many
        bR1 =  horzcat(repmat(c3(1),countCC,1) + neighFilter(neig.(nameN),2), ...
                    repmat(r3(1),countCC,1) + neighFilter(neig.(nameN),1));
        
        % second 3s
        nameN = ['branch_' num2str(2)];
        % find neighboring pixels
        insVec = ct_neighborVector(centerP,[r3(2),c3(2)]);
        % check whether there is any numbers rather than 0s and 3s
        neig.(nameN) = insVec ~= 0 & insVec ~= 3;
        
        countCC = length(find(neig.(nameN) == 1)); % find how many
        bR2 =  horzcat(repmat(c3(2),countCC,1) + neighFilter(neig.(nameN),2), ...
                    repmat(r3(2),countCC,1) + neighFilter(neig.(nameN),1));
                
        % choose unique branch points (3 of them)
        Corners(i).branches = unique(vertcat(bR1,bR2),'rows');

    elseif length(r3) == 1 % if there is one 3s
        
        i = i + 1; % increase the number of corners
        
        Corners(i).branches = zeros(length(r3),2); % initialization
        Corners(i).middles = horzcat(c3,r3); % to be deleted

        % only 3s
        nameN = ['branch_' num2str(1)];
        % find neighboring pixels
        insVec = ct_neighborVector(centerP,[r3,c3]);
        % check whether there is any numbers rather than 0s and 3s
        neig.(nameN) = insVec ~= 0 & insVec ~= 3;
        
        countCC = length(find(neig.(nameN) == 1)); % find how many
        Corners(i).branches =  horzcat(repmat(c3(1),countCC,1) + neighFilter(neig.(nameN),2), ...
                    repmat(r3(1),countCC,1) + neighFilter(neig.(nameN),1));
                
    else
        
        flag = 0; % it is not a corner
        
    end
    
    if flag == 1 % if it is a corner

        ref = locIns - 4; % difference with real image
        
        % find the locations in the bigger image
        Corners(i).branchesImg = Corners(i).branches + repmat(ref,size(Corners(i).branches,1),1);
        Corners(i).middlesImg = Corners(i).middles + repmat(ref,size(Corners(i).middles,1),1);
        
        % delete the corner points from image
        indBlack = sub2ind(size(insLines),Corners(i).middlesImg(:,2), Corners(i).middlesImg(:,1));
        insLines(indBlack) = 0;

    end
    
end