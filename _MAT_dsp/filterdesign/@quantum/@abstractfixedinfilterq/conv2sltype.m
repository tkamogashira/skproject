function sltype = conv2sltype(this, varargin)
%CONV2SLTYPE Returns SLTYPE for the given WL, FL
%   SLTYPE = CONV2SLTYPE(ARGS)
%   This method returns the SLTYPE for the quantizer. It will look into the
%   properties passed as arguments for WL and FL. It takes an optional
%   third argument for SIGNEDNESS (true or false). When passed it will
%   force that SIGNEDNESS for generating SLTYPE. When SIGNEDNESS is not
%   passed it uses the SIGNEDNESS as set in the quantizer.

wl = get(this, varargin{1});
fl = get(this, varargin{2});
if nargin > 3 % signedness is  passed
    sgn = varargin{3};
else
    sgn = this.signed; % default
end
sltype  = hdlgetsltypefromsizes(wl, fl, sgn);

% [EOF]
