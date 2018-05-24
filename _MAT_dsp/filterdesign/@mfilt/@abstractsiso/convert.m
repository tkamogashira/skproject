function Hm = convert(this, target)
%CONVERT   Convert the multirate object.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'))

if ~ischar(target)
  error(message('dsp:mfilt:abstractsiso:convert:MustBeAString'))
end

if ~ismethod(this,['to',target])
  error(message('dsp:mfilt:abstractsiso:convert:FilterErr', target));
end

% If the property is not there or is private, we are in "double" mode.
if isprop(this, 'Arithmetic')
    arith = get(this, 'Arithmetic');
else
    arith = 'double';
end
switch arith
    case 'single'
        warning(message('dsp:mfilt:abstractsiso:convert:unquantizing1'));
        this = reffilter(this);
    case 'fixed'
        warning(message('dsp:mfilt:abstractsiso:convert:unquantizing2'));
        this = reffilter(this);
    otherwise
        % NO OP, double.
end

Hm = feval(['to' target], this);

% [EOF]
