function sltype = conv2sltype(this, varargin)
%CONV2SLTYPE <short description>
%   OUT = CONV2SLTYPE(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

wl = get(this, varargin{1});
fl = get(this, varargin{2});
if nargin > 3 % signedness is  passed
    sgn = varargin{3};
else
    sgn = this.signed; % default
end

sltype  = hdlgetsltypefromsizes(wl, fl, sgn);

% [EOF]
