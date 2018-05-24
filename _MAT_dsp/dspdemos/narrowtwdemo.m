%% Efficient Narrow Transition-Band FIR Filter Design
% This example shows how to design efficient FIR filters with very narrow
% transition-bands using multistage techniques. The techniques can be
% extended to the design of multirate filters. See <multistagesrcdemo.html
% Multistage Design Of Decimators/Interpolators> for an example of that.

% Copyright 1999-2012 The MathWorks, Inc.

%% Design of a Lowpass Filter with Narrow Transition Bandwidth
% One of the drawbacks of using FIR filters is that the filter order tends
% to grow inversely proportional to the transition bandwidth of the filter.
% Consider the following design specifications (where the ripples are given
% in linear units):

Fpass = 0.13;   % Passband edge
Fstop = 0.14;   % Stopband edge
Rpass = 0.001;  % Passband ripple, 0.0174 dB peak to peak
Rstop = 0.0005; % Stopband ripple, 66.0206 dB of minimum attenuation

Hf = fdesign.lowpass(Fpass,Fstop,Rpass,Rstop,'linear');

%%
% A regular linear-phase equiripple design that meets the specs can be
% designed with:

Hd = design(Hf,'equiripple');
cost(Hd)
%%
% The filter length required turns out to be 694 taps.

%% Interpolated FIR (IFIR) Design
% The IFIR design algorithm achieves an efficient design for the above
% specifications in the sense that it reduces the total number of
% multipliers required. To do this, the design problem is broken into two
% stages, a filter which is upsampled to achieve the stringent
% specifications without using many multipliers, and a filter which removes
% the images created when upsampling the previous filter.


Hd_ifir = design(Hf,'ifir');
%%
% Apparently we have made things worse. Instead of a single filter with 694
% multipliers, we now have two filters with a total of 804 multipliers.
% However, close examination of the second stage shows that only about one
% multiplier in 5 is non-zero. The actual total number of multipliers has
% been reduced from 694 to 208.
cost(Hd_ifir)

%%
% Let's compare the responses of the two designs:

hfvt = fvtool(Hd,Hd_ifir,'color','White');
legend(hfvt,'Equiripple design', 'IFIR design','Location','Best')

%% Manually Controlling the Upsampling Factor
% In the previous example, we automatically determined the upsampling
% factor used such that the total number of multipliers was minimized. It
% turned out that for the given specifications, the optimal upsampling
% factor was 5. However, if we examine the design options:

opts=designopts(Hf,'ifir')

%%
% we can see that we can control the upsampling factor. For example, if we
% wanted to upsample by 4 rather than 5:

opts.UpsamplingFactor = 4;
Hd_ifir_4 = design(Hf,'ifir',opts);
cost(Hd_ifir_4)
%%
% We would obtain a design that has a total of 217 non-zero multipliers.

%% Using Joint Optimization
% It is possible to design the two filters used in IFIR conjunctly. By
% doing so, we can save a significant number of multipliers at the expense
% of a longer design time (due to the nature of the algorithm, the design
% may also not converge altogether in some cases):

opts.UpsamplingFactor = 'auto'; % Automatically determine the best factor
opts.JointOptimization = true;
Hd_ifir_jo = design(Hf,'ifir',opts);
cost(Hd_ifir_jo)
%%
% For this design, the best upsampling factor found was 6. The number of
% non-zero multipliers is now only 152

%% Using Multirate/Multistage Techniques to Achieve Efficient Designs
% For the designs discussed so far, single-rate techniques have been used.
% This means that the number of multiplications required per input sample
% (MPIS) is equal to the number of non-zero multipliers. For instance, the
% last design we showed requires 152 MPIS. The single-stage equiripple
% design we started with required 694 MPIS.

%%
% By using multirate/multistage techniques which combine decimation and
% interpolation we can also obtain efficient designs with a low number of
% MPIS. For decimators, the number of multiplications required per input
% sample (on average) is given by the number of multipliers divided by the
% decimation factor.

