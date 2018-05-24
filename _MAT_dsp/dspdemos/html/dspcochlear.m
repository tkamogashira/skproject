%% Cochlear Implant Speech Processor
% This example shows how to simulate the design of a cochlear implant that
% can be placed in the inner ear of a profoundly deaf person to restore
% partial hearing.
% Signal processing is used in cochlear implant development to convert
% sound to electrical pulses. The pulses can bypass the damaged parts of a
% deaf person's ear and be transmitted to the brain to provide partial
% hearing.
%
% This example highlights some of the choices made when designing cochlear
% implant speech processors that can be modelled using the 
% DSP System Toolbox(TM). In particular, the benefits of using a cascaded
% multirate, multistage FIR filter bank instead of a parallel, single-rate,
% second-order-section IIR filter bank are shown.

% Copyright 2007-2012 The MathWorks, Inc.

%% Human Hearing
% Converting sound into something the human brain can understand involves
% the inner, middle, and outer ear, hair cells, neurons, and the central
% nervous system. When a sound is made, the outer ear picks up acoustic
% waves, which are converted into mechanical vibrations by tiny bones in
% the middle ear. The vibrations move to the inner ear, where they travel
% through fluid in a snail-shaped structure called the cochlea. The fluid
% displaces different points along the basilar membrane of the cochlea.
% Displacements along the basilar membrane contain the frequency
% information of the acoustic signal. A schematic of the membrane is shown
% here (not drawn to scale).
%%
[dspcochlearimage, dspcochlearmap] = imread('demoSnapShot.gif');
[cochlearimagerows,cochlearimagecols] = size(dspcochlearimage);
cochlearfigure = figure('Units','pixels','Position',[100 100 cochlearimagecols cochlearimagerows]);
colormapsave = colormap;
colormap(dspcochlearmap);
image(dspcochlearimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear dspcochlearimage;
close(cochlearfigure);
%%
%
% *Frequency Sensitivity in the Cochlea*
%
% Different frequencies cause the membrane to displace maximally at
% different positions. Low frequencies cause the membrane to be displaced
% near its apex, while high frequencies stimulate the membrane at its base.
% The amplitude of the displacement of the membrane at a particular point
% is proportional to the amplitude of the frequency that has excited it.
% When a sound is composed of many frequencies, the basilar membrane is
% displaced at multiple points. In this way the cochlea separates complex
% sounds into frequency components.
%
% Each region of the basilar membrane is attached to hair cells that bend
% proportionally to the displacement of the membrane. The bending causes an
% electrochemical reaction that stimulates neurons to communicate the sound
% information to the brain through the central nervous system.

%% Alleviating Deafness with Cochlear Implants
% Deafness is most often caused by degeneration or loss of hair cells in
% the inner ear, rather than a problem with the associated neurons. This
% means that if the neurons can be stimulated by a means other than hair
% cells, some hearing can be restored. A cochlear implant does just that.
% The implant electrically stimulates neurons directly to provide
% information about sound to the brain.
%
% The problem of how to convert acoustic waves to electrical impulses is
% one that Signal Processing helps to solve. Multichannel cochlear implants
% have the following components in common:
%
% 
% * A microphone to pick up sound
% * A signal processor to convert acoustic waves to electrical signals
% * A transmitter
% * A bank of electrodes that receive the electrical signals from the transmitter, and then stimulate auditory nerves.
%
% Just as the basilar membrane of the cochlea resolves a wave into its
% component frequencies, so does the signal processor in a cochlear implant
% divide an acoustic signal into component frequencies, that are each then
% transmitted to an electrode. The electrodes are surgically implanted into
% the cochlea of the deaf person in such a way that they each stimulate the
% appropriate regions in the cochlea for the frequency they are
% transmitting. Electrodes transmitting high-frequency (high-pitched)
% signals are placed near the base, while those transmitting low-frequency
% (low-pitched) signals are placed near the apex. Nerve fibers in the
% vicinity of the electrodes are stimulated and relay the information to
% the brain. Loud sounds produce high-amplitude electrical pulses that
% excite a greater number of nerve fibers, while quiet ones excite less. In
% this way, information both about the frequencies and amplitudes of the
% components making up a sound can be transmitted to the brain of a deaf
% person by a cochlear implant.

%% Exploring the Example
% The block diagram at the top of the model represents a cochlear implant
% speech processor, from the microphone which picks up the sound (Input
% Source block) to the electrical pulses that are generated. The
% frequencies increase in pitch from Channel 0, which transmits the lowest
% frequency, to Channel 7, which transmits the highest.
%
% To hear the original input signal, double-click the Original Signal block
% at the bottom of the model. To hear the output signal of the simulated
% cochlear implant, double-click the Reconstructed Signal block.
%
% There are a number of changes you can make to the model to see how
% different variables affect the output of the cochlear implant speech
% processor. Remember that after you make a change, you must rerun the
% model to implement the changes before you listen to the reconstructed
% signal again.
%%
open_system('dspcochlear');
sim('dspcochlear');
%%
bdclose dspcochlear;
colormap(colormapsave);
clear dspcochlearmap;
clear cochlearimagerows;
clear cochlearimagecols;
%%
% *Simultaneous Versus Interleaved Playback*
%
% Research has shown that about eight frequency channels are necessary for
% an implant to provide good auditory understanding for a cochlear implant
% user. Above eight channels, the reconstructed signal usually does not
% improve sufficiently to justify the rising complexity. Therefore, this
% example resolves the input signal into eight component frequencies, or
% electrical pulses.
%
% The Speech Synthesized from Generated Pulses block at the bottom left of
% the model allows you to either play each electrical channel
% simultaneously or sequentially. Oftentimes cochlear implant users
% experience inferior results with simultaneous frequencies, because the
% electrical pulses interact with each other and cause interference.
% Emitting the pulses in an interleaved manner mitigates this problem for
% many people. You can toggle the *Synthesis mode* of the Speech
% Synthesized From Generated Pulses block to hear the difference between
% these two modes. Zoom in on the Time Scope block to observe that the
% pulses are interleaved.
%
% *Adjusting for Noisy Environments*
%
% Noise presents a significant challenge to cochlear implant users. Select
% the *Add noise* parameter in the Input Source block to simulate the effects
% of a noisy environment on the reconstructed signal. Observe that the
% signal becomes difficult to hear. The Denoise block in the model uses a
% Soft Threshold block to attempt to remove noise from the signal. When the
% *Denoise* parameter in the Denoise block is selected, you can listen to
% the reconstructed signal and observe that not all the noise is removed.
% There is no perfect solution to the noise problem, and the results
% afforded by any denoising technology must be weighed against its cost.
%
% *Signal Processing Strategy*
%
% The purpose of the Filter Bank Signal Processing block is to decompose
% the input speech signal into eight overlapping subbands. More information
% is contained in the lower frequencies of speech signals than in the
% higher frequencies. To get as much resolution as possible where the most
% information is contained, the subbands are spaced such that the
% lower-frequency bands are more narrow than the higher-frequency bands. In
% this example, the four low-frequency bands are equally spaced, while each of
% the four remaining high-frequency bands is twice the bandwidth of its
% lower-frequency neighbor. To examine the frequency contents of the eight
% filter banks, run the model using the |Chirp| *Source type* in the Input
% Source block.
%
% Two filter bank implementations are illustrated in this example: a parallel,
% single-rate, second-order-section IIR filter bank and a cascaded,
% multirate, multistage FIR filter bank. Double click on the
% *Design Filter Banks* button to examine their design and frequency
% specifications.
%
% Parallel Single-Rate SOS IIR Filter Bank:
% In this bank, the sixth-order IIR filters are implemented as
% second-order-sections (SOS). Notice that the DSP System Toolbox(TM) scale
% function is used to obtain optimal scaling gains, which is particularly
% essential for the fixed-point version of this example. The eight filters are
% running in parallel at the input signal rate. You can look at their
% frequency responses by double clicking the *Plot IIR Filter Bank Response*
% button.
%
% Cascaded Multirate Multistage FIR Filter Bank:
% The design of this filter bank is based on the principles of an approach
% that combines downsampling and filtering at each filter stage. The
% overall filter response for each subband is obtained by cascading its
% components. Double click on the *Design Filter Banks* button to examine
% how design functions from the DSP System Toolbox are used in
% constructing these filter banks.
%
% Since downsamplisng is applied at each filter stage, the later stages are
% running at a fraction of the input signal rate. For example, the last
% filter stages are running an one-eighth of the input signal rate.
% Consequently, this design is very suitable for implementations on the
% low-power DSPs with limited processing cycles that are used in cochlear
% implant speech processors. You can look at the frequency responses for
% this filter bank by double clicking on the *Plot FIR Filter Bank Response*
% button. Notice that this design produces sharper and flatter subband
% definition compared to the parallel single-rate SOS IIR filter bank. This
% is another benefit of a multirate, multistage filter design approach. For
% a related example see "Multistage Design Of
% Decimators/Interpolators" in the DSP System Toolbox FIR Filter Design 
% examples.

%% Acknowledgements and References
% Thanks to Professor Philip Loizou for his help in creating this example.
%
% More information on Professor Loizou's cochlear implant research is
% available at:
%
% * Loizou, Philip C., "Mimicking the Human Ear," *IEEE(R) Signal Processing Magazine*, Vol. 15, No. 5, pp. 101-130, 1998.
%

%% Available Example Versions
% Floating-point version: <matlab:dspcochlear dspcochlear.mdl>
%
% Fixed-point version: <matlab:dspcochlear_fixpt dspcochlear_fixpt.mdl>
