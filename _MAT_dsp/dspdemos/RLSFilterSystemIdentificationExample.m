%% System Identification Using RLS Adaptive Filtering
% This example shows how to use a recursive least-squares (RLS) filter to
% identify an unknown system modeled with a lowpass FIR filter. Transfer
% function estimation is used to compare the frequency response of the
% unknown and estimated systems. This example allows you to dynamically
% tune key simulation parameters using a user interface (UI). The example
% also shows you how to use MATLAB Coder to generate code for the algorithm
% and accelerate the speed of its execution.
%
% Required MathWorks(TM) products:
%
% * DSP System Toolbox(TM)
%
% Optional MathWorks(TM) products:
%
% * MATLAB Coder(TM) for generating C code from the MATLAB simuation
% * Simulink (TM) for executing the Simulink version of the example

% Copyright 2013 The MathWorks, Inc.

%% Introduction 
% Adaptive system identification is one of the main applications of
% adaptive filtering. This example showcases system identification using an
% RLS filter. The example's workflow is depicted below:
%
% <<RLSSysIdentification00.png>>
%
% The unknown system is modeled by a lowpass FIR filter. The same input is
% fed to the FIR and RLS filters. The desired signal is the output of the
% unidentified system. The estimated weights of the RLS filter therefore
% converges to the coefficients of the FIR filter. The input signal and the
% output signals of the unknown and estimated systems are passed to a
% transfer function estimator. The desired and estimated frequency transfer
% functions are then visualized on a scope. The learning curve of the RLS
% filter (the plot of the mean square error (MSE) of the filter versus
% time) is also visualized.

%% Tunable FIR Filter
% The lowpass FIR filter used in this example is modeled using a
% <matlab:edit('dsp.VariableBandwidthFIRFilter')
% dsp.VariableBandwidthFIRFilter> System object. This object allows you to
% tune the filter's cutoff frequency while preserving the FIR structure.
% Tuning is achieved by multiplying each filter coefficient by a factor
% proportional to the current and desired cutoff frequencies. For more
% information on this object, type
% <matlab:help('dsp.VariableBandwidthFIRFilter') help
% dsp.VariableBandwidthFIRFilter>.

%% MATLAB Simulation
% <matlab:edit('HelperRLSFilterSystemIdentificationSim')
% HelperRLSFilterSystemIdentificationSim> is the function containing the
% algorithm's implementation. It instantiates, initializes and steps
% through the objects forming the algorithm.
%
% The function <matlab:edit('HelperRLSFilterSystemIdentification')
% HelperRLSFilterSystemIdentification> wraps around
% <matlab:edit('HelperRLSFilterSystemIdentificationSim')
% HelperRLSFilterSystemIdentificationSim> and iteratively calls it,
% providing continuous adapting to the unidentified FIR system. It also
% plots the following:
%
% # The desired versus estimated frequency transfer functions.
% # The learning curve of the RLS filter.
%
% Plotting occurs when the 'plotResults' input to the function is 'true'.
%
% <matlab:run('HelperRLSFilterSystemIdentification') Execute
% HelperRLSFilterSystemIdentification> to run the simulation and plot the
% results on scopes. Note that the simulation runs for as long as the user
% does not explicitly stop it.
%
% The plots below are the output of running the above simulation for 100
% time-steps:
%
% <<RLSSysIdentification01.png>>
%
%
% <<RLSSysIdentification03.png>>
%
% The fast convergence of the RLS filter towards the FIR filter can be seen 
% through the above plots.
%
% HelperRLSFilterSystemIdentification launches a User Interface (UI)
% designed to interact with the simulation. The UI allows you to tune
% parameters and the results are reflected in the simulation instantly. For
% example, moving the slider for the 'Cutoff Frequency' to the right while
% the simulation is running, increases the FIR filter's cutoff frequency.
% Similarly, moving the slider for the 'RLS Forgetting Factor' tunes the
% forgetting factor of the RLS filter. The plots reflects your changes as
% you tune these parameters. For more information on the UI, please refer
% to <matlab:edit('HelperCreateParamTuningUI') HelperCreateParamTuningUI>.
% 
% There are also two buttons on the UI - the 'Reset' button resets the
% states of the RLS and FIR filters to their initial values, and 'Stop
% simulation' ends the simulation. If you tune the RLS filter's forgetting
% factor to a value that is too low, you will notice that the RLS filter
% fails to converge to the desired solution, as expected. You can restore
% convergence by first increasing the forgetting factor to an acceptable
% value, and then clicking the 'Reset' button. The interaction between the
% UI and the simulation is performed using UDP. Using UDP enables the UI to
% control either the simulation or, optionally, a MEX-file (or standalone
% executable) generated from the simulation code as detailed below. If you
% have a MIDI controller, it is possible to synchronize it with the UI. You
% can do this by choosing a MIDI control in the dialog that is opened when
% you right-click on the sliders or buttons and select "Synchronize" from
% the context menu. The chosen MIDI control then works in accordance with
% the slider/button so that operating one control is tracked by the other.
%
% <<RLSSysIdentification04.png>>
%
%% Generating the MEX-File
% MATLAB Coder can be used to generate C code for the function
% <matlab:edit('HelperRLSFilterSystemIdentificationSim')
% HelperRLSFilterSystemIdentificationSim> as well. In order to generate a 
% MEX-file for your platform, execute the following:

