%% Least Pth-Norm Optimal IIR Filter Design
% This example shows how to design optimal IIR filters with arbitrary
% magnitude response using the least-Pth unconstrained optimization
% algorithm.

% Copyright 1999-2012 The MathWorks, Inc.

%% IIRLPNORM Fundamentals
% The IIRLPNORM algorithm differs from the traditional IIR design
% algorithms in several aspects:
%%
%    . The designs are done directly in the Z-domain. No need for bilinear
%      transformation.
%%
%    . The numerator and denominator order can be different.
%%
%    . One can design IIR filters with arbitrary magnitude response in
%      addition to the basic lowpass, highpass, bandpass, and bandstop.

%% Lowpass Design
% For simple designs however (lowpass, highpass, etc.), we must specify
% passband and stopband frequencies. The transition band is considered as a
% don't-care band by the algorithm. 
d = fdesign.lowpass('N,Fp,Fst',8,.4,.5)
%%
hiirlpnorm = design(d,'iirlpnorm','SystemObject',true);
%% 
% For comparison purposes, consider this elliptic filter design
d = fdesign.lowpass('N,Fp,Ap,Ast',8,.4,0.0084,66.25);
hellip = design(d, 'ellip','SystemObject',true);
hfvt = fvtool(hiirlpnorm,hellip,'Color','White');
legend(hfvt,'IIRLPNORM design','ELLIP design');

%%
% The response of the two filters is very similar. Zooming into the
% passband accentuates the point. However, the magnitude of the filter
% designed with IIRLPNORM is not constrained to be less than 0 dB.
axis([0 .44 -.0092 .0052])

%% Different Numerator, Denominator Orders
% While we can get very similar designs as elliptic filters, IIRLPNORM
% provides greater flexibility. For instance, say we change the denominator
% order 
d = fdesign.lowpass('Nb,Na,Fp,Fst',8,6,.4,.5)
%%
hiirlpnorm = design(d,'iirlpnorm','SystemObject',true);

%%
% With elliptic filters (and other classical IIR designs) we must change
% both the numerator and the denominator order. 
d = fdesign.lowpass('N,Fp,Ap,Ast',6,.4,0.0084,58.36);
hellip = design(d, 'ellip','SystemObject',true);
hfvt = fvtool(hiirlpnorm,hellip,'Color','White');
legend(hfvt,'IIRLPNORM design','ELLIP design');

%%
% Clearly, the elliptic design (in green) now results in a much wider
% transition width.

%% Weighting the Designs
% Similar to equiripple or least-square designs, we can weight the
% optimization criteria to alter the design as we see fit. However, unlike
% equiripple, we have the extra flexibility of providing different weights
% for each frequency point instead of for each frequency band.
%
% Consider the following two highpass filters:
d = fdesign.highpass('Nb,Na,Fst,Fp',6,4,.6,.7)
%%
h1 = design(d,'iirlpnorm','Wpass',1,'Wstop',10,'SystemObject',true);
h2 = design(d,'iirlpnorm','Wpass',1,'Wstop',[100 10],'SystemObject',true);
hfvt = fvtool(h1,h2,'Color','White');
legend(hfvt,'Same weight for entire band',...
    'Different weights in stopband');
%%
% The first design uses the same weight per band (10 in the stopband, 1 in
% the passband). The second design uses a different weight per frequency
% point. This provides a simple way of attaining a sloped stopband which
% may be desirable in some applications. The extra attenuation over
% portions of the stopband comes at the expense of a larger passband ripple
% and transition width.

%% The Pth-Norm
% Roughly speaking, the optimal design is achieved by minimizing the error
% between the actual designed filter and an ideal filter in the Pth-norm
% sense. Different values of the norm result in different designs. When
% specifying the P-th norm, we actually specify two values, 'InitNorm' and
% 'Norm' where 'InitNorm' is the initial value of the norm used by the
% algorithm and 'Norm' is the final (the actual) value for which the design
% is optimized. Starting the optimization with a smaller initial value aids
% in the convergence of the algorithm.
% 
% By default, the algorithm starts optimizing in the 2-norm sense but
% finally optimizes the design in the 128-norm sense. The 128-norm in
% practice yields a good approximation to the inifinity-norm. So that the
% designs tend to be equiripple. For a least-squares design, we should set
% the norm to 2. For instance, consider the following lowpass filter  

d = fdesign.lowpass('Nb,Na,Fp,Fst',10,7,.25,.35);
design(d,'iirlpnorm','Norm',2,'SystemObject',true);
set(gcf,'Color',[1 1 1]);

%% Arbitrary Shaped Magnitude
% Another of the important features of IIRLPNORM is its ability to design
% filters other than the basic lowpass, highpass, bandpass and bandstop.
% See the <arbmagdemo.html Arbitrary Magnitude Filter Design> example for
% more information. We now show a few examples:

%% Rayleigh Fading Channel
% Here's a filter for noise shaping when simulating a Rayleigh fading
% wireless communications channel

F1 = 0:0.01:0.4;
A1 = 1.0 ./ (1 - (F1./0.42).^2).^0.25;
F2 = [0.45 1];
A2 = [0 0];
d = fdesign.arbmag('Nb,Na,B,F,A',4,6,2,F1,A1,F2,A2);
design(d,'iirlpnorm','SystemObject',true);
set(gcf,'Color',[1 1 1]);

%% Optical Absorption of Atomic Rubidium87 Vapor
% The following design models the absorption of light in a certain gas. The
% resulting filter turns out to have approximately linear-phase:

Nb = 12; Na = 10;
F = linspace(0,1,100);
As = ones(1,100)-F*0.2;
Absorb = [ones(1,30),(1-0.6*bohmanwin(10))',...
    ones(1,5), (1-0.5*bohmanwin(8))',ones(1,47)];
A = As.*Absorb;
d = fdesign.arbmag('Nb,Na,F,A',Nb,Na,F,A);
W = [ones(1,30) ones(1,10)*.2 ones(1,60)];
design(d, 'iirlpnorm', 'Weights', W, 'Norm', 2, 'DensityFactor', 30,...
    'SystemObject',true);
set(gcf,'Color','white')

displayEndOfDemoMessage(mfilename)
