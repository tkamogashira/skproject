%% Parametric Equalizer Design
% This example shows how to design parametric equalizer filters. Parametric
% equalizers are digital filters used in audio for adjusting the frequency
% content of a sound signal. Parametric equalizers provide capabilities
% beyond those of graphic equalizers by allowing the adjustment of gain,
% center frequency, and bandwidth of each filter. In contrast, graphic
% equalizers only allow for the adjustment of the gain of each filter.
%
% Typically, parametric equalizers are designed as second-order IIR
% filters. These filters have the drawback that because of their low order,
% they can present relatively large ripple or transition regions and may
% overlap with each other when several of them are connected in cascade.
% The DSP System Toolbox(TM) provides the capability to design
% high-order IIR parametric equalizers. Such high-order designs provide
% much more control over the shape of each filter. In addition, the designs
% special-case to traditional second-order parametric equalizers if the
% order of the filter is set to two.

% Copyright 2006-2012 The MathWorks, Inc. 

%% Some Basic Designs
% Consider the following two designs of parametric equalizers. The design
% specifications are the same except for the filter order. The first design
% is a typical second-order parametric equalizer that boosts the signal
% around 0.5*pi rad/sample by 6 dB. The second design does the same with a
% fourth-order filter. Notice how the fourth-order filter is closer to an
% ideal brickwall filter when compared to the second-order design.
% Obviously the approximation can be improved by increasing the filter
% order even further. The price to pay for such improved approximation is
% increased implementation cost as more multipliers are required.

f = fdesign.parameq('N,F0,BW,Gref,G0,GBW',2,0.5,0.2,0,6,6+10*log10(.5))
h = design(f);
f.FilterOrder = 4;
h1 = design(f);
hfvt = fvtool(h,h1,'Color','white');
legend(hfvt,'2nd-Order Design','4th-Order Design');
%%
% One of the design parameters is the filter bandwidth, BW. Note however
% that you not only specify what the desired bandwidth is, you also specify
% the reference gain, GBW, at which this bandwidth is defined. In this
% case, we set GBW to be at half the peak magnitude squared gain of the
% filter, that is, approximately 3.0103 dB below the 6 dB gain. To see
% this, we can plot the magnitude squared filter response and verify that
% the gain at which the filter's bandwidth is 0.2*pi is equal to one half
% of the peak magnitude squared.
set(hfvt,'Filters',[h h1],'MagnitudeDisplay','Magnitude squared');
legend(hfvt,'2nd-Order Design','4th-Order Design');

%% Designs Based on Quality Factor
% Another common design parameter is the quality factor, Qa. As a first
% example we design a second order peak filter with a quality factor Qa=5. 
N = 2;             % Filter Order
F0 = 0.2;          % Center Frequency
Qa = 5;            % Quality Factor
Gref = 0;          % Reference Gain (dB)
G0 = 10; % Gain at Center Frequency or Boost Gain (dB)

f = fdesign.parameq('N,F0,Qa,Gref,G0',N,F0,Qa,Gref,G0)
h1 = design(f);
%%
% The design may be verified by measuring the quality factor of the filter
% which is directly obtained from the poles of its second order transfer
% function. Notice also how the measurement object returns the linear
% bandwidth BW of 0.037377, referenced to the gain GBW of 5 dB which
% corresponds to the geometric mean of the magnitude squared values of G0
% and Gref.
m = measure(h1)
%%
% We may use the bandwidth defined by Qa for a second order filter to
% design higher order filters. Higher order designs will yield designs with
% sharper transition bands while maintaining the same bandwidth referenced
% to the same gain GBW shown above. As an example, we increase the order of
% the previously designed peak filter to 4, and 10. 

f.FilterOrder = 4; 
h2 = design(f);
f.FilterOrder = 10; 
h3 = design(f);
set(hfvt,'Filters',[h1 h2 h3],'MagnitudeDisplay','Magnitude (dB)');
axis([0 .5 -0.5 10.5])
legend(hfvt,'N=2','N=4','N=10')

%% Designs Based on Octave Bandwidth 
% A desired octave bandwidth can be translated into a quality factor Qa.
% For instance, we may design two second order peaking filters with 0.5
% and 1 octave bandwidths respectively.

BWoct = 0.5; % Desired Octave Bandwidth
f.Qa = 0.5/( sinh(BWoct*(log(2)/2)*(F0*pi)/sin(F0*pi)));
h1 = design(f);

BWoct = 1; % Desired Octave Bandwidth
f.Qa = 0.5/( sinh(BWoct*(log(2)/2)*(F0*pi)/sin(F0*pi)));
h2 = design(f);

set(hfvt,'Filters',[h1 h2]);
legend(hfvt,'Octave BW=0.5','Octave BW=1')

