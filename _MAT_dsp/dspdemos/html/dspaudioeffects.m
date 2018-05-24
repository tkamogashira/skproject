%% Audio Special Effects
% This example shows three audio effects applied to music read from a file:
% flanging, reverberation, and the simulation of synthetic stereo from a
% mono source.
%
% Some of the concepts shown by this model include:
%
% * Demonstration of audio sound effects
% * Easy and intuitive implementation of sound effects using  
% DSP System Toolbox(TM) blocks
% * Implementation of control flow for a model using subsystems, masks,
% and the Simulink(R) Switch Case and Switch Case Action blocks
% 
%%
% Copyright 2007-2013 The MathWorks, Inc.
%%
open_system('dspaudioeffects');
%% Exploring the Example
% Select a sound effect by setting the *Audio effect* parameter of the
% Effect block. Run the example. Listen to the original sound or the
% enhanced sound by using the switch before the 'To Audio Device' block.
% Change the *Audio effect* parameter and listen to the difference.
%% The Example Model
% Right-click the Effect block, select "Mask" and click "Look Under Mask"
open_system('dspaudioeffects/Effect','force');
%%
% There are three action subsystems. Each implements one of the three
% effects. The active subsystem is controlled by a Simulink Switch Case
% block. The *Effect* parameter of the parent block drives the switch,
% which in turn activates one of the three audio effects subsystems.
%
% To view the implementation of an effect, double-click on its subsystem.
% The contents of each subsystem are shown below.
%%
% *Flanging*
%
% Flanging is a time-based audio effect created by mixing a signal with a
% delayed version of itself. The amount of delay is time-varying. In the
% example, this is accomplished by using the DSP System Toolbox(TM)
% Variable Fractional Delay block. Use a time-varying signal on the block's 
% optimal Delay port to create a time-varying flanging effect.
open_system('dspaudioeffects/Effect/Flanging','force');
%%
% *Reverberation*
%
% Reverberation is a property of sound in an enclosed space such as an 
% auditorium. Reflections of the sound source from various surfaces create 
% multiple echoes of lesser magnitude that decay in time.
%
% A simple but effective means of simulating reverberation is a feedback
% loop. The feedback loop is recognized as a single-pole IIR filter. You
% can modify the parameters of each block to change the characteristics of
% the reverberation.
open_system('dspaudioeffects/Effect/Reverberation','force');
%%
% *Synthetic Stereo*
%
% One way of creating the sensation of stereo from a mono source is to add
% a delayed version of the signal to itself. This is shown in the Stereo
% subsystem.
open_system('dspaudioeffects/Effect/Stereo','force');
%%
close_system('dspaudioeffects');
%% References
% More information on audio effects can be found on the Harmony Central
% website.