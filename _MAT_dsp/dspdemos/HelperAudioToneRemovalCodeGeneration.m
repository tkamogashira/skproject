function HelperAudioToneRemovalCodeGeneration
%HELPERAUDIOTONEREMOVALCODEGENERATION Code generation for audio tone
%removal.
%
% Run this function to generate a mex file for the 
% HelperAudioToneRemovalProcessing function.

% Copyright 2013 The MathWorks, Inc.

SamplesPerFrame = 1024;
x = randn(SamplesPerFrame,2);

Fs = 44.1e3;
NFFT = 4192;
dF = Fs/NFFT;
stIdx  = 2;  Fstart = stIdx*dF;
spIdx = 100; Fstop  = spIdx*dF;

args.SampleRate = Fs;

ARGS = coder.Constant(args);

param(1).Name = 'Center Frequency';
param(1).InitialValue = 500;
param(1).Limits = [Fstart, Fstop];

param(2).Name = '3-dB Bandwidth';
param(2).InitialValue = 300;
param(2).Limits = [10, Fstop];

codegen -report HelperAudioToneRemovalProcessing -args {x,ARGS,param} 

