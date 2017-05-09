function [ gp_clean ] = cleanGP( gp )
%CLEANGP Cleans the output of KbWaitEyeTracking
    gp_clean = zeros(length(gp), 2);
    for x=1:length(gp)
        if ~isempty(gp{x})
            split = strsplit(gp{x}, '"');
            if length(split)>10
                gp_clean(x,:) = [str2num(split{2}), str2num(split{4})];
            else
                continue
            end 
        end
    end
    gp_clean = gp_clean(sum(gp_clean,2)>0,:);
end