Hd_multi = design(Hf,'multistage');
cost(Hd_multi)
%%
% The first stage has 21 multipliers, and a decimation factor of 3.
% Therefore, the number of MPIS is 7. The second stage has a length of 45
% and a cumulative decimation factor of 6 (that is the decimation factor of
% this stage multiplied by the decimation factor of the first stage; this
% is because the input samples to this stage are already coming in at a
% rate 1/3 the rate of the input samples to the first stage). The average
% number of multiplications per input sample (reference to the input of the
% overall multirate/multistage filter) is thus 45/6=7.5. Finally, given
% that the third stage has a decimation factor of 1, the average number of
% multiplications per input for this stage is 130/6=21.667. The total
% number of average MPIS for the three decimators is 36.167. 

%%
% For the interpolators, it turns out that the filters are identical to the
% decimators. Moreover, their computational cost is the same. Therefore the
% total number of MPIS for the entire multirate/multistage design is
% 72.333.

%%
% Now we compare the responses of the equiripple design and this one:
set(hfvt,'Filters',[Hd Hd_multi]);
legend(hfvt,'Equiripple design', 'Multirate/multistage design', ...
    'Location','NorthEast')

%% 
% Notice that the stopband attenuation for the multistage design is about
% double that of the other designs. This is because it is necessary for the
% decimators to attenuate out of band components by the required 66 dB in
% order to avoid aliasing that would violate the required specifications.
% Similarly, the interpolators need to attenuate images by 66 dB in order
% to meet the specifications of this problem.

%%
% Also notice the passband gain for this design is no longer 0 dB. This is
% due to the use of interpolators as part of the design. Each interpolator
% has a nominal gain equal to its interpolation factor. The total
% interpolaion factor for the 3 interpolators is 6, which is the gain (in
% linear units) of the overall filter.

%% Manually Controlling the Number of Stages
% The multirate/multistage design that was obtained consisted of 6 stages.
% The number of stages is determined automatically by default. However, it
% is also possible to manually control the number of stages that result.
% For example:

Hd_multi_4 = design(Hf,'multistage','NStages',4);
cost(Hd_multi_4)
%%
% The average number of MPIS for this case is 85.333

%% Group Delay
% We can compute the group delay for each design. Notice that the
% multirate/multistage design introduces the most delay (this is the price
% to pay for a less computationally expensive design). The IFIR design
% introduces more delay than the single-stage equiripple design, but less
% so than the multirate/multistage design. 

set(hfvt,'Filters',[Hd Hd_ifir Hd_multi], 'Analysis', 'grpdelay');
legend(hfvt, 'Equiripple design','IFIR design',...
    'Multirate/multistage design');

%% Filtering a Signal
% We now show by example that the IFIR and multistage/multirate design
% perform comparably to the single-stage equiripple design while requiring
% much less computation. To do so, we plot the power spectral densities of
% the input and the various outputs and note that the sinusoid at 0.4*pi is
% attenuated comparably by all three filters.

n       = 0:1799;
x       = sin(0.1*pi*n') + 2*sin(0.4*pi*n');
y       = filter(Hd,x);
y_ifir  = filter(Hd_ifir,x);
y_multi = filter(Hd_multi,x);
[Pxx,w]   = periodogram(x);
Pyy       = periodogram(y);
Pyy_ifir  = periodogram(y_ifir);
Pyy_multi = periodogram(y_multi);
plot(w/pi,10*log10([Pxx,Pyy,Pyy_ifir,Pyy_multi]));
xlabel('Normalized Frequency (x\pi rad/sample)');
ylabel('Power density (dB/rad/sample)');
legend('Input signal PSD','Equiripple output PSD','IFIR output PSD',...
    'Multirate/multistage output PSD')
axis([0 1 -50 30])
set(gcf,'color','white')
grid on


displayEndOfDemoMessage(mfilename)







