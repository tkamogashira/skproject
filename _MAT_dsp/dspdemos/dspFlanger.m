%% Audio Flanging 
% This example shows how to apply a flanging effect and a stereo panning 
% effect to an audio stream. A User Interface (UI) is used to control the 
% audio effects. This interface plays the audio stream that contains the 
% flanging and stereo panning effects. It displays the spectrograms of 
% original and flanging audio streams.
%
% This example also shows you how to process a continuous stream of data in
% MATLAB(R). Processing frames of data avoids having to load the complete 
% data at one time.

%   Copyright 1995-2014 The MathWorks, Inc.

%% Introduction
% Flanging, or "whooshing" sound is a type of phasing effect. To create it,
% you add the input signal to its delayed version while varying the delay 
% over time. The following figure shows a block diagram implementation of 
% flanging.
%
% <<dspFlangerModel.png>>
%
% The stereo panner adds the effect of the audio signal moving from one 
% speaker to the other.
%
% See more information on audio effects [ <#14 1> ].

%% MATLAB Simulation
% <matlab:edit('HelperDspFlanger') HelperDspFlanger> is the function 
% containing the algorithm's implementation. It instantiates, initializes 
% and steps through the components forming the algorithm.
%
% <matlab:run('HelperDspFlanger') Execute HelperDspFlanger> to run the 
% simulation and plot the results on scopes. Note that the simulation runs 
% for as long as the user does not explicitly stop it.
%
% HelperDspFlanger launches a User Interface (UI) designed to interact with
% the simulation. The UI allows you to tune parameters and the results are
% reflected in the simulation instantly. For example, moving the slider for
% the 'Frequency of delay for flanging' to the right while the simulation 
% is running, increases the frequency of the sine wave used to change the 
% variable fractional delay over time. Similarly, moving the slider for the
% 'Stereo Panning' moves the audio signal from one speaker to the other. 
% For more information on the UI, please refer to
% <matlab:edit('HelperCreateParamTuningGUI') HelperCreateParamTuningGUI>.
% 
% There are three buttons on the UI - 'Reset' and 'Pause simulation' are 
% not used in this example, 'Stop simulation' ends the simulation. The 
% interaction between the UI and the simulation is performed using UDP. 

%% Results
% We can clearly see the frequency changing over time in the spectrogram of
% the audio signal with flanging.
%
% <<audioFlanger02.png>> 
%
% <<audioFlanger01.png>>
%

%% Summary
% This example shows you how to implement the flanging audio effect using
% variable fractional delay applied to streaming data.

%% Selected Bibliography 
% # _DAFX: Digital Audio Effects_, edited by Udo Zölzer, John Wiley & Sons, 
% 2002.

displayEndOfDemoMessage(mfilename)
