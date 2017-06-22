function varargout = ct_calculateHist(diaAll,im)

    fprintf('\n')
    display(['the range of the diameters --> [' num2str(min(diaAll)) ', ' num2str(max(diaAll)) '];'])
    display(['the mean value of the diameters --> ' num2str(mean(diaAll))])
    
    y = 0:0.5:22; % ranges in consideration
    histDia = hist(diaAll,y); % calculate the histogram
    histDia = histDia ./ sum(histDia); % normalize the histogram
    
    % plot the histogram
    figure; bar(y,histDia,'FaceColor',[.3 .2 .5]); axis([0 21 0 0.1]); 
    title(['histogram of image' num2str(im)]);
    
    if nargout == 1 % if the histogram vector is needed
        
        varargout{1} = histDia;
        
    end

end