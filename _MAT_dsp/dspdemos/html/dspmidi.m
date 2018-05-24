%%  Using a MIDI Control Surface to Interact with a Simulink Model
% This example shows how to use a MIDI control surface as a
% physical user interface to a Simulink model, allowing you to use knobs,
% sliders and buttons to interact with that
% model. It can be used in Simulink as well as with generated code running
% on a workstation.
%%
% Copyright 2011 The MathWorks, Inc.
%   $ $
%% Introduction
% Although MIDI is best known for its use in audio applications,
% this example illustrates that MIDI control surfaces have uses in many other
% applications besides audio. In this example, we use a MIDI
% controller to provide a user configurable value that can vary at runtime,
% we use it to control the
% amplitude of signals, and for several other illustrative purposes. This
% example is not comprehensive, but rather can provide inspiration
% for other creative uses of the control surface to interact with a model.
%
% By "MIDI control surfaces", we mean a physical device that
%  
% # has knobs, sliders and push buttons,
% # and uses the MIDI (Musical Instrument Digital Interface) protocol.
% 
% Many MIDI controllers plug
% into the USB port on a computer and make use of the MIDI support built
% into modern operating systems. Specific MIDI control surfaces that we
% have used include the Korg nanoKONTROL and the Behringer BCF2000.
% An advantage of the Korg device is its cost: it is readily
% available online at prices comparable to that of a good mouse. The Behringer device is more
% costly, but has the enhanced capability to both send and receive MIDI
% signals (the Korg can only send signals).
% This ability can be used to send data back from a model to keep a control
% surface
% in sync with changes to the model. We use this capability to bring a
% control surface in sync with the starting point of a model, so that
% initially changes to a specific control do not produce abrupt changes in the block output.
%
% To use your own controller with this example, plug it into the USB port
% on the
% computer and run the model |dspmidi|. Be sure that the model is not running
% when you plug in the control device. The model is originally configured
% such that it responds to movement of any control on the default MIDI
% device. This construction is meant to make it easier and more likely that
% this example works out of the box for all users. In a real use case, you
% would probably want to tie individual controls to each sub-portion of the
% model. For that purpose, you can use the |midiid|
% function to explicitly set the MIDI device parameter on the appropriate
% blocks in the model to recognize a specific control. For example, running
% |midiid|
% with the Korg nanoKONTROL device produces the following information:
%
%  >> [ctl device]=midiid
%  Move the control you wish to identify; type ^C to abort.
%  Waiting for control message... done
%  
%  ctl =
%  
%        1002
%
%  device =
%
%  nanoKONTROL
%
% The actual value of |ctl| depends on which control you moved.
%
% If you will be using a particular controller repeatedly, you may want to use
% the |setpref| command to set that controller as the default midi device:
%
%  >> setpref('midi','DefaultDevice','nanoKONTROL')
%
% This capability is particularly helpful on Linux, where your control
% surface may not be immediately recognized as the default device.
%
% After the controller is plugged in, hit the play button on dspmidi. Now
% move any knob or slider. You should see variations in the signals that
% are plotted in the various scopes in the model as you move any knob or
% slider.
% The model is initially configured to respond
% to any control.
%% Examples
% Next, several example use cases are provided. Each example uses the basic
% |MIDI  Controls| block to accomplish a different task. Look under the
% mask of the appropriate block in each example to see how that use case
% was accomplished. To reuse these in your own model,
% just drag a copy of the desired block into your model.
%% Example 1: MIDI Controls as a User Defined Source
% In example 1 of the model, we see the simplest use of this
% control. It can act as a source that is under user control. The original
% block MIDI Controls (in the DSP sources block library), outputs a
% value between 0 and 1. We have also created a
% slightly modified block, by placing a mask on the original block to
% output a source with values that cover a user defined range.
%% Example 2: MIDI Controls to Adjust the Level of a Single Signal
% In this example, a straightforward application of the MIDI controls block uses the 0
% to 1 range as an amplitude control on a given signal.
%% Example 3: MIDI Controls to Split a Signal Into Two Streams With User Controlled Relative Amplitudes.
% In this example, we see an example where a signal
% is split into two streams: $\alpha u$ and $\left ( 1-\alpha\right ) u$ where $\alpha$
% can be interactively controlled by the user with the control surface.
%% Example 4: MIDI Controls to Mix Two Signals Into One
% In this example, we create an arbitrary linear combination of two inputs:
% $y = \alpha u_1 + (1-\alpha) u_2$
% with $\alpha$ being set interactively by the user with the control surface.
%% Example 5: MIDI Controls to Generate a Sinuoid with Arbitrary Phase
% Lastly, example 5 allows the user input a desired phase with the control surface.
% A sinusoid with that phase is then generated. The phase can 
% be interactively varied as the model runs.
open_system('dspmidi');
%% Conclusions
% This model is provided to give inspiration for how the MIDI Controls
% block can be used to interact with a model. Other uses are possible and
% encouraged, including use with generated code.
bdclose('dspmidi');