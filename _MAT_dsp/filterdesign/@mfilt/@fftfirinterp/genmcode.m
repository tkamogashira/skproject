function hcode = genmcode(this, varname, place)
%GENMCODE   Generate an MATLAB code object for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

if nargin < 2
    varname = 'Hd';
end

hcode = sigcodegen.mcodebuffer;

params = {'num', 'intf', 'bl'};
values = {genmcodeutils('array2str', this.Numerator), ...
    sprintf('%d', this.InterpolationFactor), sprintf('%d', this.BlockLength)};
descs  = {'Numerator', 'Interpolation Factor', 'Block Length'};

hcode.addcr(hcode.formatparams(params, values, descs));
hcode.cr;
hcode.add('%s = %s(intf, num, bl);', varname, class(this));

% [EOF]
