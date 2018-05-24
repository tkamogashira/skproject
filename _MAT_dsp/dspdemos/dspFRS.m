%% Digital Up and Down Conversion for Family Radio Service 
% This example shows how to use the digital up converter (DUC) and digital
% down converter (DDC) System objects to design a Family Radio Service
% (FRS) transmitter and receiver. These objects provide tools to design
% interpolation/decimation filters and simplify the steps required to
% implement the up/down conversion process.
%
% FRS is an improved walkie talkie FM radio system authorized in the United
% States since 1996. This personal radio service uses channelized
% frequencies in the ultra high frequency (UHF) band. Devices operating in
% the FRS band must be authorized under Part 95 Subpart B "Family Radio
% Service" (Sections 95.191 through 95.194) of the FCC rules. The
% authorized bandwidth of FRS channels is 12.5 KHz and the center frequency
% separation between channels is 25 KHz.

% Copyright 2010-2012 The MathWorks, Inc.

%% Introduction
% This example discusses the digital up conversion of a signal to be
% transmitted through an FRS channel, and the down conversion of the signal
% coming from the FRS radio transmitter.
%
% The DUC at the transmitter up samples the signal from 50 KHz to 2 MHz and
% up converts the signal to an IF frequency of 455 KHz.
%
% The receiver has an analog front end that brings the received signal to
% an IF frequency of 455 KHz. The signal is then sampled at a rate of 2
% MHz. The DDC at the receiver brings the signal back to baseband with a
% sample rate of 50 KHz.

%% Digital Up Converter Design
% You design a digital up converter by creating a DUC System object. The
% DUC object consists of a cascade of three interpolation filters and an
% oscillator that up converts the interpolated signal to a specified
% passband frequency. A block diagram of the DUC object is shown next.
%
% <<ducfrsdemo.png>>

%%
% The DUC object provides options to define the interpolation filters. For
% instance, you can directly specify the filter coefficients for each
% interpolation stage, or let the object design the filters for you based
% on a set of specifications. The object also offers two ways to design the
% oscillator. You can design the oscillator using either a sine wave
% generator or a numerically controlled oscillator. The following section
% showcases the different options available to design the interpolation
% filters for the FRS transmitter.

%%
% *Designing Interpolation Filters*
%
% The DUC object implements the interpolation filter using three filter
% stages. When the DUC object designs the filters internally, the first
% stage consists of a halfband, or a lowpass filter, the second stage
% consists of a CIC compensator, and the third stage consists of a CIC
% interpolation filter. The DUC object allows you to specify several
% characteristics that define the response of the cascade for the three
% filters, including passband and stopband frequencies, passband ripple,
% and stopband attenuation.

%%
% *Minimum Order Filter Designs*
%
% By default (when the MinimumOrderDesign property is set to true) the DUC
% object obtains minimum order interpolation filter designs using the
% passband and stopband specifications you provide.
%
% For this FRS example, you must up sample the transmitted signal from 50
% KHz to 2 MHz. This yields an interpolation factor of 40. The DUC object
% automatically factors the interpolation value so that the first filter
% stage interpolates by 2, the second filter stage interpolates by 2, and
% the CIC filter interpolates by 10.
%
% The FRS channel double sided bandwidth is 12.5 KHz. Set the Bandwidth
% property of the DUC object to 12.5 KHz so that the passband frequency of
% the cascade response of the interpolation filters is 12.5e3/2 = 6.25 KHz.
% 
% Set the passband ripple to a small value of 0.05 dB to avoid distortion
% of the FRS signal. Set the stopband attenuation to 60 dB.
% 
% By default (when the StopbandFrequencySource property is set to 'Auto')
% the DUC object sets the cutoff frequency of the cascade response
% approximately at the input Nyquist rate of 25 KHz. The object also sets
% the stopband frequency at 2Fc-Fpass = 2*25e3 - 12.5e3/2 = 43.75 KHz,
% where Fc is the cutoff frequency and Fpass is the passband frequency. In
% this scenario, the DUC object relaxes the stopband frequency as much as
% possible, obtaining the lowest filter orders at the cost of allowing some
% energy of interpolation replicas in the transition band of the cascade
% response. This design tradeoff is convenient when your priority is to
% minimize filter orders.

hDUC = dsp.DigitalUpConverter(...
  'SampleRate', 50e3,...
  'InterpolationFactor',40,...
  'Bandwidth',12.5e3,...
  'PassbandRipple',0.05,...
  'StopbandAttenuation',60);

%%
% Visualize the cascade response of the decimation filters using the fvtool
% or visualizeFilterStages methods of the DUC object. Specify the
% arithmetic as 'Double' so that the filter coefficients and operations are
% double-precision.

hfvt = fvtool(hDUC,'Arithmetic','double');
%%

close(hfvt)
hfvt = visualizeFilterStages(hDUC,'Arithmetic','double');

