function HelperANCCodeGeneration
%HelperANCCodeGeneration Code generation for ANC demo.
%
% Run this function to generate a mex file for the 
% HelperAdaptiveNoiseCancellationProcessing function.

% Copyright 2013 The MathWorks, Inc.

SamplesPerFrame = 75;
x = randn(SamplesPerFrame,1);
d = randn(SamplesPerFrame,1);

param(1).Name = 'Fetal Heartbeat Measurement noise';
param(1).InitialValue = 0.02;
param(1).Limits = [0, 0.1];

param(2).Name = 'Maternal Heartbeat Measurement noise';
param(2).InitialValue = 0.02;
param(2).Limits = [0, 0.1];    

codegen -report HelperAdaptiveNoiseCancellationProcessing -args {x,d,param} 

