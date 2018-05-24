%% Designing Low Pass FIR Filters
% This example shows how to design low pass FIR filters. We will use filter
% design objects (fdesign) throughout this example.
%
% FIR filters are widely used due to the powerful design algorithms that
% exist for them, their inherent stability when implemented in
% non-recursive form, the ease with which one can attain linear phase,
% their simple extensibility to multirate cases, and the ample hardware
% support that exists for them among other reasons. This example showcases
% functionality in the DSP System Toolbox(TM) for the design of low pass
% FIR filters with a variety of characteristics. Many of the concepts
% presented here can be extended to other responses such as highpass,
% bandpass, etc.

% Copyright 1999-2012 The MathWorks, Inc.

%% A Simple Low Pass Filter Design
% An ideal low pass filter requires an infinite impulse response.
% Truncating (or windowing) the impulse response results in the so-called
% window method of FIR filter design. Consider a simple design of a low
% pass filter with a cutoff frequency of 0.4*pi radians per sample

Fc    = 0.4;
N = 100;   % FIR filter order
Hf = fdesign.lowpass('N,Fc',N,Fc);

%%
% We can design this low pass filter using the window method. For example,
% we can use a Hamming window or a Dolph-Chebyshev window:

Hd1 = design(Hf,'window','window',@hamming,'SystemObject',true);
Hd2 = design(Hf,'window','window',{@chebwin,50},'SystemObject',true);
hfvt = fvtool(Hd1,Hd2,'Color','White');
legend(hfvt,'Hamming window design','Dolph-Chebyshev window design')

%%
% The choice of filter order was arbitrary. Since ideally the order should
% be infinite, in general, a larger order results in a better approximation
% to ideal at the expense of a more costly implementation. For instance,
% with a Dolph-Chebyshev window, we can decrease the transition region by
% increasing the filter order:

Hf.FilterOrder = 200;
Hd3 = design(Hf,'window','window',{@chebwin,50},'SystemObject',true);
hfvt = fvtool(Hd2,Hd3,'Color','White');
legend(hfvt,'Dolph-Chebyshev window design. Order = 100',...
    'Dolph-Chebyshev window design. Order = 200')

%% Minimum-Order Low Pass Filter Design
% In order to determine a suitable filter order, it is necessary to specify
% the amount of passband ripple and stopband attenuation that will be
% tolerated. It is also necessary to specify the width of the transition
% region around the ideal cutoff frequency. The latter is done by setting
% the passband edge frequency and the stopband edge frequency. The
% difference between the two determines the transition width.

Fp  = 0.38;
Fst = 0.42; % Fc = (Fp+Fst)/2;  Transition Width = Fst - Fp
Ap  = 0.06;
Ast = 60;
setspecs(Hf,'Fp,Fst,Ap,Ast',Fp,Fst,Ap,Ast);

%%
% We can still use the window method, along with a Kaiser window, to design
% the low pass filter.

Hd4 = design(Hf,'kaiserwin','SystemObject',true);
measure(Hd4)

%%
% One thing to note is that the transition width as specified is centered
% around the cutoff frequency of 0.4 pi. This will become the point at
% which the gain of the low pass filter is half the passband gain (or the
% point at which the filter reaches 6 dB of attenuation).

%% Optimal Minimum-Order Designs
% The Kaiser window design is not an optimal design and as a result the
% filter order required to meet the specifications using this method is
% larger than it needs to be. Equiripple designs result in the low pass
% filter with the smallest possible order to meet a set of specifications.

Hd5 = design(Hf,'equiripple','SystemObject',true);
hfvt = fvtool(Hd4,Hd5,'Color','White');
legend(hfvt,'Kaiser window design','Equiripple design')

%%
% In this case, 146 coefficients are needed by the equiripple design while
% 183 are needed by the Kaiser window design.


%% Controlling the Filter order and Passband Ripple/Stopband Attenuation
% When targeting custom hardware, it is common to find cases where the
% number of coefficients is constrained to a set number. In these cases,
% minimum-order designs are not useful because there is no control over the
% resulting filter order. As an example, suppose that only 101 coefficients
% could be used and the passband ripple/stopband attenuation specifications
% need to be met. We can still use equiripple designs for these
% specifications. However, we lose control over the transition width which
% will increase. This is the price to pay for reducing the order while
% maintaining the passband ripple/stopband attenuation specifications.