%%
% Get the orders of the designed filters using the getFilterOrders method.

s = getFilterOrders(hDUC);
s.FirstFilterOrder
%%
s.SecondFilterOrder

%%
% The FRS channel separation is 25 KHz. Most commercial FRS radios offer 50
% dB or higher adjacent channel rejection (ACR). Clearly, the cascade
% response of the decimation filters designed above does not achieve a 50
% dB attenuation at 25 KHz. One possible solution to this problem is to
% filter the baseband FRS signal with a lowpass filter with the required
% transition width and stopband attenuation before passing the signal
% through the DUC object. Another solution is to set the DUC object so that
% it designs a cascade response with a narrower transition bandwidth that
% meets the required spectral mask. To design an overall filter response
% with a narrower transition bandwidth, set the StopbandFrequencySource
% property to 'Property' and the StopbandFrequency property to a desired
% value.

%% 
% Design the filters so that the cascade response has a stopband frequency
% at the edge of the passband of the adjacent FRS channel, i.e. at
% 25e3-12.5e3/2 = 18.75 KHz. Set the StopbandAttenuation property to 60 dB
% to achieve a 60 dB ACR.

hDUC.StopbandFrequencySource = 'Property';
hDUC.StopbandFrequency = 18.75e3;
hDUC.StopbandAttenuation = 60;
close(hfvt)
hfvt = fvtool(hDUC,'Arithmetic','double');

%%
% Get the filter orders

s = getFilterOrders(hDUC);
s.FirstFilterOrder
%%
s.SecondFilterOrder

%%
% The new cascade response achieves 60 dB attenuation at 25 KHz, i.e., at
% the center of the adjacent FRS channel. The order of the first stage
% filter (lowpass interpolator) increases from 10 to 23. Note however that
% the order of the second stage filter (CIC compensator) decreases from 10
% to 7. Because the first stage response has a narrower bandwidth, the
% second stage stopband can be relaxed even more to the edge of the left
% stopband of the first replica of the first stage filter. Since the second
% filter stage operates at a higher rate, this is a very convenient order
% reduction.

%%
% *Controlling the Filter Orders*
%
% There are cases when filter orders are the main design constraint. Set
% the MinimumOrderDesign property to false to design interpolation filters
% with a specific order. In this configuration, you can still specify the
% required passband and stopband frequencies. The orders of the filters
% control the stopband attenuation and ripple of the cascade response.
%
% To meet a constraint of a maximum of 20 coefficients in the first filter
% stage, set the FirstFilterOrder property to 20. Set the SecondFilterOrder
% property to 7, and the number of CIC sections to 4.

% Keep a copy of the minimum order design so that we can use it later on
% this example.
hDUCMinOrder = clone(hDUC);

% Specify the filter orders and visualize the cascade response.
hDUC.MinimumOrderDesign = false;
hDUC.FirstFilterOrder = 20;
hDUC.SecondFilterOrder = 7;
hDUC.NumCICSections = 4;

close(hfvt)
hfvt = fvtool(hDUC,'Arithmetic','double');

%%
% The new design has lower stopband attenuation and larger passband ripple
% due to the reduced first filter order. 

%%
% *Specify Filter Coefficients*
%
% Set the FilterSpecification property to 'Coefficients' to use a
% predefined set of coefficients to design each interpolation filter stage
% of the DUC object. The object accepts any set of FIR filter coefficients
% for the first and second filter stages. The third stage is always a CIC
% interpolator and you control its number of stages.

%%
% *Oscillator Design*
%
% Use the Oscillator property to select the type of oscillator the object
% uses to perform the frequency up conversion. Set the property to 'Sine
% wave' to obtain an oscillator signal from a sinusoidal computed using
% samples of the trigonometric function. Alternatively, set the property to
% 'NCO' so the object designs a numerically controlled oscillator. Set the
% center frequency of the oscillator to the IF frequency of 455 KHz.

hDUC.Oscillator = 'Sine wave';
hDUC.CenterFrequency = 455e3;

%% Digital Down Converter Design
% You design a digital down converter (DDC) by creating a DDC System
% object. The DDC System object consists of an oscillator that down
% converts an input signal from a specific passband frequency to 0 Hz. The
% object down samples the down converted signal using a cascade of three
% decimation filters. The following block diagram shows the DDC object.
%
% <<ddcfrsdemo.png>>

%%
% As in the DUC case, the DDC object offers different options for defining
% decimation filters. For instance, you can directly specify the filter
% coefficients for each decimation stage, or you can let the object design
% the filters for you based on a set of specifications. The object offers
% two ways to design the oscillator. You can design the oscillator using
% either a sine wave generator or a numerically controlled oscillator.
% Alternatively, you can provide an oscillator signal as an input to the
% step method.

