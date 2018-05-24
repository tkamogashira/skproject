function [tfe,err,pauseSim,stopSim] = ...
         HelperRLSFilterSystemIdentificationSim()
% HELPERRLSFILTERSYSTEMIDENTIFICATIONSIM implements algorithm used in 
% RLSFilterSystemIdentificationExample. 
% This functions instantiates, initializes and steps through the System
% objects used in the algorithm. 
% 
% You can tune the cutoff frequency of the desired system and the
% forgetting factor of the RLS filter through the GUI that appears when 
% RLSFilterSystemIdentificationExample is executed. 

%   Copyright 2013 The MathWorks, Inc.

%#codegen

% Instantiate and initialize System objects. The objects are declared
% persistent so that they are not recreated every time the function is
% called inside the simulation loop. 
persistent hrls hsin hfir htfe
if isempty(hrls)
    % FIR filter models the unidentified system
    hfir = dsp.VariableBandwidthFIRFilter('SampleRate',1e4,...
                                          'FilterOrder',30,...
                                          'CutoffFrequency',.48 * 1e4/2);
    % RLS filter is used to identify the FIR filter                    
    hrls = dsp.RLSFilter('ForgettingFactor',.99,...
                         'Length',28);
    % Sine wave used to generate input signal                     
    hsin = dsp.SineWave('SamplesPerFrame',1024,...
                        'SampleRate',1e4,...
                        'Frequency',50);
    % Transfer function estimator used to estimate frequency responses of 
    % FIR and RLS filters.                     
    htfe = dsp.TransferFunctionEstimator(...
                        'FrequencyRange','centered',...
                        'SpectralAverages',10,...
                        'FFTLengthSource','Property',...
                        'FFTLength',1024,...
                        'Window','Kaiser');
end

[paramNew, simControlFlags] = HelperUnpackUDP();

tfe = 0;
err = 0;
pauseSim = simControlFlags.pauseSim;
stopSim = simControlFlags.stopSim;

if simControlFlags.stopSim
    return;  % Stop the simulation
end
if simControlFlags.pauseSim
    return; % Pause the simulation (but keep checking for commands from GUI)
end

% Generate input signal - sine wave plus Gaussian noise
inputSignal = step(hsin) +  .1 * randn(1024,1);

% Filter input though FIR filter
desiredOutput = step(hfir,inputSignal);

% Pass original and desired signals through the RLS Filter
[rlsOutput , err] = step(hrls,inputSignal,desiredOutput);

% Prepare system input and output for transfer function estimator
inChans = repmat(inputSignal,1,2);
outChans = [desiredOutput,rlsOutput];

% Estimate transfer function
tfe = step(htfe,inChans,outChans);

% Tune FIR cutoff frequency and RLS forgetting factor
if ~isempty(paramNew)
        hfir.CutoffFrequency  = paramNew(1);
        hrls.ForgettingFactor = paramNew(2);
        if simControlFlags.resetObj % reset System objects
            reset(hrls);
            reset(hfir);
            reset(htfe);
            reset(hsin);
        end
end

end