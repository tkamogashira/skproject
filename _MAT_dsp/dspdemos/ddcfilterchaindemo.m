%% Implementing the Filter Chain of a Digital Down-Converter in HDL
% This example shows how to use the DSP System Toolbox(TM) and 
% Fixed-Point Designer(TM) to design a three-stage, multirate, fixed-point 
% filter that implements the filter chain of a Digital Down-Converter (DDC) 
% designed to meet the Global System for Mobile (GSM) specification.
%
% Using the Filter Design HDL Coder(TM) we will generate synthesizable HDL
% code for the same three-stage, multirate, fixed-point filter. Finally,
% using Simulink(R) and HDL Verifier(TM) MS, we will co-simulate the
% fixed-point filters to verify that the generated HDL code produces the
% same results as the equivalent Simulink behavioral model.

% Copyright 1999-2012 The MathWorks, Inc.

%% Digital Down-Converter
% Digital Down-Converters (DDC) are a key component of digital radios.  The
% DDC performs the frequency translation necessary to convert the high
% input sample rates found in a digital radio, down to lower sample rates
% for further and easier processing.  In this example, the DDC operates at
% approximately 70 MHz and must reduce the rate down to 270 KHz.
%
% To further constrain our problem we will model one of the DDCs in
% Graychip's GC4016 Multi-Standard Quad DDC Chip.  The GC4016, among other
% features, provides the following filters: a five-stage CIC filter with
% programmable decimation factor (8-4096); a 21-tap FIR filter which
% decimates by 2 and has programmable 16-bit coefficients; and a 63-tap FIR
% filter which also decimates by 2 and has programmable 16-bit
% coefficients.
%
% The DDC consists of a Numeric Controlled Oscillator (NCO) and a mixer to
% quadrature down convert the input signal to baseband.  The baseband
% signal is then low pass filtered by a Cascaded Integrator-Comb (CIC)
% filter followed by two FIR decimating filters to achieve a low
% sample-rate of about 270 KHz ready for further processing.  The final
% stage often includes a resampler which interpolates or decimates the
% signal to achieve the desired sample rate depending on the application.
% Further filtering can also be achieved with the resampler.  A block
% diagram of a typical DDC is shown below.
%
% <<ddcdemomodel1.png>>

%%
% This example focuses on the three-stage, multirate, decimation filter,
% which consists of the CIC and the two decimating FIR filters.

%% GSM Specifications
% The GSM bandwidth of interest is 160 KHz. Therefore, the DDC's
% three-stage, multirate filter response must be flat over this bandwidth
% to within the passband ripple, which must be less than 0.1 dB peak to
% peak. Looking at the GSM out of band rejection mask shown below,
% we see that the filter must also achieve 18 dB of attenuation at 100 KHz.
%
% <<ddcdemogsmmask.png>>

%%
% In addition, GSM requires a symbol rate of 270.833 Ksps.  Since the
% Graychip's input sample rate is the same as its clock rate of 69.333 MHz,
% we must downsample the input down to 270.833 KHz.  This requires that the
% three-stage, multirate filter decimate by 256.

%% Cascaded Integrator-Comb (CIC) Filter
% CIC filters are multirate filters that are very useful because they can
% achieve high decimation (or interpolation) rates and are implemented
% without multipliers.  CICs are simply boxcar filters implemented
% recursively cascaded with an upsampler or downsampler.  These
% characteristic make CICs very useful for digital systems operating at
% high rates, especially when these systems are to be implemented in ASICs
% or FPGAs.
%
% Although CICs have desirable characteristics they also have some
% drawbacks, most notably the fact that they incur attenuation in the
% passband region due to their sinc-like response.  For that reason CICs
% often have to be followed by a compensating filter.  The compensating
% filter must have an inverse-sinc response in the passband region to lift
% the droop caused by the CIC.

%%
% The design and cascade of the three filters can be performed via the
% graphical user interface FDATool,
%
% <<ddcdemofdatool.png>>
%
% but we'll use the command line functionality.
%
% To avoid quantizing the fixed-point data coming from the mixer, which has
% a word length of 20 bits and a fraction length of 18 bits, (S20,18),
% we'll set the input word length and fraction length of the CIC to the
% same values, S20,18. We must also define the word lengths per section of
% the CIC.  These values are chosen to avoid overflow between sections. We
% define the CIC as follows:

R    = 64; % Decimation factor
D    = 1;  % Differential delay
Nsecs= 5;  % Number of sections
IWL  = 20; % Input word length
IFL  = 18; % Input fraction length
OWL  = 20; % Output word length

% If the output wordlength is specified when creating a CIC filter then the
% "FilterInternals" property is set to "MinWordLengths" automatically.
% Therefore, the minimum word sizes are used between each section.
hcic = mfilt.cicdecim(R,D,Nsecs,IWL,OWL);
hcic.InputFracLength = IFL; 

%%
% We can view the CIC's details by invoking the info method.
info(hcic)

