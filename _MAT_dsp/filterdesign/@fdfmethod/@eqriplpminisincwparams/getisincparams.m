function [freqFactor power] = getisincparams(this, hspecs)
%GETISINCPARAMS Return the inv sinc parameters. 

%   Copyright 2011 The MathWorks, Inc.

freqFactor = this.SincFrequencyFactor;
power = this.SincPower;

hspecs.FrequencyFactor = this.SincFrequencyFactor;
hspecs.Power = this.SincPower;

%[EOF]