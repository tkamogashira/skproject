%% IIR Polyphase Filter Design
% This example shows how to design IIR polyphase filters.
%
% IIR polyphase filters present several interesting properties: they
% require a very small number of multipliers to implement, they are
% inherently stable, have low roundoff noise sensitivity and no limit
% cycles. Furthermore, it is possible to achieve almost linear phase
% designs. 
%
% Butterworth, Chebyshev I and II, and elliptic IIR filters can be designed
% using allpass subfilters as building blocks for the following response
% types: lowpass, highpass, bandpass and bandstop. Butterworth and elliptic
% IIR filters can also be designed with a halfband, Hilbert transform,
% multirate halfband and multirate dyadic halfband response type.
%
%   Copyright 2006-2012 The MathWorks, Inc.

%% Cost Efficiency
% A way of measuring a filter's computational cost is to determine how many
% multiplications need to be computed (on average) per input sample (MPIS).
% Consider a MPIS count case study: FIR vs IIR for the following filter
% specifications:
Fc = 1/16;    % Cutoff frequency: 0.0625*pi rad/sample 
TW = 0.002;   % Transition width:  0.002*pi rad/sample 
Ap = 3e-3;    % Maximum passband ripple: 0.003 dB 
Ast= 80;      % Minimum stopband attenuation: 80 dB
Fp = Fc-TW/2;
Fst= Fc+TW/2;
f = fdesign.lowpass(Fp,Fst,Ap,Ast);
%%
% Elliptic filters provide the lowest order IIR filter of all minimum order
% IIR filters that meet the specifications (optimal minimax solution). The
% classic elliptic design can be implemented with a direct-form II,
% second-order sections structure:
Hiir = design(f,'ellip')
%%
% This filter requires 38 MPIS.
cost(Hiir)
%%
% In most cases, if we are reducing the bandwidth of a signal, we should
% also reduce its sampling rate to improve its computational cost. Rather
% than using the conventional approach that the stopband frequency must be
% set at 1/M, where M is the decimation factor, Nyquist filters when used
% for decimation set the cutoff frequency at 1/M. This allows for some
% aliasing to be introduced. However, this aliasing occurs in the
% transition region of the filter only, a region in which the signal is
% being distorted anyway.
M = 1/Fc;
fm = fdesign.decimator(M,'nyquist');
setspecs(fm,M,TW,Ast);
Hmfirpoly = design(fm,'multistage','HalfbandDesignMethod','equiripple')
%%
% A way of obtaining efficient FIR designs is through the use of
% multirate multistage techniques. This design results in four FIR halfband
% filters in cascade. Halfband filters are extremely efficient because
% every other coefficient is zero.
cost(Hmfirpoly)
%%
% This method achieves computational costs lower than that of a direct-form
% II, second-order sections IIR elliptic filter since it requires only
% 23.8125 MPIS on average compared to 38 MPIS for the classic elliptic IIR
% design.
%%
% "Modern" IIR designs can take advantage of the same sort of "tricks" we
% can play with FIR filters resulting in extremely efficient designs. 
Hiirpoly = design(f,'ellip','FilterStructure','cascadeallpass')
%%
% The polyphase elliptic implementation is composed of two allpass IIR
% subfilters. Notice that this design does take advantage of multirate
% techniques. 
cost(Hiirpoly)
%%
% The cost of this structure is only 18 MPIS. Although single-rate, this
% structure has already a lower cost than the multistage multirate FIR
% filter.

%% Dyadic Halfband Designs
% Because the specified cutoff frequency of the filter is the inverse of a
% power of two, we can use multirate multistage techniques based on IIR
% halfband filters as we previously did in the FIR case.
%%
Hmiirpoly = design(fm,'multistage','HalfbandDesignMethod','ellip')
%%
% This latest design results in four IIR halfband filters in cascade.
cost(Hmiirpoly)
%%
% The multirate multistage design reaches an incredibly low 2.5 MPIS.
% Starting with the classic optimal elliptic design that required 38 MPIS,
% we were able to first reduce the computational cost to 18 MPIS by using a
% single-rate combination of cascade-allpass subfilters and then to only
% 2.5 MPIS by fully leveraging the benefits of multirate halfband IIR
% filters.
%%
% If we overlay the magnitude responses of the FIR and IIR
% multirate multistages filters, the two filters look very similar and both
% meet the specifications. 
hfvt = fvtool(Hmfirpoly,Hmiirpoly,'Color','white');
legend(hfvt, 'Multirate/Multistage FIR Polyphase', ...
    'Multirate/Multistage IIR Polyphase')
fvtool(Hmfirpoly,Hmiirpoly,'Color','white');
title('Passband Magnitude Response (dB)')
axis([0 0.0677 -0.0016 0.0016])
%%
% Close inspection actually shows the passband ripples of the IIR filter to
% be far superior to that of the FIR filter. So computational cost savings
% don't come at the price of a degraded magnitude response.

%% Quasi-Linear Phase Halfband and Dyadic Halfband Designs
% By modifying the structure used to implement each IIR halfband filter, it
% is possible to achieve almost linear phase designs using IIR filters.
% This comes at the expense of a slight increase in computational cost due
% to the constrain on the phase (reduction in the degrees of freedom in the
% design). 
f = fdesign.decimator(8,'nyquist'); 
Hmfirlin = design(f,'multistage','HalfbandDesignMethod','equiripple');
Hmiirlin = design(f,'multistage','HalfbandDesignMethod','iirlinphase');

hfvt = fvtool(Hmfirlin,Hmiirlin,'Color','white','Analysis','grpdelay');
axis([0 1/8 85 125])
title('Passband Group delay')
legend(hfvt, 'Linear-Phase FIR', 'Quasi-Linear Phase IIR')
%%
% Nevertheless, these designs achieve very good phase characteristics and
% are still more efficient than comparable trully linear phase FIR halfband
% designs.
cost(Hmfirlin)
%%
cost(Hmiirlin)

%% Fixed-Point Robustness
% Polyphase IIR filters can be implemented in different ways. We have
% already encountered single-rate and multirate cascade allpass in previous
% sections. Now take a Hilbert transformer for example. A quasi
% linear-phase IIR Hilbert filter with a transition width of 0.02*pi
% rad/sample and a maximum passband ripple of 0.1 dB can be implemented as
% a cascade wave digital filter using only 10 MPIS compared to 133 MPIS for
% an FIR equivalent:
fhilb = fdesign.hilbert('TW,Ap',0.02,.1);
Hhilb = design(fhilb,'iirlinphase','FilterStructure','cascadewdfallpass')
%%
% Wave digital filters have been proven to be very robust even when poles
% are close to the unit circle. They are inherently stable, have low
% roundoff noise properties and are free of limit cycles. To convert our
% IIR Hilbert filter to a fixed-point representation, we can use the
% realizemdl command and the Fixed-Point Tool to do the floating-point to
% fixed-point conversion of the Simulink model:
realizemdl(Hhilb)

%% Summary
% IIR filters have traditionally been considered much more efficient than
% their FIR counterparts in the sense that they require a much smaller
% number of coefficients in order to meet a given set of specifications.
%
% Modern FIR filter design tools utilizing multirate/polyphase techniques
% have bridged the gap while providing linear-phase response along with
% good sensitivity to quantization effects and the absence of stability and
% limit cycles problems when implemented in fixed-point.
%
% However, IIR polyphase filters enjoy most of the advantages that FIR
% filters have and require a very small number of multipliers to implement. 


displayEndOfDemoMessage(mfilename)

