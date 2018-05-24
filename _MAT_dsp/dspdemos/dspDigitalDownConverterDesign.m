%% Design and Analysis of a Digital Down Converter
% This example shows how to use the digital down converter (DDC) System
% object to emulate the TI Graychip 4016 digital down converter in a simple
% manner. We base the example on a comparison with the
% <dspDigitalDownConverter.html GSM Digital Down Converter> example. We
% show how the DDC System object can be used to design and analyze the
% decimation filters and to quickly explore different design options that
% meet various passband and stopband frequency and attenuation
% specifications. This example requires a Fixed-Point Designer(TM) license.

%   Copyright 2010-2012 The MathWorks, Inc.

%%
if ~isfixptinstalled
    error(message('dsp:dspDigitalDownConverterDesign:noFixptTbx'));
end

%% Introduction
% The <dspDigitalDownConverter.html GSM Digital Down Converter> example
% presents the steps required to emulate the TI Graychip 4016 digital down
% converter that brings a passband signal centered at 14.44 MHz to
% baseband, and down samples the signal by a factor of 256 to bring the
% input sample rate of 69.333 MHz down to 270.83 KHz. In that example you
% go through the following steps:
%
% 1) Design a numerically controlled oscillator to generate a mixer
%    frequency of 14.44 MHz. 
%
% 2) Load a pre-defined set of coefficients to generate a CIC decimator
%    filter, a CIC compensator filter, and an FIR filter with a passband 
%    frequency of 80 KHz.
%
% 3) Frequency down convert a GSM signal (simulated as a complex
%    exponential) and down sample the down converted output with the
%    cascade of decimation filters.
%
% 4) Perform data casting to obtain the desired fixed-point data types
%    across the different down converter sections.
%
% The <dspDigitalDownConverter.html GSM Digital Down Converter> example
% also creates an FIR rate converter to resample the data at the output of
% the third filter stage. The DDC System object does not contain a rate
% converter; therefore, this example does not include implementing one.
%
% This example shows how to use the DDC System object to design the set of
% decimation filters. It also shows how the DDC object achieves the down
% conversion process with fewer and simpler steps.
%
% The following DDC System object block diagram contains the data types at
% each stage and the data rates for the example at hand. You control the
% input data type of the filters using the FiltersInputDataType and
% CustomFiltersInputDataType properties. You control the output data type
% using the OutputDataType and CustomOutputDataType properties.
%
% <<ddcdesigndemomodel.png>>

%% Defining the DigitalDownConverter System Object
% Create a DDC System object. Set the input sample rate of the object to
% 69.333 mega samples per second (MSPS), and the decimation factor to 256
% to achieve an output sample rate of 270.83 KHz. The DDC object
% automatically factors the decimation value so that the CIC filter
% decimates by 64, the CIC compensator decimates by 2, and the third stage
% filter decimates by 2.

hDDC = dsp.DigitalDownConverter(...
  'SampleRate', 69.333e6,...
  'DecimationFactor',256);

%% Decimation Filter Design
%
% The <dspDigitalDownConverter.html GSM Digital Down Converter> example
% uses a predefined set of filter coefficients to generate two FIR
% decimators and a CIC decimator System object. Designing decimation
% filters so that their cascade response meets a given set of passband and
% stopband attenuation and frequency specifications can be a cumbersome
% process where you have to choose the correct combination of passband and
% stopband frequencies for each filter stage. Choosing stopband frequencies
% properly ensures lower order filter designs.
%
% The DDC object automatically designs the decimation filters based on a
% set of passband and stopband attenuation and frequency specifications.

%%
% *Minimum Order Filter Designs*
%
% The DUC object obtains minimum order decimation filter designs with the
% passband and stopband attenuation and frequency specifications you
% provide. Set the FilterSpecification property of the object to 'Design
% parameters'  and the MinimumOrderDesign property to true to obtain
% minimum order filter designs.

hDDC.FilterSpecification = 'Design parameters';
hDDC.MinimumOrderDesign = true;

