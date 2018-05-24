function s = thisdesignopts(this,s)
%THISDESIGNOPTS   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

s = rmfield(s, 'MatchExactly');
s = rmfield(s, 'DesignMode');
s = rmfield(s, 'SOSScaleNorm');
s = rmfield(s, 'SOSScaleOpts');

% [EOF]