%%
% Let's plot and analyze the theoretical magnitude response of the CIC
% filter which will operate at the input rate of 69.333 MHz.
Fs_in = 69.333e6; 
h = fvtool(hcic,'Fs',Fs_in);
set(gcf, 'Color', 'White'); 

%%
% The first thing to note is that the CIC filter has a huge passband gain,
% which is due to the additions and feedback within the structure. We can
% normalize the CIC's magnitude response by cascading the CIC with a gain
% that is the inverse of the gain of the CIC.  Normalizing the CIC filter
% response to have 0 dB gain at DC will make it easier to analyze the
% overlaid filter response of the next stage filter. Note that we will use
% the CIC before normalization for code generation.

hgain = dfilt.scalar(1/gain(hcic)); % Define gain
hcicnorm = cascade(hgain,hcic);

% Replace the CIC in FVTool with a normalized CIC.
setfilter(h,hcicnorm,'Fs',Fs_in);

%%
% The other thing to note is that zooming in the passband region we see
% that the CIC has about -0.4 dB of attenuation (droop) at 80 KHz, which is
% within the bandwidth of interest. A CIC filter is essentially a cascade
% of boxcar filters and therefore has a sinc-like response which causes the
% droop. This droop needs to be compensated by the FIR filter in the next
% stage.
axis([0 .1 -0.8 0]);

%% Compensation FIR Decimator
% The second stage of our DDC filter chain needs to compensate for the
% passband droop caused by the CIC and decimate by 2.  Since the CIC has a
% sinc-like response, we can compensate for the droop with a lowpass filter
% that has an inverse-sinc response in the passband.  This filter will
% operate at 1/64th the input sample rate which is 69.333 MHz, therefore
% its rate is 1.0833MHz.  Instead of designing a lowpass filter with an
% inverse-sinc passband response from scratch, we'll use a canned function
% which lets us design a decimator with a CIC Compensation (inverse-sinc)
% response directly.

% Filter specifications
Fs     = 1.0833e6; % Sampling frequency 69.333MHz/64
Apass  = 0.01;     % dB
Astop  = 60;       % dB
Aslope = 60;       % 60 dB slope over half the Nyquist range
Fpass  = 80e3;     % Hz passband-edge frequency
Fstop  = 293e3;    % Hz stopband-edge frequency

% Design decimation filter. D and Nsecs have been defined above as the
% differential delay and number of sections, respectively.
d = fdesign.decimator(2,'ciccomp',D,Nsecs,Fpass,Fstop,Apass,Astop,Fs);
hcfir = design(d,'equiripple',...
               'StopbandShape', 'linear',...
               'StopbandDecay', Aslope);

% Now we have to define the fixed-point attributes of our multirate filter.
% By default, the fixed-point attributes of the accumulator and multipliers
% are set to ensure that full precision arithmetic is used, i.e. no
% quantization takes place.
set(hcfir,...
    'Arithmetic',      'fixed',...
    'CoeffWordLength',  16,...
    'InputWordLength',  20,...               
    'InputFracLength', -12);

%%
% Using the info command we can get a comprehensive report of the FIR
% compensation filter, including the word lengths of the accumulator and
% product, which are automatically determined.
info(hcfir)

%% 
% Cascading the CIC with the inverse sinc filter we can see if we
% eliminated the passband droop caused by the CIC.

hcas1 = cascade(hcicnorm,hcfir);
set(h,'Filters', [hcicnorm,hcfir,hcas1],'Fs',[Fs_in,Fs_in/64,Fs_in]);
axis([0 .1 -0.8 0.8]);
legend(h,'hcic','hcfir','cascade');

%%
% As we can see in the filter response of the cascade of the two filters,
% which is between the CIC response and the compensating FIR response, the
% passband droop has been eliminated.

%% Third Stage FIR Decimator
% As indicated earlier the GSM spectral mask requires an attenuation of 18
% dB at 100 KHz. So, for our third and final stage we can try a simple
% equiripple lowpass filter. Once again we need to quantize the
% coefficients to 16 bits. This filter also needs to decimate by 2.

N = 62;       % 63 taps
Fs = 541666;  % 541.666 kHz
Fpass = 80e3;
Fstop = 100e3;

d = fdesign.decimator(2,'lowpass','N,Fp,Fst',N,Fpass,Fstop,Fs);
hpfir = design(d,'equiripple','Wpass',2);  % Give more weight to passband
set(hpfir,...
    'Arithmetic',      'fixed',...
    'CoeffWordLength',  16,...
    'InputWordLength',  20,...               
    'InputFracLength', -12);
%%
% When defining a multirate filter by default the accumulator word size
% is determined automatically to maintain full precision. However, because
% we only have 20 bits for the output let's set the output format to a
% word length of 20 bits and a fraction length of -12.  First, we must
% change the FilterInternals property's default value from 'FullPrecision'
% to 'SpecifyPrecision'.
set(hpfir,...
    'FilterInternals', 'specifyPrecision',...
    'outputWordLength', 20,...
    'outputFracLength',-12,...
    'RoundMode',       'nearest',... 
    'OverflowMode',    'Saturate');

