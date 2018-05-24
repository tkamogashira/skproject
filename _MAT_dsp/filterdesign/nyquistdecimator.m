function [outVal,mStruct] = nyquistdecimator(df,tw,ast,nStages,HalfbandDesignMethod)
%NYQUISTDECIMATOR Nyquist multistage decimator filter design.
% Signatures:
% g = nyquistdecimator(df,tw,ast);
% g = nyquistdecimator(df,tw,ast,nStages);
% g = nyquistdecimator(df,tw,ast,nStages,HalfbandDesignMethod);
% [g,mStruct] = nyquistdecimator(df,tw,ast,nStages,HalfbandDesignMethod)
%   
% Inputs:
%   df - decimation factor
%   tw - Transition Width
%   ast - Stop band attenuation in decibels
%   nStages - Number of stages in the multistage filter
%   HalfbandDesignMethod - {'butter','ellip','iirlinphase','equiripple',kaiserwin'}
%
% Outputs:
%   g - A structure containing the filter coefficients
%   mStruct - A structure containing the output of MEASURE on the designed
%              filter.
%
% EXAMPLE: A Nyquist multistage decimator filter design using fdesign.decimator and NYQUISTDECIMATOR
%    tw = 0.02; HalfbandDesignMethod = 'kaiserwin'; nStages = 2;
%    f = fdesign.decimator(32,'Nyquist',32,'tw',tw);
%    h = multistage(f,'HalfbandDesignMethod',HalfbandDesignMethod,'nStages',nStages);
%    [g,ms] = nyquistdecimator(32,tw,[],nStages,HalfbandDesignMethod);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

% If tw or ast do not exist, define them as empty
if(~exist('tw','var'))
    tw = [];
end
if(~exist('ast','var'))
    ast = [];
end    

% If 'nStages' exists and is empty then assign a default value of 1.
if(exist('nStages','var') && isempty(nStages))
    nStages = 1;
end

multistageInputs = {};

if(nargin < 1),
    error(message('MATLAB:nargchk:notEnoughInputs'));
elseif(nargin == 4),
    multistageInputs = {'nStages',nStages};
elseif(nargin == 5),
    multistageInputs = {'nStages',nStages,'HalfbandDesignMethod',HalfbandDesignMethod};
elseif(nargin >= 6),
    error(message('MATLAB:TooManyInputs'));
end

fdesignInputs = getFdesignInputs(df,tw,ast);

% Designing the filter
f = fdesign.decimator(fdesignInputs{:});
h = multistage(f,multistageInputs{:});

% Getting value of 'nStages' from 'h' if it was not passed as an input
% argument.
if(~exist('nStages','var'))
    nStages = size(h.getratechangefactors(),1);
end

% Pulling out information from object 'h' to a struct 'g'

if(strcmp(h.FilterStructure,'Direct-Form FIR Polyphase Decimator')),
    g.Coeffs = h.Numerator;
    g.df = h.DecimationFactor;
elseif(strcmp(h.FilterStructure,'IIR Polyphase Decimator'))
    g.Coeffs = h.Polyphase;
    g.df = h.DecimationFactor;
else
    for nn = 1:nStages,
        if(strcmp(h.Stage(nn).FilterStructure,'Direct-Form FIR Polyphase Decimator'))
            g.(['Coeffs' num2str(nn)]) = h.Stage(nn).Numerator;
        else
            g.(['Coeffs' num2str(nn)]) = h.Stage(nn).Polyphase;
        end
        g.(['df' num2str(nn)]) = h.Stage(nn).DecimationFactor;
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

function outCell = getFdesignInputs(df,tw,ast)

outCell = {df,'nyquist',df};
if(~isempty(tw))
    outCell{end+1} = tw;
elseif(isempty(tw) && ~isempty(ast))
    error('MATLAB:dsp:nyquistdecimator:OnlyAstNonEmpty','tw must be provided along with Ast.');
end
if(~isempty(ast))
    outCell{end+1} = ast;
end

end