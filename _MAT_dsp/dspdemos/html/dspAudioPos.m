%% Positional Audio
% This example shows several basic aspects of audio signal
% positioning. The listener occupies a location in the center of a circle,
% and the position of the sound source is varied so that it remains within
% the circle.  In this example, the sound source is a monaural recording of
% a helicopter.  The sound field is represented by five discrete speaker
% locations on the circumference of the circle and a low-frequency output
% that is presumed to be in the center of the circle.

% Copyright 2007-2012 The MathWorks, Inc.

%% Example Prerequisites
% This example requires a 5.1-channel speaker configuration, and relies on
% the audio channels being mapped to physical locations as follows:
%
% # Front left
% # Front right
% # Front center
% # Low frequency
% # Rear left
% # Rear right
% 
%
% This is the default Windows(R) speaker configuration for 5.1 channels.
% Depending on the type of soundcard used, this example may work reasonably
% well for other speaker configurations.

%% Example Basics
% There are two source blocks of interest in the model.  The first is the
% audio signal itself, and the second is the spatial location of the
% helicopter. The spatial location of the helicopter is represented by a
% pair of cartesian coordinates that are constrained to lie within the unit
% circle.  By default, this location is determined by the block labeled
% "Set position randomly."  This block supplies the input for the MATLAB
% Function block labeled "Speaker volume computation," which determines a
% matrix of speaker volumes.  The outer product of the sound source is then
% taken with the speaker position matrix, which is then supplied to the six
% speakers via the To Audio Device block.

%%
open_system('dspAudioPos');
close all hidden;
%%
bdclose dspAudioPos;

%% Manually Determining the Helicopter Position
% You can also determine the helicopter position manually.  To do this,
% select the switch in the model so that the signal being supplied to the
% computeVol block is coming from the block labeled "Set position
% visually."  Then, double-click on the new source block. A GUI appears
% that enables you to move the helicopter to different locations within the
% circle using the mouse, thereby changing the speaker amplitudes.


%%
h = dspAudioPosGui([.5 .5], 'foobar', @(x,y)(3));
%%
close(h);

%% Spatial Mixing Algorithm
% The monaural audio source is mixed into six channels, each of which
% corresponds to a speaker.  There is one low-frequency channel in the
% center of the circle and five speakers that lie on the circumference, as
% shown in the grey area of the GUI above.  The listener is represented by
% a stick figure in the center of the circle.
%
% The following algorithm is used to determine the speaker amplitudes:
% 
% 1. At the center of the circle, all of the amplitudes are equal.  The 
%    value for each speaker, including the low-frequency speaker, is set to
%    1/sqrt(5).
%
% 2. On the perimeter of the circle, the amplitudes of the speakers are
%    determined using Vector Based Amplitude Panning (VBAP).  This
%    algorithm operates as follows: 
%
% a) Determine the two speakers on either side of the source or, in the
%    degenerate case, the single speaker.
%
% b) Interpret the vectors determined by the speaker positions in (a) as
%    basis vectors.  Use these basis vectors to represent the normalized
%    source position vector.  The coefficients in this new basis
%    represent the relative speaker amplitudes after normalization.
%    
% For this part of the algorithm, the amplitude of the low-frequency 
% channel is set to zero.
%
% 3) As the source moves from the center to the periphery, there is a
% transition from algorithm (1) to algorithm (2).  This transition decays 
% as a cubic function of the radial distance.  The amplitude vectors are
% normalized so the power is constant independent of source location.
%
% 4) Finally, the amplitudes decay as the distance from the center
% increases according to an inverse square law, such that the amplitude at
% the perimeter of the circle is one-quarter of the amplitude in the center.
%
% For more details about Vector Based Amplitude Panning, please consult
% the references.
%

%% References
% Pulki, Ville. "Virtual Sound Source Positioning Using Vector Base 
% Amplitude Panning." _Journal Audio Engineering Society_. Vol 45, No 6. June 
% 1997.