%%
% We can use the info method to view the filter details.
info(hpfir)

%% Multistage Multirate DDC Filter Chain
% Now that we have designed and quantized the three filters, we can get the
% overall filter response by cascading the normalized CIC and the two FIR
% filters.  Again, we're using the normalized CIC filter to ensure that the
% cascaded filter response is normalized to 0 dB.

hcasnorm = cascade(hcicnorm,hcfir,hpfir);
set(h,'Filters',hcasnorm,'Fs',Fs_in,'NumberofPoints',8192*3);
axis([0 1 -200 10]);  % Zoom-in

%%
% To see if the overall filter response meets the GSM specifications, we
% can overlay the GSM spectral mask on the filter response.
drawgsmmask; 

%%
% We can see that our overall filter response is within the constraints of
% the GSM spectral mask.  We also need to ensure that the passband ripple
% meets the requirement that it is less than 0.1 dB peak-to-peak. We can
% verify this by zooming in using the axis command.
axis([0 .09 -0.08 0.08]);

%%
% Indeed the passband ripple is well below the 0.1 dB peak-to-peak GSM
% requirement.

%% Generate VHDL Code
% FDATool also supports the generation of HDL code from the dialog shown
% below.
%
% <<ddcdemohdldialog.png>>
%
% From FDATool as well as the command line you can generate VHDL or Verilog
% code as well as test benches in VHDL or Verilog files.
% Also, you have the ability to customize your generated HDL code by
% specifying many options to meet your coding standards and guidelines.
%
% However, here we will use the command line functionality to generate the
% HDL code.
%
% Now that we have our fixed-point, three-stage, multirate filter meeting
% the specs we are ready to generate HDL code.  

%%
% Cascade of CIC and two FIR filters and generate VHDL.  Note that we're
% not using the normalized CIC for code generation. The normalized CIC was
% used for visualization purposes only.

hcas = cascade(hcic,hcfir,hpfir);
workingdir = tempname;
generatehdl(hcas,'Name','filter','TargetLanguage','VHDL',...
    'TargetDirectory',fullfile(workingdir,'hdlsrc'));

%% HDL Co-simulation with ModelSim(R) in Simulink(R)
% To verify that the generated HDL code is producing the same results as
% our Simulink(R) model, we'll use HDL Verifier(TM) MS to co-simulate
% our HDL code in Simulink.  We have a pre-built Simulink model that
% includes two signal paths.  One signal path produces Simulink's
% behavioral model results of the three-stage, multirate filter.  The other
% path produces the results of simulating, with ModelSim, the VHDL code we
% generated.
open_system('ddcfilterchaindemo_cosim.mdl');

%%
% For the behavioral model simulation we will generate a Simulink block of
% the three-stage, multirate filter we designed and place that block in the
% Simulink model where we'll co-simulate with ModelSim.

% Generate Simulink block of cascaded filters.  Change the compensating
% filter's default rounding mode to nearest.
set(hcfir,'FilterInternals','SpecifyPrecision','RoundMode','nearest');
block(hcas,'OverwriteBlock','on','RateOption','allowmultirate');
open_system('ddcfilterchaindemo_cosim.mdl');

% Start ModelSim. Uncomment the following lines of code to compile and load
% the HDL code in ModelSim.  Note that ModelSim must be installed and on
% the system path.
%
% cachepwd = pwd;
% cd(workingdir) % Go to directory where code was generated.
% vsim('tclstart',ddcdemolinkcmds,'socketsimulink',4449);

%%
% Note that the warnings generated are due to the fact that the input
% quantization settings are set explicitly in the filter objects, but are
% inherited in Simulink's filter block.

% Run Simulink simulation and open the Scope to view results.  Uncomment
% the following lines to run the simulation.  Note that you must first
% uncomment the code above that starts ModelSim.
%
% pause(5);
% sim('ddcfilterchaindemo_cosim');
% open_system('ddcfilterchaindemo_cosim/Verification_Results/Time Scope');
% cd(cachepwd)

%%
% The warnings generated when running the code are due to the fact that the
% coefficients are stored as doubles when specified in the filter block,
% and therefore will be quantized to the word length and fraction length
% specified in the filter object.

%%
% The scope below displays the results of running the simulation.
%
% <<ddcdemoscope.png>>

%% Verifying Results
% The trace on the top is the excitation chirp signal.  The next signal
% labeled "ref" is the reference signal produced by the Simulink behavioral
% model of the three-stage multirate filter.  The bottom trace labeled
% "cosim" on the scope is of the ModelSim simulation results of the
% generated HDL code of the three-stage multirate filter.  The last trace
% shows the error between Simulink's behavioral model results and
% ModelSim's simulation of the HDL code.

%% Summary
% We used several MathWorks(TM) products to design and analyze a
% three-stage, multirate, fixed-point filter chain of a DDC for a GSM
% application. Then we generated HDL code to implement the filter and
% verified the generated code by comparing Simulink's behavioral model with
% HDL code simulated in ModelSim via HDL Verifier(TM) MS.


displayEndOfDemoMessage(mfilename)
