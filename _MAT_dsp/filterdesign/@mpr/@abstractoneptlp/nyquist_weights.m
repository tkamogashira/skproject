function nyquist_weights(this,wstruct)
%NYQUIST_WEIGHTS   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

hp = wstruct.iresp;
nneg = wstruct.nneg;
Decay = wstruct.decay;

GF = this.fgrid;

DW = zeros(size(GF)); % Preallocate

DW(1) = 1;

% Compute the zerophase response of BF(z^L) on the freq. grid
Hz = zerophase(hp,1,GF*pi);

if nneg,
    DW(2:end) = sqrt(abs(Hz(2:end)));
else,
    DW(2:end) = abs(Hz(2:end));    
end

if Decay ~= 0,
    % Determine deltay from Decay
    deltax = 1-GF(2);
    deltay = Decay*deltax;

    % Weight must increase exponentially for linear dB slope
    DW(2:end) = DW(2:end).*10.^(linspace(0,deltay/20,length(GF)-1));
end

this.Wgrid = DW;


% [EOF]
