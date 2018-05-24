function this = loadobj(s)
%LOADOBJ  Load this object.

%   Copyright 2008 The MathWorks, Inc.

% This class is used to bridge between @fdfmethod and @fmethod so that the
% filter/fdatool session (using fedesign) saved in releases up to 7b can be
% loaded back in 8a. (see g431066)
this = fmethod.butteralp;
set(this,rmfield(s,'DesignAlgorithm'));


% [EOF]
