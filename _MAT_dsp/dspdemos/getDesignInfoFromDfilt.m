function str = getDesignInfoFromDfilt(filt)
% GETDESIGNINFOFROMDFILT Helper function to extract design information from a dfilt object

%   Copyright 2008 The MathWorks, Inc.

    % Add CrLf to each column for proper display in code
    str = filt.info('long');
    str(:,end+1) = sprintf('\n');
    str = str';
    str = str(:)';

    index_start=regexp(str,'Design Specifications');
    index_end=regexp(str,'Measurements')-1;
    str = str(index_start:index_end);
    str = strtrim(str);
end

