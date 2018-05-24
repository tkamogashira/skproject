%% Sound Pressure Measurement Using A- and C- Weighting Filters
% This example shows how to apply weighting filters to measure sound
% pressure. A user interface (UI) allows the user to control various 
% parameters while the simulation is running.

%% Sound Pressure Measurement
% In many applications involving acoustic measurements, the final sensor is
% the human ear. Thus, most acoustic measurements try to represent the 
% ear's subjective perception of a sound. Instrumentation devices are built
% to provide a linear response, but the ear is a nonlinear sensor. 
% Therefore, special filters known as weighting filters, are used to 
% account for these nonlinearities.
%
% For more design details on these audio weighting filters, see 
% <matlab:web([docroot,'/dsp/examples/audio-weighting-filters.html']); 
% Audio Weighting Filter>.

% Copyright 2014 The MathWorks, Inc.

%% MATLAB Simulation
% <matlab:edit('HelperSoundPressureUI') HelperSoundPressureUI> is the 
% function containing the algorithm's implementation. It instantiates, 
% initializes and steps through the components forming the algorithm.
%
% <matlab:run('HelperSoundPressureUI') Execute HelperSoundPressureUI> to 
% run the simulation and plot the results on scopes. Note that the 
% simulation runs for as long as the user does not explicitly stop it.
%
% HelperSoundPressureUI launches a User Interface (UI) designed to interact
% with the simulation. The interface allows you to select an audio source 
% and a filter, and the results are reflected in the simulation instantly. 
% For example, selecting a filter changes the RMS pressure. Notice how the 
% corresponding plot in the SpectrumAnalyzer reflects this change. There is
% also a 'Stop' button on the UI that ends the simulation. The interaction 
% between the interface and the simulation is performed using UDP.
%
% <<soundPressure01.png>>
%
%
% <<soundPressure02.png>>
%
displayEndOfDemoMessage(mfilename)