%% 
% The down converter processes a GSM signal with a double-sided bandwidth
% of 160 KHz. Set the Bandwidth property of the DDC object to 160 KHz so
% that the passband frequency of the decimation filter cascade equals
% 160e3/2 = 80 KHz.
%
% Set the StopbandFrequencySource property to 'Auto' so that the DDC object
% sets the cutoff frequency of the cascade response approximately at the
% output Nyquist rate, i.e. at 270.83e3/2 = 135.4 KHz, and the stopband
% frequency at 2Fc-Fpass = 2*135.4e3 - 160e3/2 = 190.8 KHz, where Fc is the
% cutoff frequency and Fpass is the passband frequency. When you set
% StopbandFrequencySource to 'Auto', the DDC object relaxes the stopband
% frequency as much as possible to obtain the lowest filter orders at the
% cost of allowing some aliasing energy in the transition band of the
% cascade response. This design tradeoff is convenient when your priority
% is to minimize filter orders.

hDDC.Bandwidth = 160e3; % Passband frequency equal to 80 KHz
hDDC.StopbandFrequencySource = 'Auto'; % Allow aliasing in the transition band

%%
% Finally, set a stopband attenuation of 55 dB and a passband ripple of
% 0.04 dB.

hDDC.StopbandAttenuation = 55; 
hDDC.PassbandRipple = .04; 

%%
% You can analyze the response of the cascade of decimation filters by
% calling the fvtool method of the DDC object. Specify a fixed-point
% arithmetic so that the DDC object quantizes the filter coefficients to an
% optimum number of bits that allow the cascade response to meet the
% stopband attenuation specifications.
hfvt = fvtool(hDDC,'Arithmetic','Fixed-point');

%%
% Get the designed filter orders and the coefficient word lengths for the
% CIC compensator and third stage FIR design.
s = getFilters(hDDC,'Arithmetic','Fixed-point');
n= getFilterOrders(hDDC);

CICCompensatorOrder = n.SecondFilterOrder
ThirdStageFIROrder = n.ThirdFilterOrder
CICCompensatorCoefficientsWordLength = s.SecondFilterStage.CustomCoefficientsDataType.WordLength
ThirdStageFIRWordLength = s.ThirdFilterStage.CustomCoefficientsDataType.WordLength

%%
% If aliasing in the transition band is not acceptable, set the stopband
% frequency to an arbitrary value by setting the StopbandFrequencySource
% property to 'Property'. Obtain a narrower transition band by setting the
% stopband frequency to 128 KHz at the expense of a larger third stage
% filter order.

hDDC.StopbandFrequencySource = 'Property';
hDDC.StopbandFrequency = 128e3;

close(hfvt)
hfvt = fvtool(hDDC,'Arithmetic','fixed-point');

%%
n= getFilterOrders(hDDC);
CICCompensatorOrder = n.SecondFilterOrder
ThirdStageFIROrder = n.ThirdFilterOrder

%% 
% *Controlling the Filter Orders*
%
% There are cases when filter orders are the main design constraint. You
% use the DDC object to design decimation filters with a specified order by
% setting the MinimumOrderDesign property to false. You can still specify
% the required passband and stopband frequencies of the cascade response.
% Note however that the stopband attenuation and ripple are now controlled
% by the order of the filters and not by property values.

%% 
% *Specify Filter Coefficients*
%
% Set the FilterSpecification property to 'Coefficients' to use a
% predefined set of coefficients to design each interpolation filter stage
% of the DDC object. The object accepts any set of FIR filter coefficients
% for the first and second filter stages. The third stage is always a CIC
% decimator and you control its number of stages.
%
% Load the predefined set of coefficients used in the
% <dspDigitalDownConverter.html GSM Digital Down Converter> example.
% Calling the gsmcoeffs script places variables cfir and pfir in the
% workspace. cfir is a vector with coefficients that define a 20th order
% CIC compensator filter, pfir is a vector with the coefficients that
% define a 62th order FIR filter. The <dspDigitalDownConverter.html GSM
% Digital Down Converter> example uses a CIC decimator with 5 sections.
gsmcoeffs;

%%
% Set the DDC object so that it uses the loaded coefficients and a
% 5-section CIC decimator. In this scenario, you must specify the
% decimation factor as a three element vector containing the decimation
% value for each filter stage.

hDDC.FilterSpecification = 'Coefficients';
hDDC.DecimationFactor = [64 2 2];
hDDC.NumCICSections = 5;
hDDC.SecondFilterCoefficients = cfir;
hDDC.ThirdFilterCoefficients = pfir;

