function rowret = rowcollector(scandata, opts)
%Reduces the amount of rows in an image, works to eliminate noise and hard
%targets. It takes in an image and returns the image with all rows deamed
%unimportant set equal to zero. Works by convolving the image with a 
%rectangular function to smooth the data, then normalizes based on max 
%returned value. Then subracts the peak by the mean to see if there is a 
%large difference. Weak insects might get missed so the threshold value 
%may have to be adjusted.

arguments
    scandata
    opts.UseParallel = false
end

convolutionlength = 64; %convolution length can be adjusted for better 
%smoothing however it will mess with threshold values

v = heaviside(1:convolutionlength);
%     for scannum = 1:length(scans) %makes the code able to go through all
%     scans scandata would have to be adjusted
%     fprintf("Scan Number: %d \n",scannum) %used for tracking data
    holder = zeros(178,1024);

    
    if opts.UseParallel
        nWorkers = gcp('nocreate').NumWorkers;
    else
        nWorkers = 0;
    end

    rowtmp = [];
    if mean(mean(scandata)) > .45 %eliminates noisy scans

    else
	parfor(rows = 1:178, nWorkers)
		c = conv(scandata(rows,:),v);
		c = c(:,(convolutionlength:(end-convolutionlength)));
		c = c/max(c);
		if (max(c) - mean(c)) > .125 %threshold value
		    rowtmp = [rowtmp,rows];
		end
	    end
    end
    if(rowtmp)
        holder(rowtmp',:) = scandata(rowtmp',:);
    end

    rowret = holder;
end
