%% FIR Nyquist (L-th band) Filter Design
% This example shows how to design lowpass FIR Nyquist filters.  It also
% compares these filters with raised cosine and square root raised cosine
% filters.  These filters are widely used in pulse-shaping for digital
% transmission systems.  They also find application in
% interpolation/decimation and filter banks.

% Copyright 1999-2012 The MathWorks, Inc.

%% Magnitude Response Comparison
% The plot shows the magnitude response of an equiripple Nyquist filter and
% a raised cosine filter. Both filters have an order of 60 and a
% rolloff-factor of 0.5.  Because the equiripple filter has an optimal
% equiripple stopband, it has a larger stopband attenuation for the same
% filter order and transition width.  The raised-cosine filter is obtained
% by truncating the analytical impulse response and it is not optimal in
% any sense.
NBand = 4;
N = 60;           % Filter order
R = 0.5;          % Rolloff factor
TW = R/(NBand/2); % Transition Bandwidth 
f1 = fdesign.nyquist(NBand,'N,TW',N,TW);
f2 = fdesign.pulseshaping(NBand,'Raised Cosine','N,Beta',N,R);
heq = design(f1,'equiripple','Zerophase',true,'SystemObject',true);
hrc = design(f2,'window','SystemObject',true);
hfvt = fvtool(heq,hrc,'Color','white');
legend(hfvt,'Equiripple NYQUIST design','Raised Cosine design');

%%
% In fact, in this example it is necessary to increase the order of the
% raised-cosine design to about 1400 in order to attain similar
% attenuation.

%% Impulse Response Comparison
% Here we compare the impulse responses.  Notice that the impulse response
% in both cases is zero every 4th sample (except for the middle sample).
% Nyquist filters are also known as L-th band filters, because the cutoff
% frequency is Pi/L and the impulse response is zero every L-th sample.  In
% this case we have 4th band filters.

f1.FilterOrder = 38;
f2.FilterOrder = 38;
h1 = design(f1,'equiripple','Zerophase',true,'SystemObject',true);
h2 = design(f2,'window','SystemObject',true);
hfvt = fvtool(h1,h2,'Color','white','Analysis','Impulse');
legend(hfvt,'Equiripple NYQUIST','Raised Cosine');
title('Impulse response, Order=38, Rolloff = 0.5');

%% Nyquist Filters with a Sloped Stopband
% Equiripple designs allow for control of the slope of the stopband of the
% filter. For example, the following designs have slopes of 0, 20, and 40
% dB/(rad/sample)of attenuation:
set(f1,'FilterOrder',52,'Band',8,'TransitionWidth',.05);
h1 = design(f1,'equiripple','SystemObject',true);
h2 = design(f1,'equiripple','StopbandShape','linear','StopbandDecay',20,...
    'SystemObject',true);
h3 = design(f1,'equiripple','StopbandShape','linear','StopbandDecay',40,...
    'SystemObject',true);
hfvt = fvtool(h1,h2,h3,'Color','white');
legend(hfvt,'Slope=0','Slope=20','Slope=40')

%% Minimum-Phase Design
% We can design a minimum-phase spectral factor of the overall Nyquist
% filter (a square-root in the frequency domain).  This spectral factor can
% be used in a similar manner to the square-root raised-cosine filter in
% matched filtering applications.  A square-root of the filter is placed on
% the transmiter's end and the other square root is placed at the
% receiver's end.
set(f1,'FilterOrder',30,'Band',NBand,'TransitionWidth',TW);
h1 = design(f1,'equiripple','Minphase',true,'SystemObject',true);
f3 = fdesign.pulseshaping(NBand,'Square Root Raised Cosine','N,Beta',N,R);
h3 = design(f3,'window','SystemObject',true);
hfvt = fvtool(h1,h3,'Color','white');
legend(hfvt,'Minimum-phase equiripple design',...
    'Square-root raised-cosine design');

%% Decreasing the Rolloff Factor
% The response of the raised-cosine filter improves as the rolloff factor
% decreases (shown here for rolloff = 0.2).  This is because of the narrow
% main lobe of the frequency response of a rectangular window that is used
% in the truncation of the impulse response.

set(f1,'FilterOrder',N,'TransitionWidth',.1);
set(f2,'FilterOrder',N,'RolloffFactor',.2);
h1 = design(f1,'equiripple','Zerophase',true,'SystemObject',true);
h2 = design(f2,'window','SystemObject',true);
hfvt = fvtool(h1,h2,'Color','white');
legend(hfvt,'NYQUIST equiripple design','Raised Cosine design');


%% Windowed-Impulse-Response Nyquist Design
% Nyquist filters can also be designed using the truncated-and-windowed
% impulse response method. This can be another alternative to the
% raised-cosine design.  For example we can use the Kaiser window method to
% design a filter that meets the initial specs:

set(f1,'TransitionWidth',TW);
hwin = design(f1,'kaiserwin','SystemObject',true);
%%
% The Kaiser window design requires the same order (60) as the equiripple
% design to meet the specs. (Remember that in contrast we required an
% extraordinary 1400th-order raised-cosine filter to meet the stopband
% spec.)

hfvt = fvtool(heq,hrc,hwin,'Color','white');
legend(hfvt,'Equiripple design',...
    'Raised Cosine design','Kaiser window design');

%% Nyquist Filters for Interpolation
% Besides digital data transmission, Nyquist filters are attractive for
% interpolation purposes. The reason is that every L samples you have a
% zero sample (except for the middle sample) as mentioned before. There are
% two advantages to this, both are obvious by looking at the polyphase
% representation.

fm = fdesign.interpolator(4,'nyquist');
Hm = design(fm,'kaiserwin','SystemObject',true);
hfvt = fvtool(Hm,'Color','white');
set(hfvt,'PolyphaseView','on');

%%
% The polyphase subfilter #4 is an allpass filter, in fact it is a pure
% delay (select impulse response in FVTool, or look at the filter
% coefficients in FVTool), so that:
% 1. All of its multipliers are zero except for one, leading to an
% efficient implementation of that polyphase branch.
% 2. The input samples are passed through the interpolation filter without
% modification, even though the filter is not ideal.


displayEndOfDemoMessage(mfilename)

