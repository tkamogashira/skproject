%% Floating-Point to Fixed-Point Conversion of IIR Filters
% This example shows how to convert an IIR filter from a floating-point to
% a fixed-point implementation. Second-order sections (also referred as
% biquadratic) structures work better when using fixed-point arithmetic
% than structures that implement the transfer function directly. We will
% show that the surest path to a successful "float-to-fixed" conversion
% consists of 2 steps:
%
% * Select a Second-Order Structure
% * Perform Dynamic Range Analysis for Each Node of the Filter

% Copyright 2006-2013 The MathWorks, Inc.

%% Design a Lowpass Chebyshev Type I Filter 
% We will use a minimum-order lowpass Chebyshev Type I design for the
% purpose of the example. The design specifications of the filter are: 
% 
% * Passband frequency edge: 0.4*pi 
% * Stopband frequency edge: 0.45*pi 
% *         Passband ripple: 0.5 dB 
% *    Stopband attenuation: 80 dB
%
f = fdesign.lowpass('Fp,Fst,Ap,Ast',0.4,0.45,0.5,80);
Hdf1sos = design(f, 'cheby1', 'FilterStructure', 'df1sos');

%% Step 1: Select a Second-Order Structure
% We will illustrate why converting to transfer function is a bad idea when
% fixed-point arithmetic will be used (and even when floating-point is to
% be used). First we create the filter.
[b,a] = tf(Hdf1sos);
Hdf1 = dfilt.df1(b,a);
%%
% Now we set arithmetic to fixed. We use 16 bits to represent the
% coefficients and autoscale the fraction length. Note how the frequency
% response of the filter with quantized coefficients is nowhere near the
% reference double-precision filter's frequency response. 
Hdf1.Arithmetic = 'fixed';
hfvt = fvtool(Hdf1,'legend','on');
legend(hfvt,'Direct-Form I')
%%
% So converting to transfer function is not advisable. Instead, if we
% quantize the second-order sections (SOS) we notice that the frequency
% response of the quantized and reference filters are indistinguishable
% unless we zoom in quite a bit.
Hdf1sos.Arithmetic = 'fixed';
setfilter(hfvt,Hdf1sos);
axis([0 1 -120 5])
legend(hfvt,'Direct-Form I SOS', 'Location','NorthEast')
%% 
% Obtaining a good frequency response for the quantized filter as we have
% done here is a necessary step but, alone, not sufficient in order to
% filter data adequately. We will use some random data in the [-1, 1) range
% to filter and compare against. 
rng(5,'twister');
q = quantizer([10,9],'RoundMode','round'); 
xq = randquant(q,1000,1); 
x = fi(xq,true,10,9);
%%
% Furthermore assume that the hardware we target has an accumulator with no
% guard bits:
Hdf1sos.AccumWordLength = Hdf1sos.ProductWordLength;
%%
% Next, we turn on the logging of min/max and overflows and filter the test
% data we created. The filtering is done using the quantized coefficients,
% but the operations are performed with double-precision, floating-point
% arithmetic. The allowable ranges for the fixed-point settings are
% retained so that we can observe how many values are out of range.
fipref('LoggingMode', 'on', 'DataTypeOverride', 'ScaledDoubles');
y = filter(Hdf1sos,x);
fipref('LoggingMode', 'off', 'DataTypeOverride', 'ForceOff');
R = qreport(Hdf1sos)
%%
% Notice the large quantity of overflow values in every stage of the
% filtering operation. A measure toward reducing the overflow problem is to
% scale the second-order section filters using one of the available scaling
% criteria. The filtering operation will be least prone to overflow if we
% chose the most stringent scaling, 'l1', however, this stringent
% normalization will also cause the worst signal-to-noise ratio (SNR).
% Linf-scaling is the most commonly used scaling in practice since it
% offers a good compromise between overflow prevention, and SNR. For this
% reason we will use it for the example at hand. 
%%
% So let us set the second-order section scaling norm to 'Linf'. This can
% be done by either calling the scale method for Hdf1sos
scale(Hdf1sos,'Linf');
%%
% or by calling the design method with the appropriate parameters 
Hdf1sos = design(f, 'cheby1', 'FilterStructure', 'df1sos', ...
    'SOSScaleNorm','Linf');
%%
% Now that we have set the second-order section scaling to 'Linf' we may
% repeat the overflow analysis:
Hdf1sos.Arithmetic = 'fixed';
Hdf1sos.AccumWordLength = Hdf1sos.ProductWordLength;
fipref('LoggingMode', 'on', 'DataTypeOverride', 'ScaledDoubles');
y = filter(Hdf1sos,x);
fipref('LoggingMode', 'off', 'DataTypeOverride', 'ForceOff');
R = qreport(Hdf1sos)

%%
% The report clearly indicates a considerable reduction in the number of
% overflow cases. Actually, out-of-range values only occur at the
% denominator states. Even though they have been considerably reduced by
% the second-order section scaling, these potential overflows could still
% create problems in the filtering operation. Note that although the use
% of 'Linf' norm did not completely avoid overflows (the reason being that
% the filter has nonlinear phase frequency components that can still add up
% to a point that causes overflow), it greatly reduced their occurrence. As
% mentioned earlier, to completely remove overflows, a more stringent 'l1'
% scaling is necessary - but such scaling may considerably reduce the SNR
% and is typically avoided. A better way to completely remove overflow
% cases is described in Step 2. 

%%
% To summarize, Step 1 consists of selecting an appropriate second-order
% section filter structure, and scaling criteria. 

%% Step 2: Perform Dynamic Range Analysis
% The second step towards a fixed point conversion of IIR filters consists
% of applying dynamic range analysis to the filter to fine-tune the scaling
% for each node. The maxima and minima obtained from a floating-point
% simulation are used to set fraction lengths such that the simulation
% range is covered and the precision is maximized. Word lengths are not
% changed. 
Hdf1sosf = autoscale(Hdf1sos,x);
%%
% We can verify that the settings are correct by running the filter in
% fixed-point:
fipref('LoggingMode', 'on', 'DataTypeOverride', 'ForceOff');
y = filter(Hdf1sosf,x);
fipref('LoggingMode', 'off');
R = qreport(Hdf1sosf)
%%
% All overflows are now removed for this input signal. Furthermore, a close
% look at the fixed-point report suggests that the two most significant
% bits are not used for the denominator product and accumulator.
%%
% The magnitude response estimate, along with the power spectral density of
% filter output due to roundoff noise, further confirm that the fixed-point
% filter gives results very close to the double precision floating-point 
% reference.
close(hfvt);
fvtool(Hdf1sosf,'Analysis','magestimate');
fvtool(Hdf1sosf,'Analysis','noisepower');

%% Summary
% We have outlined a simple two-step procedure to convert a floating-point
% IIR filter to a fixed-point implementation. The filter objects of the
% DSP System Toolbox(TM) are equipped with an 'autoscale' function that
% automatically and dynamically scale internal signals. In addition,
% functions such as 'qreport' and various analyses of 'fvtool' give tools
% to the user to perform verifications at each step of the process.


displayEndOfDemoMessage(mfilename)
