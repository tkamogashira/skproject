%% Classic IIR Filter Design
% This example shows how to design classic IIR filters. The initial
% focus is on the situation for which the critical design parameter is the
% cutoff frequency at which the filter's power decays to half (-3 dB) the
% nominal passband value.
%
% The example illustrates how easy it is to replace a Butterworth design
% with either a Chebyshev or an elliptic filter of the same order and
% obtain a steeper rolloff at the expense of some ripple in the passband
% and/or stopband of the filter. After this, minimum-order designs are
% explored.

% Copyright 2005-2012 The MathWorks, Inc.

%% Lowpass Filters
% Let's design an 8th order filter with a normalized cutoff frequency of
% 0.4pi. First, we design a Butterworth filter which is maximally flat (no
% ripple in the passband or in the stopband):
N = 8; F3dB = .4;
d = fdesign.lowpass('N,F3dB',N,F3dB);
Hbutter = design(d,'butter','SystemObject',true);
%%
% A Chebyshev Type I design allows for the control of ripples in the
% passband. There are still no ripples in the stopband. Larger ripples
% enable a steeper rolloff. Here, we specify peak-to-peak ripples of 0.5dB:
Ap = .5;
setspecs(d,'N,F3dB,Ap',N,F3dB,Ap);
Hcheby1 = design(d,'cheby1','SystemObject',true);
hfvt = fvtool(Hbutter,Hcheby1,'Color','white');
axis([0 .44 -5 .1])
legend(hfvt,'Butterworth','Chebyshev Type I');
%%
% A Chebyshev Type II design allows for the control of the stopband
% attenuation. There are no ripples in the passband. A smaller stopband
% attenuation enables a steeper rolloff. In this example, we specify a
% stopband attenuation of 80 dB:
Ast = 80;
setspecs(d,'N,F3dB,Ast',N,F3dB,Ast);
Hcheby2 = design(d,'cheby2','SystemObject',true);
hfvt = fvtool(Hbutter,Hcheby2,'Color','white');
axis([0 1 -90 2])
legend(hfvt,'Butterworth','Chebyshev Type II');
%%
% Finally, an elliptic filter can provide the steeper rolloff compared to 
% previous designs by allowing ripples both in the stopband and the
% passband. To illustrate that, we reuse the same passband and stopband
% characteristic as above:
setspecs(d,'N,F3dB,Ap,Ast',N,F3dB,Ap,Ast);
Hellip = design(d,'ellip','SystemObject',true);
hfvt = fvtool(Hbutter,Hcheby1,Hcheby2,Hellip,'Color','white');
axis([0 1 -90 2])
legend(hfvt, ...
    'Butterworth','Chebyshev Type I','Chebyshev Type II','Elliptic');
%%
% By zooming in the passband, we verify that all filters have the same -3dB
% frequency point and that only Butterworth and Chebyshev Type II designs
% have a perfectly flat passband:
axis([0 .44 -5 .1])

%% Phase Consideration
% If phase is an issue, it is useful to notice that Butterworth and
% Chebyshev Type II designs are also the ones introducing a lesser
% distortion (their group delay is flatter):
set(hfvt,'Analysis', 'grpdelay')

%% Minimum Order Designs
% In cases where the 3dB cutoff frequency is not of primary interest but
% instead both the passband and stopband are fully specified in terms of
% frequencies and the amount of tolerable ripples, we can use a minimum
% order design technique:
Fp = .1; Fst = .3; Ap = 1; Ast = 60;
setspecs(d,'Fp,Fst,Ap,Ast',Fp,Fst,Ap,Ast);
Hbutter = design(d,'butter','SystemObject',true);
Hcheby1 = design(d,'cheby1','SystemObject',true);
Hcheby2 = design(d,'cheby2','SystemObject',true);
Hellip = design(d,'ellip','SystemObject',true);
hfvt = fvtool(Hbutter,Hcheby1,Hcheby2,Hellip, 'DesignMask', 'on',...
    'Color','white');
axis([0 1 -70 2])
legend(hfvt, ...
    'Butterworth','Chebyshev Type I','Chebyshev Type II','Elliptic');
%%
% A 7th order filter is necessary to meet the specification with a
% Butterworth design whereas a 5th order is sufficient with either
% Chebyshev techniques. The order of the filter can even be reduced to 4
% with an elliptic design:
order(Hbutter)
order(Hcheby1)
order(Hcheby2)
order(Hellip)

%% Matching Exactly the Passband or Stopband Specifications
% With minimum-order designs, the ideal order needs to be rounded to the
% next integer. This additional fractional order allows the algorithm to
% actually exceed the specifications. We can use the 'MatchExactly' flag to
% constraint the design algorithm to match exactly one band. The other band
% will exceed its specifications. By default, Chebyshev Type I designs
% match the passband, Butterworth and Chebyshev Type II match the stopband
% and the attenuations of both bands are matched by the elliptic
% design (while the stopband edge frequency is exceeded):

Hellipmin1    = design(d, 'ellip', 'MatchExactly', 'passband',...
    'SystemObject',true);
Hellipmin2 = design(d, 'ellip', 'MatchExactly', 'stopband',...
    'SystemObject',true);
hfvt = fvtool(Hellip, Hellipmin1, Hellipmin2, 'DesignMask', 'on',...
    'Color','white');
axis([0 1 -80 2]);
legend(hfvt, 'Matched passband and stopband', ...
    'Matched passband', 'Matched stopband', ...
    'Location', 'Northeast')
%%
% Zoom in the passband to compare passband edges. The matched passband and
% matched both designs have an attenuation of exactly 1 dB at Fpass = .1:
axis([0 .11 -1.1 0.1]);
legend(hfvt, 'Location', 'Southwest')
%%
% We verify that the resulting order of the filters did not change:
order(Hellip)
order(Hellipmin1)
order(Hellipmin2)

%% Highpass, Bandpass and Bandstop Filters
% The results presented above can be extended to highpass, bandpass and
% bandstop response types. For example, here are minimum order bandpass
% filters:
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
    .35,.45,.55,.65,60,1,60);
%%
Hbutter = design(d,'butter','SystemObject',true);
Hcheby1 = design(d,'cheby1','SystemObject',true);
Hcheby2 = design(d,'cheby2','SystemObject',true);
Hellip = design(d,'ellip','SystemObject',true);
hfvt = fvtool(Hbutter,Hcheby1,Hcheby2,Hellip, 'DesignMask', 'on',...
    'Color','white');
axis([0 1 -70 2])
legend(hfvt, ...
    'Butterworth','Chebyshev Type I','Chebyshev Type II','Elliptic',...
    'Location', 'Northwest')

%%

displayEndOfDemoMessage(mfilename)


