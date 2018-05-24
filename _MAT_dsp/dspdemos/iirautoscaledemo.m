%% Fixed-Point Scaling of an Elliptic IIR Filter
% This example shows how to autoscale fixed-point filter objects. The
% autoscale method provides dynamic range scaling for each node of the
% filter. This method runs the filter in floating-point and uses the
% maximum and minimum data obtained from that simulation to set fraction
% lengths so that the simulation range is covered and the precision is
% maximized. Word lengths do not change.

% Copyright 2006-2012 The MathWorks, Inc.

%% Designing the Filter 
% We are using a minimum-order elliptic design. Elliptic designs have the
% characteristic of being relatively well scaled when using the 'Linf'
% second-order section scaling norm. 

f = fdesign.lowpass('Fp,Fst,Ap,Ast',.48,.52,1,60);
Hd = design(f, 'ellip', 'FilterStructure', 'df1sos', ...
    'SOSScaleNorm', 'Linf');
hfvt = fvtool(Hd,'legend','on');
hfvt.SosviewSettings.View = 'Cumulative';
%%
% Notice that none of the cumulative internal frequency responses -measured
% from the input to the filter to the various states of each section-
% exceed 0 dB. Thus, this design is a good candidate for a fixed-point
% implementation.

%% Input Stimulus 
% Because we just want to evaluate accuracy, we use some random data to
% filter and compare against. We create a quantizer, with a range of [-1,1)
% to generate random uniformly distributed white-noise data using 10 bits
% of wordlength. We generate 5 independent channels to be used in a
% Monte-Carlo simulation to scale the fixed-point filter.
rng(5,'twister');
q = quantizer([10,9],'RoundMode','round'); 
xq = randquant(q,100,5); 
x = fi(xq,true,10,9);

%% Scaling the Filter
% We assume that the hardware supports 14-bit coefficients, 10-bit bus for
% the input and the states and has a 24-bit MAC unit. Also, we assume that
% we can keep only 12 bits at the output of the filter. 
Hd.Arithmetic = 'fixed';
set(Hd, 'CoeffWordLength', 14, ...
    'InputWordLength', 10, 'InputFracLength', 9, ...
    'NumStateWordLength', 10, 'DenStateWordLength', 10, ...    
    'AccumWordLength', 24, ...
    'OutPutWordLength', 12);
setfilter(hfvt,Hd)
%%
% A length of 14 bits seems enough to represent the coefficients. Now, we
% autoscale the filter internals:
Hd = autoscale(Hd,x);

%% Verifying the Fixed-Point Settings
% We can verify that the settings are correct by running the filter in
% fixed-point:
fipref('LoggingMode', 'on', 'DataTypeOverride', 'ForceOff');
y = filter(Hd,x);
fipref('LoggingMode', 'off');
R = qreport(Hd)
%%
% We verify that there is no overflow, i.e., all the signals are within
% available dynamic range.

%% Comparing DF1SOS versus DF2SOS
% We can compare the quantization noise added by a Direct-Form I
% implementation versus a Direct-Form II implementation. Both
% implementations use cascades of 'Linf'-scaled second-order sections:
Hd2 = design(f, 'ellip', 'FilterStructure', 'df2sos', ...
    'SOSScaleNorm', 'Linf');
Hd2.Arithmetic = 'fixed';
set(Hd2, 'CoeffWordLength', 14, ...
    'InputWordLength', 10, 'InputFracLength', 9, ...
    'SectionInputWordLength', 10, 'SectionOutputWordLength', 10, ...
    'StateWordLength', 10, 'AccumWordLength', 24, ...
    'OutPutWordLength', 12);
Hd2 = autoscale(Hd2,x);
close(hfvt)
hfvt = fvtool(Hd, Hd2,'Analysis','magestimate','ShowReference','off');
legend(hfvt,'DF1SOS','DF2SOS')
%%
close(hfvt)
hfvt = fvtool(Hd, Hd2,'Analysis','noisepower','ShowReference','off');
legend(hfvt,'DF1SOS','DF2SOS')

%%
% We compute the average noise power in the passband for both
% implementations:
df1sosnoisepsd = noisepsd(Hd,100);
df1sos_pb_avg_noisepwr = db(avgpower(df1sosnoisepsd,[0 .48]*pi),'power')
%%
df2sosnoisepsd = noisepsd(Hd2,100);
df2sos_pb_avg_noisepwr = db(avgpower(df2sosnoisepsd,[0 .48]*pi),'power')
%%
% The df1sos has less noise power in particular in the passband where the
% difference is about 2.4 dB. The noise power in the df1sos, however, is
% much larger in the transition band and we can see its negative
% consequences clearly from the magnitude response estimate.
df1sos_tw_avg_noisepwr = db(avgpower(df1sosnoisepsd,[.48 .52]*pi),'power')
%%
df2sos_tw_avg_noisepwr = db(avgpower(df2sosnoisepsd,[.48 .52]*pi),'power')
%%
% This time, the df2sos has an advantage of about 6.25 dB in the transition
% band. Finally, we compute the average noise power in the stopband:
df1sos_sb_avg_noisepwr = db(avgpower(df1sosnoisepsd,[.52 1]*pi),'power')
%%
df2sos_sb_avg_noisepwr = db(avgpower(df2sosnoisepsd,[.52 1]*pi),'power')
%%
% In the stopband -as in the passband- the df1sos has slightly less noise
% power. The difference in the stopband is about 1.25 dB.


displayEndOfDemoMessage(mfilename)
