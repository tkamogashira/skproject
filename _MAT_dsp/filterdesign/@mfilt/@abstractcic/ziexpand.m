function zi = ziexpand(this, x, zi)
%ZIEXPAND   Expand the CIC object for multichannels.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[m,ndata] = size(x);
ndata = max(ndata,1);

if ~(isempty(zi) | any(size(zi.Integrator,2) == [ndata,1])),
	error(message('dsp:mfilt:abstractcic:ziexpand:InvalidDimensions'));
end

if size(zi.Integrator,2) == 1,
    intg = zi.Integrator;
    comb = zi.Comb;
    intg = repmat(intg, 1, ndata);
    comb = repmat(comb, 1, ndata);
    zi = filtstates.cic(intg, comb);
end

% [EOF]
