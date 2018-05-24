function [fspecsword,dm,dopts,Nstep] = convert2specword(cfmethod,cfspecs,N)
%CONVERT2SPECWORD Convert minimum order spec to spec with order for
%                 constrained word length FIR design

%   Copyright 2009 The MathWorks, Inc.

fspecsword = fspecs.hpweight;
fspecsword.FilterOrder = N;
if ~cfspecs.NormalizedFrequency,
   normalizefreq(fspecsword,false,cfspecs.Fs) 
end
fspecsword.Fpass = cfspecs.Fpass;
fspecsword.Fstop = cfspecs.Fstop;

dm = 'equiripple';

% Reverse engineer weights
Rpass = convertmagunits(cfspecs.Apass,'db','linear','pass');
Rstop = convertmagunits(cfspecs.Astop,'db','linear','stop');

dopts = {'FilterStructure', cfmethod.FilterStructure, ...
    'DensityFactor', cfmethod.DensityFactor, ...
    'MinPhase', cfmethod.MinPhase, ...
    'UniformGrid', cfmethod.UniformGrid,...
    'Wpass', 1, ...
    'Wstop', Rpass/Rstop};

% Filter Order increment
Nstep = 2; % Maintain FIR type

end