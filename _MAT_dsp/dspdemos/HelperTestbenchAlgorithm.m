function y = HelperTestbenchAlgorithm(x, tunedParams, intialParams, resetFlag)
%HELPERTESTBENCHALGORITHM Example algorithm that does equalization on the
% input data stream using dsp.ParametricEQFilter System object.
%
% This function HelperTestbenchAlgorithm is only in support of
% GenDSPTestbenchExample.

% Copyright 2013 The MathWorks, Inc.

narginchk(1,4);

% Create a persistent System object
persistent PE1
if isempty(PE1)
    if nargin>=3
        PE1 = dsp.ParametricEQFilter('Bandwidth', intialParams.BW, ...
            'CenterFrequency', intialParams.CF, ...
            'PeakGaindB', intialParams.Gain);
    else
        PE1 = dsp.ParametricEQFilter;
    end
end

% Tune properties of the System object based on tunedParams input
if nargin>=2 && ~isempty(tunedParams)
    [PE1] = processTunedParams(tunedParams, PE1);
end

% Reset System object
if nargin==4 && resetFlag
    reset(PE1);
end

% Process input data
y = step(PE1,x);

%-------------------------------------
function [PE1] = processTunedParams(tunedParams, PE1)

if isfield(tunedParams,'CF') && ~isnan(tunedParams.CF)
    PE1.CenterFrequency = tunedParams.CF;
end

if isfield(tunedParams,'BW') && ~isnan(tunedParams.BW)
    PE1.Bandwidth = tunedParams.BW;
end

if isfield(tunedParams,'Gain') && ~isnan(tunedParams.Gain)
    PE1.PeakGaindB = tunedParams.Gain;
end
