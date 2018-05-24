function HelperAudioEqualizationCodeGeneration
%HelperAudioEqualizationCodeGeneration Code generation for audio equalizer
%
% Run this function to generate a mex file for the 
% HelperEqualizationProcessing function.

% Copyright 2013 The MathWorks, Inc.

SamplesPerFrame = 8000;
x = randn(SamplesPerFrame,2);

Fs = 44.1e3;
NFFT = 4192;
dF = Fs/NFFT;


args.SampleRate = Fs;
args.NFFT = NFFT;

ARGS = coder.Constant(args);

param(1).Name = 'Center Frequency1';
param(1).InitialValue = 300;
param(1).Limits = [0, Fs/2];

param(2).Name = 'Bandwidth1';
param(2).InitialValue = 300;
param(2).Limits = [10, Fs/2];

param(3).Name = 'Peak Gain1 (dB)';
param(3).InitialValue = 3;
param(3).Limits = [-15 15];

param(4).Name = 'Center Frequency2';
param(4).InitialValue = 1000;
param(4).Limits = [0, Fs/2];

param(5).Name = 'Bandwidth2';
param(5).InitialValue = 500;
param(5).Limits = [10, Fs/2];

param(6).Name = 'Peak Gain2 (dB)';
param(6).InitialValue = -2;
param(6).Limits = [-15 15];

param(7).Name = 'Center Frequency3';
param(7).InitialValue = 3000;
param(7).Limits = [0, Fs/2];

param(8).Name = 'Bandwidth3';
param(8).InitialValue = 700;
param(8).Limits = [10, Fs/2];

param(9).Name = 'Peak Gain3 (dB)';
param(9).InitialValue = 2;
param(9).Limits = [-15 15];         


codegen -report HelperEqualizationProcessing -args {x,ARGS,param} 