N = 100; % Order = 100 -> 101 coefficients
setspecs(Hf,'N,Fc,Ap,Ast',N,Fc,Ap,Ast);
Hd6 = design(Hf,'equiripple','SystemObject',true);
measure(Hd6)
hfvt = fvtool(Hd5,Hd6,'Color','White');
legend(hfvt,...
    'Equiripple design, 146 coefficients',...
    'Equiripple design, 101 coefficients')

%%
% Notice that the transition width has increased by almost 50%. This is not
% surprising given the almost 50% difference between 101 coefficients and
% 146 coefficients.

%% Controlling the Transition Region Width
% Another option when the number of coefficients is set is to maintain the
% transition width at the expense of control over the passband
% ripple/stopband attenuation.

setspecs(Hf,'N,Fp,Fst',N,Fp,Fst);
Hd7 = design(Hf,'equiripple','SystemObject',true);
measure(Hd7)
hfvt = fvtool(Hd5,Hd7,'Color','White');
legend(hfvt,...
    'Equiripple design, 146 coefficients',...
    'Equiripple design, 101 coefficients')

%%
% Note that in this case, the differences between using 146 coefficients
% and using 101 coefficients is reflected in a larger passband ripple and a
% smaller stopband attenuation.

%%
% It is possible to increase the attenuation in the stopband while keeping
% the same filter order and transition width by the use of weights. Weights
% are a way of specifying the relative importance of the passband ripple
% versus the stopband attenuation. By default, passband and stopband are
% equally weighted (a weight of one is assigned to each). If we increase
% the stopband weight, we can increase the stopband attenuation at the
% expense of increasing the stopband ripple as well.

Hd8 = design(Hf,'equiripple','Wstop',5,'SystemObject',true);
measure(Hd8)
hfvt = fvtool(Hd7,Hd8,'Color','White');
legend(hfvt,...
    'Passband weight = 1; Stopband weight = 1',...
    'Passband weight = 1, Stopband weight = 5')

%%
% Another possibility is to specify the exact stopband attenuation desired
% and lose control over the passband ripple. This is a powerful and very
% desirable specification. One has control over most parameters of
% interest.

setspecs(Hf,'N,Fp,Fst,Ast',N,Fp,Fst,Ast);
Hd9 = design(Hf,'equiripple','SystemObject',true);
hfvt = fvtool(Hd8,Hd9,'Color','White');
legend(hfvt,...
    'Equiripple design using weights',...
    'Equiripple design constraining the stopband')

%% Optimal Non-Equiripple Low Pass Filters
% Equiripple designs achieve optimality by distributing the deviation from
% the ideal response uniformly. This has the advantage of minimizing the
% maximum deviation (ripple). However, the overall deviation, measured in
% terms of its energy tends to be large. This may not always be desirable.
% When low pass filtering a signal, this implies that remnant energy of the
% signal in the stopband may be relatively large. When this is a concern,
% least-squares methods provide optimal designs that minimize the energy in
% the stopband.

setspecs(Hf,'N,Fp,Fst',N,Fp,Fst);
Hd10 = design(Hf,'firls','SystemObject',true);
hfvt = fvtool(Hd7,Hd10,'Color','White');
legend(hfvt,'Equiripple design','Least-squares design')

%%
% Notice how the attenuation in the stopband increases with frequency for
% the least-squares designs while it remains constant for the equiripple
% design. The increased attenuation in the least-squares case minimizes the
% energy in that band of the signal to be filtered.

%% Equiripple Designs with Increasing Stopband Attenuation
% An often undesirable effect of least-squares designs is that the ripple
% in the passband region close to the passband edge tends to be large. For
% low pass filters in general, it is desirable that passband frequencies of
% a signal to be filtered are affected as little as possible. To this
% extent, an equiripple passband is generally preferable. If it is still
% desirable to have an increasing attenuation in the stopband, we can use
% design options for equiripple designs to achieve this.

