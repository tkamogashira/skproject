%% Pulse Shaping Filter Design
% This example shows how to design pulse shaping filters. Pulse shaping
% filters are used at the heart of many modern data transmission systems
% (e.g. mobile phones, HDTV) to keep a signal in an allotted bandwidth,
% maximize its data transmission rate, and minimize transmission errors.
% Raised cosine filters form a well-established solution to this filter
% design problem. In this example, we review why and explore less
% known alternatives that provide significant implementation cost savings.

%   Copyright 2007-2012 The MathWorks, Inc.

%% Ideal Pulse Shaping Filter 
% The ideal pulse shaping filter has two properties: 
%
% * A high stopband attenuation to reduce the interchannel interference as
% much as possible. 
%
% * Minimized intersymbol interferences (ISI) to achieve a bit error rate
% as low as possible. The first Nyquist criterion states that in order to
% achieve a ISI-free transmission, the impulse response of the shaping
% filter should have zero crossings at multiples of the symbol period. 
%
% A time-domain sinc pulse meets these requirements since its frequency
% response is a brick wall but this filter is not realizeable. We can
% however approximate it by sampling the impulse response of the ideal
% continuous filter. The sampling rate must be at least twice the symbol
% rate of the message to transmit. That is, the filter must interpolate the
% data by at least a factor of two and often more to simplify the analog
% circuitry.
%
% In its simplest system configuration, a pulse shaping interpolator at
% the transmitter is associated with a simple downsampler at the receiver.
%
% <<ShapingFilter1.png>> 

Hrxd = mfilt.firdecim(8,1); % Downsampler

%% Raised Cosine Filter Design
% A raised cosine filter is typically used to shape and oversample a symbol
% stream before modulation/transmission. The rolloff factor, R, determines
% the width of the transition band. Practical digital communication systems
% use a rolloff factor between 0.1 and 0.5. A minimum stopband attenuation
% of 60 to 80 dB is also desirable to suppress interchannel interference.
% In this example, we work with an oversampling or interpolation factor of
% 8. The filter specifications are given below.

L = 8;                  % Interpolation factor
R = 0.25;               % Roll-off factor
Ast = 60;               % Minimum stopband attenuation 
f = fdesign.interpolator(L,'Raised Cosine',L,'Ast,Beta',Ast,R);
Htxrc = design(f,'window');
order(Htxrc)

%%
% The raised-cosine filter designed above is obtained by truncating the
% analytical impulse response and it is not optimal in any sense. In fact,
% a filter order as high as 272 is necessary to attain a minimum stopband
% attenuation of 60 dB.

%% FIR Nyquist Filter Design
% Nyquist filters can replace raised cosine filters for a fraction of the
% cost because they have an optimal equiripple response. The same stopband
% attenuation and transition width can be obtained with a much lower order.
% The transition width requirement can be deduced from the roll-off and
% interpolation factors, as follows:
TW = R/(L/2);          % Transition Bandwidth 
d = fdesign.interpolator(L,'nyquist',L,'TW,Ast',TW,Ast);
Htxnyq = design(d,'equiripple');
%%
% The magnitude response of this filter and the raised cosine filter above
% have the same transition width and minimum stopband attenuation but the
% filter order of the equiripple Nyquist design has been reduced to 106.
order(Htxnyq)

%% Multistage Halfband Filter Design
% An even more efficient design is obtained by cascading 3 halfband
% filters. The main advantage of multistage over single stage designs is
% that longer (i.e. more expensive) filters can be operated at lower sample
% rates while shorter filters are operated at higher sample rates. Halfband
% filters can be designed using FIR and IIR design techniques. 
d.Astop = 65;
Htxhbfir = design(d,'multistage',...
    'HalfBandDesignMethod','equiripple','Nstages',3);
%%
% FIR designs have an additional advantage in that every other coefficient
% is equal to zero. IIR designs can achieve quasi-linear phase and they
% offer a greater cost savings while achieving extremely low passband
% ripples.
Htxhbiir = design(d,'multistage',...
    'HalfBandDesignMethod','iirlinphase','Nstages',3);

%% Performance and Cost Analysis
% The magnitude response of the four designs described above shows minimum
% stopband attenuation over 60 dB which reduces the interchannel
% interference to satisfactory levels. 
Hrc1 = cascade(Htxrc,Hrxd);
Hnyq1 = cascade(Htxnyq,Hrxd);
Hhbfir1 = cascade(Htxhbfir,Hrxd);
Hhbiir1 = cascade(Htxhbiir,Hrxd);
hfvt = fvtool([Hrc1,Hnyq1,Hhbfir1,Hhbiir1], ...
    'NormalizeMagnitudeto1','on','Color','white');
legend(hfvt,'Raised Cosine','FIR Nyquist',' Multistage FIR Halfband',...
    'Multistage IIR Linear Phase Halfband');
