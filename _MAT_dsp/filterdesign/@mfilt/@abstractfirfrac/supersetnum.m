function num = supersetnum(Hm, num)
%SETNUM Overloaded set for the Numerator property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.


% Make sure numerator is a row
num = num(:).';

% Clear any possible fdesign/fmethod objects associated with this filter
% since coefficients are being changed
setfdesign(Hm, []);
setfmethod(Hm, []);     

% Set number of coefficients
oldlength = Hm.ncoeffs;
if isempty(oldlength), oldlength = 0; end
newlength = length(num);
Hm.ncoeffs = newlength;

if newlength~=oldlength,
    reset(Hm);
end

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

% Store an empty, no need to replicate storage, all info is in the
% polyphase matrix
num = []; 

% [EOF]