Hd11 = design(Hf,'equiripple','StopbandShape','1/f','StopbandDecay',4,...
    'SystemObject',true);
hfvt = fvtool(Hd10,Hd11,'Color','White');
legend(hfvt,'Least-squares design',...
    'Equiripple design with stopband decaying as (1/f)^4')

%%
% Notice that the stopbands are quite similar. However the equiripple
% design has a significantly smaller passband ripple,

mls = measure(Hd10);
meq = measure(Hd11);
mls.Apass
meq.Apass

%%
% Filters with a stopband that decays as (1/f)^M will decay at 6M dB per
% octave. Another way of shaping the stopband is using a linear decay. For
% example given an approximate attenuation of 38 dB at 0.4*pi, if an
% attenuation of 70 dB is desired at pi, and a linear decay is to be used,
% the slope of the line is given by (70-38)/(1-0.4) = 53.333. Such a design
% can be achieved from:

Hd12 = design(Hf,'equiripple','StopbandShape','linear',...
    'StopbandDecay',53.333,'SystemObject',true);
hfvt = fvtool(Hd11,Hd12,'Color','White');
legend(hfvt,...
 'Equiripple design with stopband decaying as (1/f)^4',...
 'Equiripple design with stopband decaying linearly and a slope of 53.333')

%%
% Yet another possibility is to use an arbitrary magnitude specification
% and select two bands (one for the passband and one for the stopband).
% Then, by using weights for the second band, it is possible to increase
% the attenuation throughout the band. For more information on this and
% other arbitrary magnitude designs see <arbmagdemo.html Arbitrary
% Magnitude Filter Design>.

N = 100;
B = 2; % Number of bands
F = [0 .38 .42:.02:1];
A = [1 1 zeros(1,length(F)-2)];
W = linspace(1,100,length(F)-2);
Harb = fdesign.arbmag('N,B,F,A',N,B,F(1:2),A(1:2),F(3:end),A(3:end));
Ha = design(Harb,'equiripple','B2Weights',W,'SystemObject',true);
hfvt = fvtool(Ha,'Color','White');

%% Minimum-Phase Low Pass Filter Design
% So far, we have only considered linear-phase designs. Linear phase is
% desirable in many applications. Nevertheless, if linear phase is not a
% requirement, minimum-phase designs can provide significant improvements
% over linear phase counterparts. For instance, returning to the minimum
% order case, a minimum-phase/minimum-order design for the same
% specifications can be computed with:

setspecs(Hf,'Fp,Fst,Ap,Ast',Fp,Fst,Ap,Ast);
Hd13 =  design(Hf,'equiripple','minphase',true,'SystemObject',true);
hfvt = fvtool(Hd5,Hd13,'Color','White');
legend(hfvt,...
    'Linear-phase equiripple design',...
    'Minimum-phase equiripple design')

%%
% Notice that the number of coefficients has been reduced from 146 to 117.
% As a second example, consider the design with a stopband decaying in
% linear fashion. Notice the increased stopband attenuation. The passband
% ripple is also significantly smaller.

Hd14 = design(Hf,'equiripple','StopbandShape','linear',...
    'StopbandDecay',53.333,'minphase',true,'SystemObject',true);
hfvt = fvtool(Hd12,Hd14,'Color','White');
legend(hfvt,...
    'Linear-phase equiripple design with linearly decaying stopband',...
    'Minimum-phase equiripple design with linearly decaying stopband')

%% Minimum-Order Low Pass Filter Design Using Multistage Techniques
% A different approach to minimizing the number of coefficients that does
% not involve minimum-phase designs is to use multistage techniques. Here
% we show an interpolated FIR (IFIR) approach. For more information on
% this, see <narrowtwdemo.html Efficient Narrow Transition-Band FIR Filter
% Design>.

%% Low Pass Filter Design for Multirate Applications
% Low pass filters are extensively used in the design of decimators and
% interpolators. See <deciminterpdesigndemo.html Design of
% Decimators/Interpolators> for more information on this and
% <multistagesrcdemo.html Multistage Design Of Decimators/Interpolators>
% for multistage techniques that result in very efficient implementations.


displayEndOfDemoMessage(mfilename)