%%
% Additionally, the bit error rate (BER) introduced by the four design is
% very similar. The function <matlab:edit('pulseshapedemogetBER.m')
% pulseshapedemogetBER.m> measures the BER. It assumes a 16-QAM modulation
% scheme and an additive white Gaussian noise channel. Notice that it
% requires Communications System Toolbox(TM) functions to run.
%%
%  ------------------------------------------------------------------------
%                           Bit Error Rate (BER)                          
%  ------------------------------------------------------------------------
%                        10-dB SNR      15-dB SNR     20-dB SNR   
%  Raised Cosine            0.0542         0.0035             0
%  FIR-Nyquist              0.0550         0.0037             0
%  FIR-Halfband             0.0549         0.0038             0
%  IIR-Halfband             0.0591         0.0045             0
%
% While the performance of the four designs is almost identical, their
% implementation cost varies greatly, as show in the table below.
C1 = cost(Hrc1);
C2 = cost(Hnyq1);
C3 = cost(Hhbfir1);
C4 = cost(Hhbiir1);
%%
%  ------------------------------------------------------------------------
%                      Implementation Cost Comparison                     
%  ------------------------------------------------------------------------
%                 Multipliers         Adders  Mult/InSample   Add/InSample 
%  Raised Cosine          272            265            272            265
%  FIR-Nyquist             94             87             94             87
%  FIR-Halfband            32             29             60             53
%  IIR-Halfband            12             24             22             44
%%
% As can be seen, alternatives to the raised cosine filter provide
% significant savings both in terms of hardware and operations per sample.
% They range from over 60% savings for the FIR Nyquist design to about 80%
% savings for the multistage FIR halfband design and 90% for the multistage
% IIR halfband design.

%% Using a Matched Filter at the Receiver
% Sometimes the filtering is split between the transmitter and receiver.
% The data stream is upsampled and filtered at the transmitter and then the
% transmitted signal is filtered and downsampled by a matched filter at the
% receiver. This approach is very popular because, for a given processing
% power, using two square root raised cosine filters (one in the
% transmitter and one in the receiver) provides better stopband attenuation
% than using a raised cosine filter in the transmitter and a downsampler in
% the receiver. 
%
% <<ShapingFilter2.png>> 

%% SQRT Raised Cosine Filter Design
% In theory, the cascade of two square root raised cosine filters is
% equivalent to a single normal raised cosine filter. However, the limited
% impulse response of practical square root raised cosine filters causes a
% slight difference between the responses of two cascaded square root
% raised cosine filters and of one raised cosine filter.
f1 = fdesign.interpolator(L,'Square Root Raised Cosine',L,'N,Beta',56,R);
f2 = fdesign.decimator(L,'Square Root Raised Cosine',L,'N,Beta',56,R);
Htxsqrc = design(f1,'window');  % Tx Filter
Hrxsqrc = design(f2,'window');  % Rx Filter
Hrc2 = cascade(Htxsqrc,Hrxsqrc);

%% Minimum Phase FIR Halfband Design
% Minimum phase FIR halfband filters can be substituted for square root
% raised cosine filters.  
d3 = fdesign.interpolator(2,'halfband','N,TW',15,0.25);
Hhb1min = design(d3,'equiripple','MinPhase',true);

setspecs(d3,'N,TW',7,0.5);
Hhb2min = design(d3,'equiripple','MinPhase',true);

setspecs(d3,'N,TW',3,0.78);
Hhb3min = design(d3,'equiripple','MinPhase',true);
%%
% In such a case, a minimum phase Nyquist filter is used at the transmiter
% while its maximum phase counterpart is used for filtering at the
% receiver. 
Htxmin = cascade(Hhb1min,Hhb2min,Hhb3min); % Tx Filter
Hhb1max = mfilt.firdecim(2,fliplr(Hhb1min.Numerator/2));
Hhb2max = mfilt.firdecim(2,fliplr(Hhb2min.Numerator/2));
Hhb3max = mfilt.firdecim(2,fliplr(Hhb3min.Numerator/2));
Hrxmax = cascade(Hhb3max,Hhb2max,Hhb1max); % Rx Filter
%%
% The convolution of the minimum phase and maximum phase filters produces a
% Nyquist filter.
Hhbfir2 = cascade(Htxmin,Hrxmax);

%% Performance Analysis and Cost Analysis
% The following code verifies that the cascaded filters provide a total
% stopband attenuation of 60 dB.
set(hfvt,'Filters',[Hrc2,Hhbfir2]);
legend(hfvt,'SQRT Raised Cosine','Multistage FIR Halfband');
%%
% Additionally, using a matched filter instead of a downsampler at the
% receiver improves the BER substantially for relatively low SNRs. The
% results in the table below were measured using the function
% <matlab:edit('pulseshapedemogetBER.m') pulseshapedemogetBER.m>.
%%
%  ------------------------------------------------------------------------
%                           Bit Error Rate (BER)                          
%  ------------------------------------------------------------------------
%                        10-dB SNR      15-dB SNR     20-dB SNR   
%  SQRT Raised Cosine    4.100e-05      3.333e-06     6.667e-06
%  Matched FIR-Halfband  2.000e-05              0             0
%% 
% For the implementation cost, a multistage minimum and maximum phase
% FIR halfband design provides over 50% savings compared to the square root
% raised cosine design:
C5 = cost(Hrc2);
C6 = cost(Hhbfir2);
%%
%  ------------------------------------------------------------------------
%                      Implementation Cost Comparison                     
%  ------------------------------------------------------------------------
%                       Multipliers  Adders  Mult/InSample  Add/InSample  
%  SQRT Raised Cosine           114     105            114           105
%  Matched FIR-Halfband          56      47             54            39.12

%% Summary
% Raised cosine and square root raised cosine filters are widely used in
% data transmission systems. Despite their popularity, we have shown in
% this example that they are not optimal in any sense. In many applications
% they could be advantageously replaced by alternative designs that are
% more cost efficient.

%% Appendix
% The following helper functions are used in this example.
%
% * <matlab:edit('pulseshapedemogetBER.m') pulseshapedemogetBER.m>

displayEndOfDemoMessage(mfilename)
