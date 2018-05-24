function [outVal,mStruct] = ciccompdecimator(df,dd,nsec,rcic,varargin)
%CICCOMPDECIMATOR compensator filter design
% Signatures:
% g = ciccompdecimator(df,dd,nsec,rcic);
% g = ciccompdecimator(df,dd,nsec,rcic,fp,fst,ap,ast);
% g = ciccompdecimator(df,dd,nsec,rcic,N,fp,fst);
% [g,mStruct] = ciccompdecimator(df,dd,...);
%   
% Inputs:
%   df - decimation factor
%   dd - differential delay
%   nsec - number of sections in the filter 
%   rcic - CIC rate change factor
%   N - filter order
%   fp - frequency at the start of the pass band. Specified in normalized frequency units. Also called Fpass.
%   fst - frequency at the end of the stop band. Specified in normalized frequency units. Also called Fstop.
%   ap - amount of ripple allowed in the pass band in decibels (the default units). Also called Apass.
%   ast - attenuation in the stop band in decibels (the default units). Also called Astop.
%
% Outputs:
%   g - A structure containing the filter coefficients
%   mStruct - A structure containing the output of MEASURE on the designed
%              filter.
%
% EXAMPLE: A compensator filter design using fdesign.decimator and CICCOMPDECIMATOR
%   n = 10; fp = 0.1; fst = 0.2; nsec = 4; rcic = 5; df = 3; dd = 1;
%   f = fdesign.decimator(df,'ciccomp',dd,nsec,rcic,'n,fp,fst',n,fp,fst);
%   h = design(f,'equiripple');
%   [g,ms] = ciccompdecimator(df,dd,nsec,rcic,n,fp,fst);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

switch nargin
    case {0,1,2,3}
        error(message('MATLAB:nargchk:notEnoughInputs'));
    case 4
        fdesignInputs = {df,'ciccomp',dd,nsec,rcic};
    case 7
        fdesignInputs = {df,'ciccomp',dd,nsec,rcic,'n,fp,fst',varargin{:}};
    case 8
        fdesignInputs = {df,'ciccomp',dd,nsec,rcic,'fp,fst,ap,ast',varargin{:}};
        
    otherwise
        error('MATLAB:wrongInputs','Incorrect number of input arguments');
end

% Designing the filter
f = fdesign.decimator(fdesignInputs{:});
h = design(f,'equiripple');

g = filt2struct(h);

outVal = g.Numerator;

% Second output: Output of 'measure' converted to a structure
if(nargout > 1),
    m = measure(h);
    %mStruct.Fs = m.Fs;
    mStruct.Fp = m.Fp;
    mStruct.F3dB = m.F3dB;
    mStruct.F6dB = m.F6dB;
    mStruct.Fstop = m.Fstop;
    mStruct.Apass = m.Apass;
    mStruct.Astop = m.Astop;
    mStruct.TransitionWidth = m.TransitionWidth;
end

end

