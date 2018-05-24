%% Audio Weighting Filters
% This example shows how to obtain designs for the most common weighting
% filters - A-weighting, C-weighting, C-message, ITU-T 0.41, and ITU-R
% 468-4 - using the audio weighting filter designer,
% fdesign.audioweighting, in the DSP System Toolbox(TM).
%
% In many applications involving acoustic measurements, the final sensor is
% the human ear. For this reason, acoustic measurements usually attempt to
% describe the subjective perception of a sound by this organ.
% Instrumentation devices are built to provide a linear response, but the
% ear is a nonlinear sensor. Therefore, special filters, known as weighting
% filters, are used to account for the nonlinearities.

% Copyright 2009-2013 The MathWorks, Inc.

%% A and C Weighting (ANSI(R) S1.42 standard)
%
% You can design A and C weighting filters that follow the ANSI S1.42 [1]
% and IEC 61672-1 [2] standards. An A-weighting filter is a band pass
% filter designed to simulate the loudness of low-level tones. An
% A-weighting filter progressively de-emphasizes frequencies below 500 Hz.
% A C-weighting filter removes sounds outside the audio range of 20 Hz to
% 20 kHz and simulates the loudness perception of high-level tones.
%
% The ANSI S1.42 standard requires that the filter magnitudes fall within a
% specified tolerance mask. The standard defines two masks, one with
% stricter tolerance values than the other. A filter that meets the
% tolerance specifications of the stricter mask is referred to as a Class 1
% filter. A filter that meets the specifications of the less strict mask is
% referred to as a Class 2 filter. You define the type of class you want in
% your design by setting the Class property to 1 or 2. The choice of the
% Class value will not affect the filter design itself but it will be used
% to render the correct tolerance mask in FVTOOL.
%
% A and C-weighting filter designs are based on direct implementation of
% the filter's transfer function based on poles and zeros specified in the
% ANSI S1.42 standard. The filters only have one design method referred to
% as 'ansis142'.
%
% The following code obtains an IIR Class 1 filter design for A-weighting
% with a sampling rate of 48 kHz.

h = fdesign.audioweighting('WT,Class','A',1,48e3)
%%
Ha = design(h,'ansis142','SystemObject',true);
hfvt = fvtool(Ha);
legend(hfvt, 'A-weighting')

%% 
% The A and C weighting standards specify tolerance magnitude values for up
% to 20 kHz. In the following example we use a sampling frequency of 28 kHz
% and design a C-weighting filter. Even though the Nyquist interval for
% this sampling frequency is below the maximum specified 20 kHz frequency,
% the design still meets the Class 2 tolerances. The design, however, does
% not meet Class 1 tolerances due to the small sampling frequency value.

h = fdesign.audioweighting('WT,Class','C',2,28e3);
Hcclass2 = design(h,'SystemObject',true);
setfilter(hfvt,Hcclass2);
legend(hfvt, 'C-weighting, Class 2')

%% ITU-R 468-4 Weighting Filter
%
% ITU-R 468-4 recommendation [3] was developed to better reflect the
% subjective loudness of all types of noise, as opposed to tones. ITU-R
% 468-4 weighting was designed to maximize its response to the types of
% impulsive noise often coupled into audio cables as they pass through
% telephone switching facilities. ITU-R 468-4 weighting correlates well
% with noise perception, since perception studies have shown that
% frequencies between 1 kHz and 9 kHz are more "annoying" than indicated by
% A-weighting.
%
% You design a weighting filter based on the ITU-R 468-4 standard for a
% sampling frequency of 80 kHz using the following code. You can choose
% from frequency sampling or equiripple FIR approximations, or from a least
% P-norm IIR approximation. In all cases, the filters are designed with the
% minimum order that meets the standard specifications (mask) for the
% sampling frequency at hand.

h = fdesign.audioweighting('WT','ITUR4684',80e3)
%%
Hitur1 = design(h,'allfir','SystemObject',true);
setfilter(hfvt,Hitur1{1});
addfilter(hfvt,Hitur1{2});
legend(hfvt,'ITU-R 468-4 FIR equiripple approximation', ...
    'ITU-R 468-4 FIR frequency sampling approximation')

%%
Hitur2 = design(h,'iirlpnorm','SystemObject',true);
setfilter(hfvt,Hitur2);
legend(hfvt,'ITU-R 468-4 IIR least P-norm approximation')