%% A Parametric Equalizer That Cuts 
% The previous design is an example of a parametric equalizer that boosts
% the signal over a certain frequency band. You can also design equalizers
% that cut (attenuate) the signal in a given region.

setspecs(f,'N,F0,BW,Gref,G0,GBW,Gp,Gst',6,0.3,0.1,0,-3,-2,-2.5,-0.5);
h = design(f);
set(hfvt,'Filters',h,'legend','off');
axis([0 1 -3 0.5])
%%
% Notice that in this case we have specified both a passband gain, Gp,
% and a stopband gain, Gst. This parameters allow for the filter to
% ripple in the passband and stopband with the advantage of providing
% steeper transitions between passband and stopband. For comparison,
% consider a filter of the same order without ripples. Notice the wider
% transitions that result as a tradeoff.

setspecs(f,'N,F0,BW,Gref,G0,GBW',6,0.3,0.1,0,-3,-2);
h1 = design(f);
set(hfvt,'Filters',[h h1]);
axis([0 1 -3 0.5])
%%
% It is also possible to only specify ripples in the passband or to only
% specify ripples in the stopband.

%% Minimum-Order Designs
% Returning to the first design, instead of manually increasing the filter
% order to better approximate a brickwall filter, we can specify the
% desired shape and design a filter of minimum-order that meets such
% specifications. To specify the shape, in addition to the bandwidth BW and
% corresponding gain GBW, we specify a passband bandwidth BWp and
% corresponding gain Gp. It would also be possible to specify a stopband
% bandwidth and corresponding gain.

f = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp',...
    0.5,0.2,0.18,0,6,6+10*log10(.5),5.8);
h = design(f,'butter');
%%
% Notice that we specified that we wanted a Butterworth (i.e. a maximally
% flat) design. If we allow for passband ripples, we can design a Chebyshev
% Type I filter instead.

h1 = design(f,'cheby1');
set(hfvt,'Filters',[h h1]);
legend(hfvt,'Butterworth Design','Chebyshev Type I Design', ...
    'Location','NorthEast');
%%
% In this case, the tradeoff occurs between ripples and filter order.

bord = order(h)  % Order of Butterworth design
cord = order(h1) % Order of Chebyshev Type I design

%% Lowpass and Highpass Shelving Filters
% The filter's bandwidth BW is only perfectly centered around the center
% frequency F0 when such frequency is set to 0.5*pi (half the Nyquist
% rate). When F0 is closer to 0 or to pi, there is a warping effect that
% makes a larger portion of the bandwidth to occur at one side of the
% center frequency. In the edge cases, if the center frequency is set to 0
% (pi), the entire bandwidth of the filter occurs to the right (left) of
% the center frequency. The result is a so-called shelving lowpass
% (highpass) filter.

f = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp,Gst',...
    0, 0.3, 0.2, 0, 4, 2, 3.5, 0.5);
f1 = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp,Gst',...
    1, 0.3, 0.2, 0, 4, 2, 3.5, 0.5);
h = design(f);
h1 = design(f1);
set(hfvt,'Filters',[h h1]);
legend(hfvt,'Lowpass Shelving Filter','Highpass Shelving Filter');

%% Specifying Low and High Frequencies
% Because of the frequency warping mentioned above, in general it can be
% difficult to control the exact frequency edges at which the bandwidth
% occurs. To do so, an alternate specification can be used.

f = fdesign.parameq('N,Flow,Fhigh,Gref,G0,GBW,Gst',...
    4,.35,.55,0,-8,-7,-0.5);
h = design(f);
set(hfvt,'Filters',h,'legend','off');
%%
% Notice that the gain at 0.35*pi and 0.55*pi rad/sample is exactly -7 dB
% as specified.

%% Shelving Filters with a Variable Transition Bandwidth or Slope
% One of the characteristics of a shelving filter is the transition
% bandwidth (sometimes also called transition slope) which may be specified
% by a shelf slope parameter S. The bandwidth reference gain GBW is always
% set to half the boost or cut gain of the shelving filter. All other
% parameters being constant, as S increases the transition bandwidth
% decreases, (and the slope of the response increases) creating a "slope
% rotation" around the GBW point as illustrated in the example below.

F0 = 0;  % F0=0 designs a lowpass filter, F0=1 designs a highpass filter
Fc = .2; % Cutoff Frequency
G0 = 10;
S = 1.5;
f = fdesign.parameq('N,F0,Fc,S,G0',N,F0,Fc,S,G0);
h1 = design(f);

f.S = 2.5;
h2 = design(f);

f.S = 4;
h3 = design(f);

