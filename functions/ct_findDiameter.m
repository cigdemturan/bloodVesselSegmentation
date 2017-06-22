function [diaIns, maskRE] = ct_findDiameter(indConn,sZ,po,maskRE,insEdge)

    % indices of the current line point
    [rLE,cLE] = ind2sub(sZ,indConn(po));

    % indices of the points to find the gradient of the current line point
    [rP, cP] = ind2sub(sZ,indConn([po-3,po+3])); 
    
    th = atand((rP(2) - rP(1)) / (cP(2) - cP(1))) ; % find the angle

    rotMat = [cosd(th), -sind(th); sind(th) ,cosd(th)]; % rotation matrix
    
    pixNum = 21; % the max diameter size expected
    pixNumHalf = floor(pixNum/2); % half of the diameter
    
    % create the mask
    maskPixNum = logical(zeros(pixNum));
    maskPixNum(:,round(pixNum/2)) = 1; 
    
    % find the indices
    [rPix, cPix] = ind2sub(size(maskPixNum),find(maskPixNum == 1));
    
    % rotation of the diameter based on the angle of the line
    % the diameter line will be perpendicular to the center line
    rotPot = [rPix-round(pixNum/2),cPix-round(pixNum/2)]*rotMat;
    rotPot = round(rotPot + round(pixNum/2));
    indRot = sub2ind(size(maskPixNum),rotPot(:,1),rotPot(:,2));
    mask21rot = logical(zeros(pixNum));
    mask21rot(indRot) = 1;
    
    % initialization of diameter mask
    maskR = logical(zeros(sZ));
    
    % this part is here if the size of the maskPixNum exceeds the mask
    if cLE <= pixNumHalf && rLE > pixNumHalf && rLE < sZ(1)
        
        cutOff = pixNumHalf - cLE + 2;
        maskR(rLE-pixNumHalf:rLE+pixNumHalf,1:cLE+pixNumHalf) = mask21rot(:,cutOff:end);
        
    elseif cLE <= pixNumHalf && rLE <= pixNumHalf
        
        cutOff = pixNumHalf - cLE + 2;
        cutOff2 = pixNumHalf - rLE + 2;
        maskR(1:rLE+pixNumHalf,1:cLE+pixNumHalf) = mask21rot(cutOff2:end,cutOff:end);
        
    elseif rLE <= pixNumHalf && cLE > pixNumHalf && cLE < sZ(2)
        
        cutOff = pixNumHalf - rLE + 2;
        maskR(1:rLE+pixNumHalf,cLE-pixNumHalf:cLE+pixNumHalf) = mask21rot(cutOff:end,:);
        
    elseif rLE + pixNumHalf >= sZ(1)
        
        cutOff = sZ(1) - (rLE + pixNumHalf);
        maskR(rLE-pixNumHalf:end,cLE-pixNumHalf:cLE+pixNumHalf) = mask21rot(1:end+cutOff,:);
        
    else
        
        maskR(rLE-pixNumHalf:rLE+pixNumHalf,cLE-pixNumHalf:cLE+pixNumHalf) = mask21rot;
        
    end
    
    % find the point where diameter line and edgeMask overlap
    maskREp = bitand(insEdge,maskR);
    
    % find the indices of that point
    [rREp, cREp] = ind2sub(sZ,find(maskREp == 1));
    
    if length(rREp) == 2 % if there are 2 points overlapping
        
        maskRE = bitor(maskRE,maskR); % create the mask for visualization
        
        % calculate the distance
        diaIns = norm([rREp(1) cREp(1)] - [rREp(2), cREp(2)]);
        
    else % otherwise measurement is zero
        
        diaIns = 0; 
        
    end
    
end