%%
% While IIR designs yield smaller filter orders, FIR designs have the
% advantage of having a linear phase. In the FIR designs, the equiripple
% design method will usually yield lower filter orders when compared to the
% frequency sampling method but might have more convergence issues at large
% sampling frequencies.

%% ITU-T 0.41 and C-message Weighting Filters
%
% ITU-T 0.41 and C-message weighting filters are band pass filters used to
% measure audio-frequency noise on telephone circuits. The ITU-T 0.41
% filter is used for international telephone circuits. The C-message filter
% is typically used for North American telephone circuits. The frequency
% response of the ITU-T 0.41 and C-message weighting filters is specified
% in the ITU-T O.41 standard [4] and Bell System Technical Reference 41009
% [5], respectively.
%
% You design an ITU-T 0.41 weighting filter for a sampling frequency of 24
% kHz using the following code. You can choose from FIR frequency sampling
% or equiripple approximations. The filters are designed with the minimum
% order that meets the standard specifications (mask) for the sampling
% frequency at hand.

h = fdesign.audioweighting('WT','ITUT041',24e3);
Hitut = design(h,'allfir','SystemObject',true);
setfilter(hfvt,Hitut{1});
addfilter(hfvt,Hitut{2});
legend(hfvt,'ITU-T 0.41 FIR equiripple approximation', ...
    'ITU-T 0.41 FIR frequency sampling approximation')

%%
% You design a C-message weighting filter for a sampling frequency of 51.2
% kHz using the following code. You can choose from FIR frequency sampling
% or equiripple approximations or from an exact IIR implementation of poles
% and zeros based on the poles and zeros specified in [6]. You obtain the
% IIR design by selecting the 'bell41009' design method. The FIR filter
% approximations are designed with the minimum order that meets the
% standard specifications (mask) for the sampling frequency at hand.

h = fdesign.audioweighting('WT','Cmessage',51.2e3);
Hcmessage1 = design(h,'allfir','SystemObject',true);
setfilter(hfvt,Hcmessage1{1});
addfilter(hfvt,Hcmessage1{2});
legend(hfvt,'C-message FIR equiripple approximation', ...
    'C-message FIR frequency sampling approximation')

%%
Hcmessage2 = design(h,'bell41009','SystemObject',true);
setfilter(hfvt,Hcmessage2);
legend(hfvt,'C-message weighting (IIR)')

%% Conclusions
% 
% We have presented the design of A, C, C-message, ITU-T 0.41, and ITU-R
% 468-4 weighting filters. Some of the audio weighting standards do not
% specify exact pole/zero values, instead, they specify a list of frequency
% values, magnitudes and tolerances. If the exact poles and zeros are not
% specified in the standard, filters are designed using frequency sampling,
% equiripple, and/or IIR least P-norm arbitrary magnitude approximations
% based on the aforementioned list of frequency values, attenuations, and
% tolerances. The filter order of the arbitrary magnitude designs is chosen
% as the minimum order for which the resulting filter response is within
% the tolerance mask limits. Designs target the specification mask
% tolerances only within the Nyquist interval. If Fs/2 is smaller than the
% largest mask frequency value specified by the standard, the design
% algorithm will try to meet the specifications up to Fs/2.
%
% In the FIR designs, the equiripple design method will usually yield lower
% filter orders when compared to the frequency sampling method but might
% have more convergence issues at large sampling frequencies.

%% References
%
% [1] 'Design Response of Weighting Networks for Acoustical Measurements',
%     American National Standard, ANSI S1.42-2001.
%
% [2] 'Electroacoustics Sound Level Meters Part 1: Specifications', IEC
% 61672-1,
%     First Edition 2002-05.
%
% [3] 'Measurement of Audio-Frequency Noise Voltage Level in Sound
% Broadcasting',
%     Recommendation ITU-R BS.468-4 (1970-1974-1978-1982-1986).
%
% [4] 'Specifications for Measuring Equipment for the Measurement of
% Analogue
%     Parameters, Psophometer for Use on Telephone-Type Circuits', ITU-T
%     Recommendation 0.41.
%
% [5] 'Transmission Parameters Affecting Voiceband Data
% Transmission-Measuring
%     Techniques', Bell System Technical Reference, PUB 41009, 1972.
%
% [6] 'IEEE(R) Standard Equipment Requirements and Measurement Techniques
% for
%     Analog Transmission Parameters for Telecommunications', IEEE Std
%     743-1995 Volume , Issue , 25, September 1996.

displayEndOfDemoMessage(mfilename)