set(hfvt,'Filters',[h1 h2 h3]);
legend(hfvt,'S=1.5','S=2.5','S=4');
%%
% The transition bandwidth and the bandwidth gain corresponding to each
% value of S can be obtained using the MEASURE method. We verify that
% the bandwidth reference gain GBW is the same for the three designs and
% we quantify by how much the transition width decreases when S increases.
m = measure([h1 h2 h3]);
get(m,'GBW')
%%
get(m,'HighTransitionWidth')
%%
% As the shelf slope parameter S increases, the ripple of the filters also
% increases. We can increase the filter order to reduce the ripple while
% maintaining the desired transition bandwidth. 
h1 = h3;

f.FilterOrder = 3;
h2 = design(f);

f.FilterOrder = 4;
h3 = design(f);

set(hfvt,'Filters',[h1 h2 h3]);
legend(hfvt,'N=2','N=3','N=4');
hold on;
m = measure(h1);
plot(m.BWpass,m.G0,'k*','markersize',10)
plot(m.BW,m.GBW,'k*','markersize',10)
plot(m.BWstop,m.Gref,'k*','markersize',10)

%%
% The three responses intercept at the three points (marked with asterisks
% on the above figure) that respectively define the passband bandwidth, the
% bandwidth reference gain, and the stopband bandwidth. Hence, all three
% filters have the same transition width and bandwidth. Note however that
% the higher order filters have considerably less ripple.
% 

%% Shelving Filters with a Prescribed Quality Factor
% The quality factor Qa may be used instead of the shelf slope parameter S
% to design shelving filters with variable transition bandwidths.
F0 = 1;    % Highpass Shelving Filter
Fc = .3;
Qa = 0.48;
f = fdesign.parameq('N,F0,Fc,Qa,G0',N,F0,Fc,Qa,G0);
h1 = design(f);

f.Qa = 1/sqrt(2);
h2 = design(f);

f.Qa = 2.0222;
h3 = design(f);

close(hfvt);
hfvt = fvtool([h1 h2 h3],'Color','white');
legend(hfvt,'Qa=0.48','Qa=0.7071','Qa=2.0222');

%% Cascading Parametric Equalizers
% Parametric equalizers are usually connected in cascade (in series) so
% that several are used simultaneously to equalize an audio signal. To
% connect several equalizers in this way, we use the CASCADE function.

f1 = fdesign.parameq('N,F0,BW,Gref,G0,GBW',2,.4,.2,0,5,5+10*log10(.5));
f2 = fdesign.parameq('N,F0,BW,Gref,G0,GBW',2,.6,.15,0,-5,-5-10*log10(.5));
h1 = design(f1);
h2 = design(f2);
hc = cascade(h1,h2);
set(hfvt,'Filters',[h1 h2 hc]);
legend(hfvt,'Second-Order Boost Filter','Second-Order Cut Filter',...
    'Cascade of the Two Filters');
axis([0 1 -5.2 5.2]);
%%
% Low-order designs such as the second-order filters above can interfere
% with each other if their center frequencies are closely spaced.
% Higher-order designs are less prone to such interference.

f1.FilterOrder = 8;
f2.FilterOrder = 8;
h3   = design(f1);
h4   = design(f2);
hc2  = cascade(h3,h4);
set(hfvt,'Filters',[h3 h4 hc2]);
legend(hfvt,'Eighth-Order Boost Filter','Eighth-Order Cut Filter',...
    'Cascade of the Two Filters','Location','NorthEast');

%% Complementary Peak and Notch Parametric Equalizers
% Next we design a complementary pair of second order peak and notch
% parametric equalizers. Notice that because these filters are
% complementary, the cascaded response corresponds to an all-pass filter.
N  = 2;
F0 = 0.3;
Qa = 5;
Gref = 0;
G0 = 10;    % Boost Gain (dB)
f = fdesign.parameq('N,F0,Qa,Gref,G0',N,F0,Qa,Gref,G0);
h1 = design(f);

f.G0 = -10; % Cut Gain (dB)
h2 = design(f);
h3 = cascade(h1,h2);
set(hfvt,'Filters',[h1 h2 h3]);
axis([0 1 -10 10]);
legend(hfvt,'Peak parametric equalizer G0=10 dB', ...
            'Notch parametric equalizer G0=-10 dB','Cascaded responses')
        
%% Designing Traditional Filters
% Traditional bandpass filters can be designed by setting the reference
% gain to negative infinity (dB), i.e. zero in absolute units. This example
% shows a minimum-order lowpass elliptic design with a given 3-dB point.

f = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp,Gst',...
    0, 0.2, 0.19, -Inf, 0, 10*log10(0.5),-0.5, -85);
h = design(f);
set(hfvt,'Filters',h,'legend','off');


displayEndOfDemoMessage(mfilename)
