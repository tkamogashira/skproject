function [d,x,e,pauseSim,stopSim] = HelperAdaptiveNoiseCancellationProcessing(mhb,fhb,param)
%HelperAdaptiveNoiseCancellationProcessing Main processing for ANC.
%
% This function HelperAdaptiveNoiseCancellationProcessing is only in
% support of adaptncdemo. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

persistent Hd Hlms mngain fngain;
if isempty(Hd)  
    %% The Measured Maternal Electrocardiogram
    % The maternal electrocardiogram signal is obtained from the chest of the
    % mother. The goal of the adaptive noise canceller in this task is to
    % adaptively remove the maternal heartbeat signal from the fetal
    % electrocardiogram signal. The canceller needs a reference signal
    % generated from a maternal electrocardiogram to perform this task.  Just
    % like the fetal electrocardiogram signal, the maternal electrocardiogram
    % signal will contain some additive broadband noise.
    
    
    %% The Measured Fetal Electrocardiogram
    % The measured fetal electrocardiogram signal from the abdomen of the mother
    % is usually dominated by the maternal heartbeat signal that propagates
    % from the chest cavity to the abdomen.  We shall describe this propagation
    % path as a linear FIR filter with 10 randomized coefficients.  In
    % addition, we shall add a small amount of uncorrelated Gaussian noise to
    % simulate any broadband noise sources within the measurement.  Can you
    % determine the fetal heartbeat rate by looking at this measured signal?
    
    Wopt = [0 1.0 -0.5 -0.8 1.0 -0.1 0.2 -0.3 0.6 0.1];
    Hd = dsp.FIRFilter('Numerator',Wopt);
    
    %% Applying the Adaptive Noise Canceller
    % The adaptive noise canceller can use most any adaptive procedure to
    % perform its task.  For simplicity, we shall use the least-mean-square
    % (LMS) adaptive filter with 15 coefficients and a step size of 0.00007.
    % With these settings, the adaptive noise canceller converges reasonably
    % well after a few seconds of adaptation--certainly a reasonable period
    % to wait given this particular diagnostic application.
    
    Hlms = dsp.LMSFilter('Length',15,'StepSize',0.00007);
           
    mngain = param(2).InitialValue;
    fngain = param(1).InitialValue;
end

[paramNew, simControlFlags] = HelperUnpackUDP();

d = 0;
x = 0;
e = 0;

pauseSim = simControlFlags.pauseSim;
stopSim = simControlFlags.stopSim;

if stopSim
    return;  % Stop the simulation
end
if pauseSim
    return; % Pause the simulation (but keep checking for commands from GUI)
end

mnoise = mngain*randn(size(mhb));
fnoise = fngain*randn(size(mhb));
d = step(Hd,mhb) + fhb + fnoise;
x = mhb + mnoise;
[~,e] = step(Hlms,x,d);

if ~isempty(paramNew)   % If tuning hasn't started
    
    if simControlFlags.resetObj  % If "Reset" button is pressed
        reset(Hlms);        
    else
        mngain = paramNew(2);
        fngain = paramNew(1);        
    end
end