currDir = pwd;  % Store the current directory address
mexDir   = [tempdir 'RLSFilterSystemIdentificationExampleMEXDir']; % Name of                                          
% temporary directory
if ~exist(mexDir,'dir')
    mkdir(mexDir);       % Create temporary directory
end
cd(mexDir);          % Change directory

codegen('HelperRLSFilterSystemIdentificationSim', ...
        '-o','HelperRLSFilterSystemIdentificationSimMEX');
%%
% By calling the wrapper function
% <matlab:edit('HelperRLSFilterSystemIdentification')
% HelperRLSFilterSystemIdentification> with  |'true'| as an argument, the
% generated MEX-file |HelperRLSFilterSystemIdentificationSimMEX| can be
% used instead of |HelperRLSFilterSystemIdentificationSim| for the
% simulation. In this scenario, the UI is still running inside the MATLAB
% environment, but the main processing algorithm is being performed by a
% MEX-file. Performance is improved in this mode without compromising the
% ability to tune parameters.
%
% <matlab:run('HelperRLSFilterSystemIdentification(true)') Click here> to
% call |HelperRLSFilterSystemIdentification| with |'true'| as argument to
% use the MEX-file for simulation. Again, the simulation runs till the user
% explicitly stops it from the UI.
%
%% Simulation Versus MEX Speed Comparison
% Creating MEX-Files often helps achieve faster run-times for simulations.
% In order to measure the performance improvement, let's first time the
% execution of the algoriothm in MATLAB without any plotting:
clear HelperRLSFilterSystemIdentificationSim
disp('Running the MATLAB code...')
tic
nTimeSteps = 100;
for ind = 1:nTimeSteps
     HelperRLSFilterSystemIdentificationSim();
end
tMATLAB = toc;
%%
% Now let's time the run of the corresponding MEX-file and display the 
% results:
clear HelperRLSFilterSystemIdentificationSim
disp('Running the MEX-File...')
tic
for ind = 1:nTimeSteps
    HelperRLSFilterSystemIdentificationSimMEX();
end
tMEX = toc;

disp('RESULTS:')
disp(['Time taken to run the MATLAB System object: ', num2str(tMATLAB),...
     ' seconds']);
disp(['Time taken to run the MEX-File: ', num2str(tMEX), ' seconds']);
disp(['Speed-up by a factor of ', num2str(tMATLAB/tMEX),...
    ' is achieved by creating the MEX-File']);

%% Clean up Generated Files
% The temperory directory previously created can be deleted through:
cd(currDir);
clear HelperRLSFilterSystemIdentificationSimMEX;
rmdir(mexDir, 's');

%% Simulink Version
%
% <matlab:open_system('rlsfiltersystemidentification')
% rlsfiltersystemidentification> is a Simulink model that implements the
% RLS System identification example highlighted in the previous sections.
%
% <<RLSSysIdentification05.png>>
%
% In this model, the lowpass FIR filter is modeled using the
% <matlab:edit('dsp.VariableBandwidthFIRFilter')
% dsp.VariableBandwidthFIRFilter> System object used inside a MATLAB System
% block. Transfer function estimation is performed using the Discrete
% Transfer Function Estimator block.
%
% <matlab:run('hCreateRLSSystemIdentificationUI') Execute
% hCreateRLSSystemIdentificationUI> to launch the UI designed to interact
% with the Simulink model. You can also launch the UI by clicking the
% 'Launch Parameter Tuning UI' link on the model. You can use the UI to
% tune the cutoff frequency of the FIR filter and the forgetting factor of
% the RLS filter. You can additionally reset the states of the filters by
% clicking the Reset botton of the UI. You can terminate the simulation by
% clicking the Stop button of the UI.
%
% The model generates code when it is simulated. Therefore, it must be
% executed from a folder with write permissions. 

displayEndOfDemoMessage(mfilename)