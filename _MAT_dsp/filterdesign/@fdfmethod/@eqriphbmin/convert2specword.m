function [fspecsword,dm,dopts,Nstep] = convert2specword(this,cfspecs,N)
%CONVERT2SPECWORD Convert minimum order spec to spec with order for
%                 constrained word length FIR design

%   Copyright 2009 The MathWorks, Inc.


fspecsword = fspecs.hbordntw;
fspecsword.FilterOrder = N;
if ~cfspecs.NormalizedFrequency,
   normalizefreq(fspecsword,false,cfspecs.Fs) 
end
fspecsword.TransitionWidth = cfspecs.TransitionWidth;

dm = 'equiripple';

dopts = {'FilterStructure', this.FilterStructure, ...
    'MinPhase', this.MinPhase, ...
    'StopbandShape', this.StopbandShape, ...
    'StopbandDecay', this.StopbandDecay};

% Filter Order increment
Nstep = 2; 

end