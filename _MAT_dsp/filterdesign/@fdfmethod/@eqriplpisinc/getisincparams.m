function [freqFactor power] = getisincparams(~, hspecs)
%GETISINCPARAMS Return the inv sinc parameters. 

%   Copyright 2011 The MathWorks, Inc.

freqFactor = hspecs.FrequencyFactor;
power = hspecs.Power;

%[EOF]