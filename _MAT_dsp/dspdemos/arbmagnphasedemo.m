%% Arbitrary Magnitude and Phase Filter Design
% This example shows how to design filters given customized magnitude and
% phase specifications. Custom magnitude and phase design specifications
% are used for the equalization of magnitude and phase distorsions found in
% data transmission systems (channel equalization) or in oversampled ADC
% (compensation for non-ideal hardware characteristics for example). These
% techniques also allow for the design of filters that have smaller group
% delays than linear phase filters and less distorsion than minimum-phase
% filters for a given order.

% Copyright 2005-2012 The MathWorks, Inc.

%% FIR Modeling
% In this first example, we compare several FIR design techniques to model
% the magnitude and phase of a complex RF bandpass filter defined on the
% complete Nyquist range (there is no relaxed or "don't care" regions).
load cpxbp.mat
f=fdesign.arbmagnphase('N,F,H',100,F1,H1); 
Hd = design(f,'allfir');
hfvt = fvtool(Hd, 'Color','w');
legend(hfvt,'Equiripple', 'FIR Least-Squares','Frequency Sampling', ...
    'Location', 'NorthEast')
hfvt(2) = fvtool(Hd,'Analysis','phase','Color','white');
legend(hfvt(2),'Equiripple', 'FIR Least-Squares','Frequency Sampling')

ax=get(hfvt(2),'CurrentAxes'); set(ax,'NextPlot','Add');
pidx = find(F1>=0);
plot(ax,F1,[fliplr(unwrap(angle(H1(pidx-1:-1:1)))) ... % Mask
    unwrap(angle(H1(pidx:end)))],'k--')

%% IIR Design
% Next, we design a highpass IIR filter with approximately linear passband
% phase. Caution must be employed when using this IIR design technique
% since the stability of the filter is not guaranted.
F = [linspace(0,.475,50) linspace(.525,1,50)];
H = [zeros(1,50) exp(-j*pi*13*F(51:100))];
f=fdesign.arbmagnphase('Nb,Na,F,H',12,10,F,H);
W = [ones(1,50) 100*ones(1,50)];
Hd = design(f,'iirls','Weights',W);
isstable(Hd)
%%
close(hfvt(1));close(hfvt(2));
hfvt = fvtool(Hd, 'Color','w');
legend(hfvt,'IIR Least-Squares','Location', 'NorthWest')
hfvt(2) = fvtool(Hd,'Analysis','phase','Color','white');
legend(hfvt(2),'IIR Least-Squares','Location', 'NorthEast')

%% Bandpass FIR Filter with a Low Group Delay
% It is sometimes interesting to give up the exact linearity of the phase
% in order to reduce the delay of the filter while maintaining a good
% approximation of the phase linearity in the passband. Let's define the 3
% bands of the bandpass filter: 
F1 = linspace(0,.25,30);  % Lower stopband
F2 = linspace(.3,.56,40); % Passband
F3 = linspace(.62,1,30);  % Higher stopband
N = 50;  % Filter Order
gd = 12; % Desired Group Delay
H1 = zeros(size(F1));
H2 = exp(-j*pi*gd*F2);
H3 = zeros(size(F3));
f=fdesign.arbmagnphase('N,B,F,H',N,3,F1,H1,F2,H2,F3,H3); 
Hd = design(f,'equiripple');
%%
% Comparing with a linear phase design, we see that the group delay is
% reduced by half while the phase response remains approximately linear in
% the passband.
f=fdesign.arbmag('N,B,F,A',N,3,F1,abs(H1),F2,abs(H2),F3,abs(H3)); 
Hd(2) = design(f,'equiripple');
close(hfvt(1));close(hfvt(2));
hfvt = fvtool(Hd, 'Color', 'w');
legend(hfvt,'Low Group Delay', 'Linear Phase', 'Location', 'NorthEast')
hfvt(2) = fvtool(Hd,'Analysis','grpdelay','Color','w');
legend(hfvt(2),'Low Group Delay', 'Linear Phase', 'Location', 'NorthEast')
axis([.3 .56 0 35])
%%
set(hfvt(2),'Analysis', 'phase','Color','w');
axis([.3 .56 -30 10])

%% Passband Equalization of a Chebyshev Lowpass Filter
% A common problem is to compensate for nonlinear-phase responses of IIR
% filters. In this example we will work with a 3rd order Chebyshev Type I
% lowpass filter with a normalized passband frequency of 1/16 and .5 dB of
% passband ripples.
Fp = 1/16;  % Passband frequency 
Ap = .5;    % Passband ripples
f = fdesign.lowpass('N,Fp,Ap',3,Fp,Ap);
Hcheby = design(f,'cheby1'); 
close(hfvt(1));close(hfvt(2));
hfvt = fvtool(Hcheby,'Color','w');
legend(hfvt, 'Chebyshev Lowpass');
hfvt(2) = fvtool(Hcheby,'Color','w','Analysis','grpdelay');
legend(hfvt(2), 'Chebyshev Lowpass');
%% 
% Design of a 2-band digital FIR equalizer. We choose a 2-band approach
% because we want to concentrate our efforts in the passband. We are aiming
% at a flat group delay of 35 samples in the passband.
Gd = 35;    % Passband Group Delay of the equalized filter (linear phase)
F1 = 0:5e-4:Fp; D1 = exp(-j*Gd*pi*F1)./freqz(Hcheby,F1*pi);     % Passband
Fst = 3/16; F2 = linspace(Fst,1,100); D2 = zeros(1,length(F2)); % Stopband
f = fdesign.arbmagnphase('N,B,F,H',51,2,F1,D1,F2,D2);
Hfirls = design(f,'firls');      % Least-Squares design
Heqrip = design(f,'equiripple'); % Equiripple design
%%
% Magnitude Equalization
%%
% The passband ripples are attenuated after equalization from .5 dB to
% .27dB for the least-squares equalizer and .16 dB for the equiripple
% equalizer.
close(hfvt(1));close(hfvt(2));
hfvt = fvtool(Hcheby,cascade(Hcheby,Hfirls),cascade(Hcheby,Heqrip), ...
    'Color','w');
legend(hfvt,'Chebyshev Lowpass','Least-Squares Equalization (cascade)', ...
    'Equiripple Equalization (cascade)', 'Location', 'NorthEast')
hfvt(2) = fvtool(Hcheby,cascade(Hcheby,Hfirls),cascade(Hcheby,Heqrip), ...
    'Color','w');
legend(hfvt(2),'Chebyshev Lowpass', ...
    'Least-Squares Equalization (cascade)', ...
    'Equiripple Equalization (cascade)', 'Location', 'NorthEast')
axis([0 .1 -.8 .5])
%%
% Phase (Group Delay) Equalization
%%
% The group delay in the passband was equalized from a peak to peak
% difference of 8.8 samples to .51 samples with the least-squares equalizer
% and .62 samples with the equiripple equalizer.
set(hfvt(2),'Analysis','grpdelay')
axis([0 1 0 40])
hfvt(3) = fvtool(Hcheby,cascade(Hcheby,Hfirls),cascade(Hcheby,Heqrip), ...
    'Analysis', 'grpdelay','Color','w');
legend(hfvt(3),'Chebyshev Lowpass', ...
    'Least-Squares Equalization (cascade)', ...
    'Equiripple Equalization (cascade)', 'Location', 'NorthEast')
axis([0 Fp 34 36])

%%
close(hfvt(1));close(hfvt(2));close(hfvt(3));


displayEndOfDemoMessage(mfilename)
