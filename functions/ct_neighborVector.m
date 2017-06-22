function arrayN = ct_neighborVector(mat,rc)
    
    r = rc(1); c = rc(2); % get row and column points
    neighFilter = [-1,-1;-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1];
    arrayN = zeros(size(neighFilter,1),1); % initialization
    
    for k = 1 : size(neighFilter,1) % for each neighboring point
        
        if r == 7 || c == 7 || r == 1 || c == 1 % if the value is on the edges
            
            arrayN(k) = 0; % zero padding
            
        else
            
            arrayN(k) = mat(r+neighFilter(k,1),c+neighFilter(k,2));
            
        end
        
    end
    
end