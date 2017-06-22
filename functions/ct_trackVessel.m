function [diaAll, maskRE] = ct_trackVessel(maskLines,maskEdges)

    display('tracking the vessels has started')

    % find every line in the maskLines
    CC = bwconncomp(logical(maskLines));
    
    maskRE = maskEdges; % copy the maskEdges
    diaAll = []; % initialization
    countPo = 0; % count number of points considered
    
    for c = 1 : CC.NumObjects % for each line
        
        indConn = CC.PixelIdxList{c}; % find indices

        if length(indConn) > 10 % if the line longer than 10px
            
            for po = 4 : length(indConn) - 3 % discard first 3 and last 3 points
                
                % find the diameter
                [diaIns, maskRE] = ct_findDiameter(indConn,size(maskLines),po,maskRE,maskEdges);
                
                if diaIns ~= 0 % if it is calculated
                    
                    countPo = countPo+1; % increase the count
                    diaAll(countPo) = diaIns; % collect each measurements
                    
                end
                
            end
            
            fprintf ('\b'); display('.');
            
        end
        
    end
    
    display('completed!')
    
end