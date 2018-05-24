function [outVal,mStruct] = lowpassinterpolator(If,fp,fst,ap,ast,nStages,HalfbandDesignMethod)
%LOWPASSINTERPOLATOR Lowpass multistage interpolator filter design.
% Signatures:
% g = lowpassinterpolator(If,fp,fst,ap,ast);
% g = lowpassinterpolator(If,fp,fst,ap,ast,nStages);
% g = lowpassinterpolator(If,fp,fst,ap,ast,nStages,HalfbandDesignMethod);
% [g,mStruct] = lowpassinterpolator(If,fp,fst,ap,ast,nStages,HalfbandDesignMethod);
%   
% Inputs:
%   If - interpolation factor
%   fp - frequency at the start of the pass band. Specified in normalized frequency units. Also called Fpass.
%   fst - frequency at the end of the stop band. Specified in normalized frequency units. Also called Fstop.
%   ap - amount of ripple allowed in the pass band in decibels (the default units). Also called Apass.
%   ast - attenuation in the stop band in decibels (the default units). Also called Astop.
%   nStages - Number of stages in the multistage filter
%   HalfbandDesignMethod - {'butter','ellip','iirlinphase','equiripple',kaiserwin'}
%
% Outputs:
%   g - A structure containing the filter coefficients
%   mStruct - A structure containing the output of MEASURE on the designed
%              filter.
%
% EXAMPLE: A Lowpass multistage decimator filter design using fdesign.decimator and LOWPASSINTERPOLATOR
%   fp = 0.1; fst = 0.3; ap = 3; ast = 70; HalfbandDesignMethod = 'butter'; nStages = 2;
%   f = fdesign.interpolator(32,'lowpass','Fp,Fst,Ap,Ast',fp,fst,ap,ast);
%   h = multistage(f,'HalfbandDesignMethod',HalfbandDesignMethod,'nStages',nStages);
%   [g,ms] = lowpassinterpolator(32,fp,fst,ap,ast,nStages,HalfbandDesignMethod);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

% If 'nStages' exists and is empty then assign a default value of 1.
if(exist('nStages','var') && isempty(nStages))
    nStages = 1;
end

multistageInputs = {};

switch nargin
    case {0,1,2,3,4}
        error(message('MATLAB:nargchk:notEnoughInputs'));
%     case 1
%         fdesignInputs = {If,'lowpass','fp,fst,ap,ast'};
%     case 2
%         fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp};
%     case 3
%         fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp,fst};
%     case 4
%         fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp,fst,ap};
    case 5
        fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp,fst,ap,ast};
    case 6
        fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp,fst,ap,ast};
        multistageInputs = {'nStages',nStages};
    case 7
        fdesignInputs = {If,'lowpass','fp,fst,ap,ast',fp,fst,ap,ast};
        multistageInputs = {'nStages',nStages,'HalfbandDesignMethod',HalfbandDesignMethod};
    otherwise
        error(message('MATLAB:TooManyInputs'));
end

% Removing any trailing empties from fdesignInputs 
fdesignInputs = removeTrailingEmpties(fdesignInputs);

% Designing the filter
f = fdesign.interpolator(fdesignInputs{:});
h = multistage(f,multistageInputs{:});


% Getting value of 'nStages' from 'h' if it was not passed as an input
% argument.
if(~exist('nStages','var'))
    nStages = size(h.getratechangefactors(),1);
end

% Pulling out information from object 'h' to a struct 'g'

if(strcmp(h.FilterStructure,'Direct-Form FIR Polyphase Interpolator')),
    g.Coeffs = h.Numerator;
    g.If = h.InterpolationFactor;
elseif(strcmp(h.FilterStructure,'IIR Polyphase Interpolator'))
    g.Coeffs = h.Polyphase;
    g.If = h.InterpolationFactor;
else
    for nn = 1:nStages,
        if(strcmp(h.Stage(nn).FilterStructure,'Direct-Form FIR Polyphase Interpolator'))
            g.(['Coeffs' num2str(nn)]) = h.Stage(nn).Numerator;
        else
            g.(['Coeffs' num2str(nn)]) = h.Stage(nn).Polyphase;
        end
        g.(['If' num2str(nn)]) = h.Stage(nn).InterpolationFactor;
    end
end


outVal = g;

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

function outCell = removeTrailingEmpties(inCell)
outCell = inCell;
nCells = length(inCell);
emptyStartIndex = nCells + 1;
for ii = 1:nCells,
    if(isempty(inCell{ii}))
        emptyStartIndex = ii;
        break;
    end
end
if(emptyStartIndex <= nCells)
    outCell(emptyStartIndex:end) = []; %removing the empties
end
end
