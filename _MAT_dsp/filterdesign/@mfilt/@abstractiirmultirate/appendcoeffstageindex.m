function coeff = appendcoeffstageindex(this,coeff,index)
%APPENDCOEFFSTAGEINDEX Append stage index to coefficient names

%   Copyright 2009 The MathWorks, Inc.

for k = 1:length(coeff)
    % append stage number after the coefficient names
    coeff{k} = sprintf('%s%s%s',coeff{k},'_',index);
end

% [EOF]
