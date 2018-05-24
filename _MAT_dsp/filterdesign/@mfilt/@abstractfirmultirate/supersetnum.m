function num = supersetnum(Hm, num)
%SETNUM Overloaded set for the Numerator property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

if ~isnumeric(num)
  error(message('dsp:mfilt:abstractfirmultirate:supersetnum:MustBeNumeric'));
end
if ~issigvector(num)
  error(message('dsp:mfilt:abstractfirmultirate:supersetnum:InvalidDimensions'));
end
if issparse(num),
    error(message('dsp:mfilt:abstractfirmultirate:supersetnum:Sparse'));
end
if isempty(num)
  error(message('dsp:mfilt:abstractfirmultirate:supersetnum:MFILTErr'));
end

% Test for NaN, Inf, -Inf
if ~all(isfinite(num))
  error(message('dsp:mfilt:abstractfirmultirate:supersetnum:MustBeFinite'));
end

% Make sure numerator is a row
num = num(:).';

% Clear any possible fdesign/fmethod objects associated with this filter
% since coefficients are being changed
clearmetadata(Hm);

% Update the Numerator property of the contained object.
Hd = lwdfilt.tf(num,1);
if signalpolyutils('islinphase',num,1),
    if strcmpi('symmetric',signalpolyutils('symmetrytest',num,1)),
        Hd = lwdfilt.symfir(num);
    else
        Hd = lwdfilt.asymfir(num);
    end
end
Hm.Filters = Hd;

% Reset the polyphase matrix
resetpolym(Hm,num);

% Set number of coefficients
oldlength = Hm.ncoeffs;
newlength = length(num);
Hm.ncoeffs = newlength;

if isempty(oldlength) || newlength~=oldlength,
    reset(Hm);
end

set_ncoeffs(Hm.filterquantizer, naddp1(Hm));

% Store an empty, no need to replicate storage, all info is in the
% polyphase matrix
num = []; 

%--------------------------------------------------------------------------
function t = issigvector(v)
%ISSIGVECTOR  True for a vector.
%   ISSIGVECTOR(V) returns 1 if V is a vector and 0 otherwise.
t = ndims(v)==2 & min(size(v))<=1;


% [EOF]