%%
% Set the second stage and third stage coefficients word length and
% fraction length to 16 bits.
hDDC.SecondFilterCoefficientsDataType = 'Custom';
hDDC.CustomSecondFilterCoefficientsDataType = numerictype([],16,16);
hDDC.ThirdFilterCoefficientsDataType = 'Custom';
hDDC.CustomThirdFilterCoefficientsDataType = numerictype([],16,16);

%%
% Visualize the response of each individual filter stage and of the overall
% cascade using the visualizeFilterStages method of the DDC object.
close(hfvt)
hfvt = visualizeFilterStages(hDDC,'Arithmetic','fixed-point');

%% Oscillator Design
% The DDC object designs a numerically controlled oscillator based on a
% small set of parameters. Set the Oscillator property to 'NCO' to chose a
% numerically controlled oscillator. Use 32 accumulator bits, and 18
% quantized accumulator bits. Set the center frequency to 14.44 MHz and
% chose 14 dither bits.
 
hDDC.Oscillator = 'NCO';
hDDC.CenterFrequency = 14.44e6;
hDDC.NumAccumulatorBits = 32;
hDDC.NumQuantizedAccumulatorBits = 18;
hDDC.NumDitherBits = 14;

%% Fixed-Point Settings
%
% You can set different properties on the DDC object to control the
% fixed-point data types along the down conversion path.
%
% Cast the word and fraction lengths at the input of each filter to 20 and
% 19 bits respectively by setting the CustomFiltersInputDataType property
% to numerictype([],20,19). Note that the DDC object scales the data at the
% output of the CIC decimator. The fact that this scaling is not done in
% the <dspDigitalDownConverter.html GSM Digital Down Converter> example
% explains the difference in the fraction length values chosen in each
% example.
%
% Set the output data type to have a word length of 24 bits and a fraction
% length of 23 bits.
hDDC.FiltersInputDataType = 'Custom';
hDDC.CustomFiltersInputDataType = numerictype([],20,19);
hDDC.OutputDataType = 'Custom';
hDDC.CustomOutputDataType = numerictype([],24,23);

%% Processing Loop
% Initialize a sine wave generator to simulate a GSM source. Initialize a
% buffer to cast the input signal data type to 19 bits word length and 18
% bits fraction length. Configure figures for plotting spectral estimates
% of signals.
Fs = 69.333e6; FrameSize = 768;
hsine = dsp.SineWave( ...
            'Frequency', 14.44e6+48e3, 'ComplexOutput', true, ...
            'SampleRate', Fs, 'Method', 'Trigonometric function', ...
            'PhaseOffset',0, 'SamplesPerFrame', FrameSize);
            
gsmsig = fi(zeros(FrameSize,1),true,19,18);   
s = figsDDCDesignDemo(Fs,256);
close(hfvt)

%%
% Main simulation loop
for ii = 1:200
    % Create GSM signal with 19 bits of word length and 18 bits of fraction
    % length.
    gsmsig(:) = real(step(hsine)); 
    
    % Down convert GSM signal
    downConvertedSig = step(hDDC,gsmsig); 
    
    % Frequency domain plots
    s = plotDDCDesignDemo(s, gsmsig, downConvertedSig);
end

%%
% Notice the simplification of steps required to down convert a signal when
% compared to the <dspDigitalDownConverter.html GSM Digital Down Converter>
% example.

%% Conclusion
% In this example, you compared the steps required to design a digital down
% converter as shown in the <dspDigitalDownConverter.html GSM Digital Down
% Converter> example with the steps required when using a DDC System
% object. The DDC object allows you to obtain down converter designs in one
% simple step. The DDC object allows you to use pre-defined decimation
% filter coefficients. It provides tools to design decimation filters that
% meet passband frequency, passband ripple, stopband frequency, and
% stopband attenuation specifications. The DDC object also provides
% convenient tools to visualize and analyze the decimation filter
% responses.

%% Further Exploration
%
% You can use the dsp.DigitalUpConverter System object to design a digital
% up converter system.

%% Appendix
% The following helper functions are used in this example.
%
% * <matlab:edit('figsDDCDesignDemo.m') figsDDCDesignDemo.m>
% * <matlab:edit('plotDDCDesignDemo.m') plotDDCDesignDemo.m>

displayEndOfDemoMessage(mfilename)
