function varargout = actualdesign(this, hspecs)
%ACTUALDESIGN   Design the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

args = designargs(this, hspecs);

opts = {};
if this.MinPhase
    opts = {'minphase'};
elseif this.MaxPhase
    opts = {'maxphase'};
end
opts = {opts{:}, {this.DensityFactor}};

[varargout{1:nargout}] = fircband(args{:}, opts{:});

varargout{1} = {varargout{1}};

% [EOF]