%%
% *Designing Decimation Filters*
%
% The DDC object implements decimation using three filter stages. When the
% object designs the filters internally, the first stage consists of a CIC
% decimator, the second stage consists of a CIC compensator, and the third
% stage consists of a halfband, or a lowpass, decimation filter. As in the
% DUC case, the DDC object allows you to specify characteristics that
% define the response of the cascade of the three filters, including
% passband and stopband frequencies, passband ripple, and stopband
% attenuation.

%% 
% Design minimum order decimation filters to receive an FRS signal centered
% at an IF frequency of 455 KHz. Decimate the signal by 40 to downsample it
% from 2 MHz to 50 KHz. Set the StopbandFrequencySource property to
% 'Property' and the stopband attenuation to 60 dB to design a cascade
% response that achieves an ACR of 60 dB.

hDDCMinOrder = dsp.DigitalDownConverter(...
  'SampleRate', 2e6,...
  'DecimationFactor',40,...
  'Bandwidth',12.5e3,...
  'PassbandRipple',0.05,...
  'StopbandAttenuation',60,...
  'StopbandFrequencySource', 'Property',...
  'StopbandFrequency',18.75e3,...
  'CenterFrequency',455e3);

%%
% Analyze the responses of the decimator filters and verify that the
% cascade response achieves an attenuation of 60 dB at 25 KHz. Note how the
% DDC relaxes the response of the second stage (CIC compensator) to the
% edge of the left stopband of the first alias of the third stage (lowpass
% decimator) to minimize order.
close(hfvt)
hfvt = visualizeFilterStages(hDDCMinOrder,'Arithmetic','double');

%%
% Similar to the DUC case, you can define the filter orders by setting the
% MinimumOrderDesign property to false, and you can specify the filter
% coefficients by setting the FilterSpecification property to
% 'Coefficients'.

%% Main Processing Loop
% Generate a baseband FM signal. The FCC Part 95 specifies an FM modulation
% with maximum frequency deviation of 2.5 KHz and a maximum audio frequency
% of 3.125 KHz. Simulate the audio signal by filtering white noise with a
% lowpass filter with passband frequency equal to 3.125 KHz.
% Frequency-modulate the simulated audio signal to obtain the FRS baseband
% signal (the signal does not include a squelch tone). Up convert and down
% convert the baseband FRS signal using the DUC and DDC objects that were
% designed in the previous sections using minimum order filters.

% Initialize simulation parameters
Fs = 50e3;
maxAudioFrequency = 3.125e3; % Maximum allowed audio frequency for FRS radios
deltaF = 2.5e3; % Maximum allowed frequency deviation for FRS radios

hLP = fdesign.lowpass('Fp,Fst,Ap,Ast', maxAudioFrequency,5e3,0.1,30,Fs);
HLP = design(hLP);
HLP.PersistentMemory = true;
frameLength = 1000;
numIters = 5;
xBaseBand = zeros(frameLength*numIters,1);
xDown = zeros(frameLength*numIters,1);
hDUCMinOrder.CenterFrequency = 455e3;

%%
% Stream data 
integralState = 0;
for idx = 1:numIters
  % Input signal
  [xFMBaseBand,integralState] = generateFMSignalFRSDemo(HLP,frameLength,deltaF,Fs,integralState);
  xFMBaseBandBuffer((idx-1)*frameLength+1:idx*frameLength,1) = xFMBaseBand;
  
  % Up conversion  
  xUp = step(hDUCMinOrder,xFMBaseBand);

  % Down conversion
  xDown((idx-1)*frameLength+1:idx*frameLength,1) = step(hDDCMinOrder,xUp);
end
  
%%
% Plot the spectrum of the baseband, up converted, and down converted
% signals.
close(hfvt)
spectrumPlotsFRSDemo(xFMBaseBandBuffer,xUp,xDown,hDUCMinOrder.InterpolationFactor)

%% Conclusions
% In this example you designed a digital up and down converter for an FRS
% transmitter and receiver using DUC/DDC System objects. The example has
% explored the different options offered by the DUC/DDC objects to design
% interpolation and decimation filters. The example has also explored the
% filter analysis tools available in the DDC/DUC objects such as the
% visualizeFilterStages, fvtool, and getFilterOrders methods.
%
% The DUC/DDC objects designed in this example operate with
% double-precision filter coefficients and double-precision arithmetic. See
% the <dspDigitalDownConverterDesign.html Design and Analysis of a Digital
% Down Converter> example if you are interested in designing a DUC or DDC
% that operates with fixed-point inputs.

%% Appendix
% The following helper functions are used in this example.
%
% * <matlab:edit('spectrumPlotsFRSDemo.m') spectrumPlotsFRSDemo.m>
% * <matlab:edit('generateFMSignalFRSDemo.m') generateFMSignalFRSDemo.m>

displayEndOfDemoMessage(mfilename)
