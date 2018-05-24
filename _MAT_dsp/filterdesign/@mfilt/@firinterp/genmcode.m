function hcode = genmcode(this, varname, place) %#ok
%GENMCODE   Generate an MATLAB code object for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

if nargin < 2
    varname = 'Hd';
end

hcode = sigcodegen.mcodebuffer;

L = this.InterpolationFactor;

params = {'intf'};
values = {sprintf('%d', L)};
descs  = {'Interpolation Factor'};
inputs = 'intf';

if ~isequal(this.Numerator, this.defaultfilter(L, 1))
    params = {params{:}, 'num'};
    values = {values{:}, genmcodeutils('array2str', this.Numerator)};
    descs  = {descs{:},  'Numerator'};
    inputs = sprintf('%s, num', inputs);
end

hcode.addcr(hcode.formatparams(params, values, descs));
hcode.cr;
hcode.add('%s = %s(%s);', varname, class(this), inputs);

% Add the quantizer mcode.
switch lower(this.Arithmetic)
    case 'double'
        % NO OP
    case 'single'
        hcode.cr;
        hcode.cradd('set(%s, ''Arithmetic'', ''single'');', varname);
    otherwise
        hqcode = genmcode(this.filterquantizer);
        if ~isempty(hqcode)
            hcode.cr;
            hcode.craddcr('set(%s, ''Arithmetic'', ''%s'', ...', varname, this.Arithmetic);
            hcode.add(hqcode);
        end
end

% [EOF]
