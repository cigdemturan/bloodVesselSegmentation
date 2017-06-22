function maskEdges = ct_findEdges(mask)

    boundaries = bwboundaries(mask); % find the boundary points
    maskEdges = zeros(size(mask)); % initialization
    
    % collect every boundary object together
    AA = [];
    for bo = 1 : length(boundaries)
        
        AA = vertcat(AA,boundaries{bo});
        
    end
    
    % find the indices in the matrix
    indEdge = sub2ind(size(mask),AA(:,1),AA(:,2));
    
    maskEdges(indEdge) = 1; % draw edges
    
    display('edges are calculated...')
    
end