function b = actualdesign(this,hs)
%ACTUALDESIGN

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

args = designargs(this,hs);

if this.MinPhase
    minphase = {'minphase'};
else
    minphase = {};
end

% When the slope is zero we do not want to call FIRGR directly.
% FIRHALFBAND has special code for the halfband design.
b = {firhalfband(args{:}, minphase{:})};

% [EOF]
