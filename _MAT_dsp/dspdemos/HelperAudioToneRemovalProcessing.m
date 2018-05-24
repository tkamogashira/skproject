function [y,pauseSim,stopSim] = HelperAudioToneRemovalProcessing(x,args,param)
%HELPERAUDIOTONEREMOVALPROCESSING Main processing for audio tone removal.
%
% This function HelperAudioToneRemovalProcessing is only in support of 
% AudioInterferringToneRemovalExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.


Fs   = args.SampleRate;

persistent hn
if isempty(hn)  
    hn = dsp.NotchPeakFilter('SampleRate',Fs,'CenterFrequency',...
        param(1).InitialValue,'Bandwidth',param(2).InitialValue);
end

% Obtain new values for parameters through UDP Receive
[paramNew, simControlFlags] = HelperUnpackUDP();

y=0;
pauseSim = simControlFlags.pauseSim;
stopSim = simControlFlags.stopSim;

if simControlFlags.stopSim
    return;  % Stop the simulation
end
if simControlFlags.pauseSim
    return; % Pause the simulation (but keep checking for commands from GUI)
end

u = randn(size(x,1),1);
y = step(hn,[x,u]);

if ~isempty(paramNew)   % If tuning hasn't started
    if simControlFlags.resetObj   % If "Reset" button is pressed
        reset(hn);
    else
        hn.CenterFrequency = paramNew(1);
        hn.Bandwidth       = paramNew(2);        
    end
end




