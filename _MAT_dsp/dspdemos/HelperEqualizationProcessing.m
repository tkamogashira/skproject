function [y,tfe,pauseSim,stopSim] = HelperEqualizationProcessing(x,args,param)
%HELPEREQUALIZATIONPROCESSING Main processing for audio equalization.
%
% This function HelperEqualizationProcessing is only in support of 
% AudioEqualizationWithParametricEQExample. It may change in a future
% release.

% Copyright 2013 The MathWorks, Inc.

Fs   = args.SampleRate;
NFFT = args.NFFT;

persistent htfe hn1 hn2 hn3
if isempty(htfe)  
    hn1 = dsp.ParametricEQFilter('SampleRate',Fs,'CenterFrequency',...
        param(1).InitialValue,'Bandwidth',param(2).InitialValue,...
        'PeakGaindB',param(3).InitialValue);
    hn2 = dsp.ParametricEQFilter('SampleRate',Fs,'CenterFrequency',...
        param(4).InitialValue,'Bandwidth',param(5).InitialValue,...
        'PeakGaindB',param(6).InitialValue);
    hn3 = dsp.ParametricEQFilter('SampleRate',Fs,'CenterFrequency',...
        param(7).InitialValue,'Bandwidth',param(8).InitialValue,...
        'PeakGaindB',param(9).InitialValue);
        
    Navgs = 1;
    htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
        'SpectralAverages',Navgs,'FFTLengthSource','Property',...
        'FFTLength',NFFT);    
end

% Obtain new values for parameters through UDP Receive
[paramNew, simControlFlags] = HelperUnpackUDP();

y=0;
tfe=0;
pauseSim = simControlFlags.pauseSim;
stopSim = simControlFlags.stopSim;

if simControlFlags.stopSim
    return;  % Stop the simulation
end
if simControlFlags.pauseSim
    return; % Pause the simulation (but keep checking for commands from GUI)
end

u = randn(size(x,1),1);
y1 = step(hn1,[x,u]);
y2 = step(hn2,y1);
y3 = step(hn3,y2);
y = y3(:,1:2);
% Estimate transfer function
y13 = y1(:,3); y23 = y2(:,3); y33 = y3(:,3);
tfe = step(htfe,[u,y13,y23,u],[y13,y23,y33,y33]);

if ~isempty(paramNew)   % If tuning hasn't started
    
    if simControlFlags.resetObj  % If "Reset" button is pressed
        reset(hn1);
        reset(hn2);
        reset(hn3);
    else
        hn1.CenterFrequency = paramNew(1);
        hn1.Bandwidth       = paramNew(2);
        hn1.PeakGaindB      = paramNew(3);
        
        hn2.CenterFrequency = paramNew(4);
        hn2.Bandwidth       = paramNew(5);
        hn2.PeakGaindB      = paramNew(6);
        
        
        hn3.CenterFrequency = paramNew(7);
        hn3.Bandwidth       = paramNew(8);
        hn3.PeakGaindB      = paramNew(9);            
    end
end