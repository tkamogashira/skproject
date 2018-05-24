function this = loadobj(s)
%LOADOBJ  Load this object.

%   Copyright 2008 The MathWorks, Inc.

% This load method is used to bridge between @fdfmethod and @fmethod so 
% that the filter/fdatool session (using fedesign) saved in releases 
% up to R2007b can be loaded back in R2008a.

this = fmethod.cheby2hpmin;
if isfield(s,'privMatchExactly')
    s.MatchExactly = s.privMatchExactly;
    s = rmfield(s,'privMatchExactly');
end
set(this,rmfield(s,'DesignAlgorithm'));

% [EOF]
