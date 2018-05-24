%% Multistage Design Of Decimators/Interpolators
% This example shows how to design multistage decimators and interpolators.
% The example <narrowtwdemo.html Efficient Narrow Transition-Band FIR
% Filter Design> showed how to apply the IFIR and the MULTISTAGE approaches
% to single-rate designs of lowpass filters. The techniques can be extended
% to the  design of multistage decimators and/or interpolators. The IFIR
% approach results in a 2-stage decimator/interpolator. For the MULTISTAGE
% approach, the number of stages can be either automatically optimized or
% manually controlled.

% Copyright 1999-2012 The MathWorks, Inc.

%% Reducing the Sampling-Rate of a Signal
% Decimators are used to reduce the sampling-rate of a signal while
% simultaneously reducing the bandwidth proportionally. For example, if the
% rate is to be reduced by a factor of 8, the following are typical
% specifications for a lowpass filter that will reduce the bandwidth
% accordingly.

Fpass = 0.11;
Fstop = 0.12;
Apass = 0.02;  % 0.02 dB peak-to-peak ripple
Astop = 60;    % 60 dB minimum attenuation
M     = 8;     % Decimation factor of 8
Hfd   = fdesign.decimator(M,'lowpass',Fpass,Fstop,Apass,Astop);

%%
% A single-stage equiripple design for these specifications requires on
% average 649/8 = 81.125 multiplications per input sample (MPIS):
Hm = design(Hfd,'equiripple');
cost(Hm)

%%
% As we mentioned, an IFIR design results in a two stage implementation.
% Notice that in this case only 27/4+172/8 = 28.25 MPIS are required. 
Hm_ifir = design(Hfd,'ifir');
cost(Hm_ifir)

%%
% A multistage design results in approximately the same cost when
% implementing the design with 3 stages. The number of MPIS required for
% this design is 9/2+14/4+172/8 = 29.5
Hm_multi = design(Hfd,'multistage');
cost(Hm_multi)

%% Tweaking Designs for Improved Efficiency
% The IFIR design has a joint optimization option that can improve the
% efficiency of the design even further (although it may not converge in
% some cases). Note that this design may take a long time. The number of
% MPIS is reduced to 13/4+163/8 = 23.625
Hm_ifir_jo = design(Hfd,'ifir','JointOptimization',true);
cost(Hm_ifir_jo)

%%
% The multistage design can also be improved by noticing that the
% decimators used involve a decimation factor of 2. Two of three stages can
% be replaced with halfband filters, for which only about half of the
% coefficients are non-zero. The number of MPIS is reduced to 27.25.
Hm_multi_hb = design(Hfd,'multistage','UseHalfbands',true);
cost(Hm_multi_hb)

%% Using Nyquist Filters for Improved Efficiency
% When decimating by a factor M, it is often computationally advantageous
% to use Nyquist designs (Where the band is also M). In this example, we
% have M = 8.

TW      = 0.01; % Transition width is the same as in previous design
Astop   = 60;   % 60 dB minimum attenuation
M       = 8;    % Decimation factor of 8
Hfd_nyq = fdesign.decimator(M,'nyquist',M,TW,Astop);

%%
% A single-stage design using a Kaiser window results in a filter length of
% 727. However, given that it is a Nyquist filter, about one out of every M
% coefficients is zero, so the actual number of multipliers is 637 so the
% number of MPIS is 79.625 which is less than the single-stage equripple
% design for the same transition width and stopband attenuation. Moreover,
% the passband ripple is smaller.

Hm_nyq = design(Hfd_nyq,'kaiserwin');
measure(Hm)
measure(Hm_nyq)
%%
cost(Hm_nyq)

%%
% Halfband filters are a special case of Nyquist filters when the band is
% equal to two. One way to obtain an 8th-band Nyquist filter that decimates
% by 8 is to cascade three halfbands, each of which decimates by two.
% Multistage designs will do this automatically when the cost is found to
% be minimal. Given that only about half the coefficients are non-zero the
% number of MPIS required in this case is only 15.375, the lowest by far of
% all designs tried.
Hm_multi_nyq = design(Hfd_nyq,'multistage');
cost(Hm_multi_nyq)
%%
hfvt = fvtool(Hm_nyq,Hm_multi_nyq, 'Color', 'white');
legend(hfvt,'Single-stage Nyquist design','Multistage Nyquist design',...
    'Location','NorthEast')

%% Interpolators
% The cases shown above apply equally to the design ofinterpolators. For
% example:
Fpass = 0.11;
Fstop = 0.12;
Apass = 0.02;  % 0.02 dB peak-to-peak ripple
Astop = 60;    % 60 dB minimum attenuation
L     = 8;     % Interpolation factor of 8
Hfi   = fdesign.interpolator(L,'lowpass',Fpass,Fstop,Apass,Astop);

%%
% A multistage design that uses halfbands can be computed with identical
% syntax as before:

Hmi = design(Hfi,'multistage','UseHalfbands',true);
measure(Hmi)
set(hfvt,'Filters',Hmi,'Legend','off');

%%
% Notice that as with all interpolators, the passband gain (in linear
% units) is equal to the interpolation factor. The minimum distance (in dB)
% between the passband and the stopband is about 60 dB as specified by
% Astop.


%% Summary
% The use of multistage techniques can provide significant computational
% savings when implementing decimators/interpolators. In particular, the
% use of multistage Nyquist filters can be extremely efficient.


displayEndOfDemoMessage(mfilename)

