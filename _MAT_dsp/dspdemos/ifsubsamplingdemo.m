%% IF Subsampling with Complex Multirate Filters
% This example shows how to use complex multirate filters in the
% implementation of Digital Down-Converters (DDC). The DDC is a key
% component of digital radios. It performs the frequency translation
% necessary to convert the high input sample rates typically found at the
% output of an analog-to-digital (A/D) converter down to lower sample rates
% for further and easier processing. In this example, we will see how an
% audio signal modulated with a 450 kHz carrier frequency can be brought
% down to a 20 kHz sampling frequency. After a brief review of the
% conventional DDC architecture, we will describe an alternative solution
% known as Intermediate Frequency (IF) subsampling and we will compare the
% respective implementation cost of these two solutions. This example
% requires a Fixed-Point Designer(TM) license.

%   Copyright 2007-2012 The MathWorks, Inc.

%% Conventional Digital Down Converter
% A conventional down conversion process starts with sampling the analog
% signal at a rate that satisfies the Nyquist criterion for the carrier. A
% possible option would be to sample the 450 kHz input signal at 2.0 MHz,
% then using a digital down converter to perform complex translation to
% baseband, filter and down sample by 25 with a Cascaded Integrator-Comb
% (CIC) filter, and then down sample by 4 with a pair of half band filters.
% Such an implementation is shown below:
%
% <<ddc1.png>>
%%
% CIC Filter Design
%%
% The first filter of the conventional DDC is usually a CIC filter. CIC
% filters are efficient, multiplier-less structures which are used in
% high-decimation or interpolation systems. In our case it will bring the
% 2 MHz signal down to 2.0 MHz/25 = 80 kHz.
Fs_cddc = 2e6;          % Sampling frequency
R       = 25;           % Decimation factor
Fpass   = 10e3;         % Passband Frequency
Astop   = 60;           % Aliasing Attenuation(dB)
D       = 1;            % Differential delay
dcic = fdesign.decimator(R,'cic',D,Fpass,Astop,Fs_cddc);
hcic = design(dcic);
hgain = dfilt.scalar(1/gain(hcic)); % Normalize gain of CIC filter
hcicnorm = cascade(hgain,hcic);
%%
% Compensation FIR Decimator Design
%%
% The second filter of the conventional DDC compensates for the passband
% droop caused by the CIC. Since the CIC has a sinc-like response, it can
% be compensated for the droop with a lowpass filter that has an
% inverse-sinc response in the passband.
Nsecs = hcic.NumberOfSections; % NumberOfSections
Fpass  = 10e3;                 % Passband Frequency
Fstop  = 25e3;                 % Stopband Frequency
Apass  = 0.01;                 % Passband Ripple (dB)
Astop  = 80;                   % Stopband Attenuation (dB)
dcp = fdesign.decimator(2,'ciccomp',...
    D,Nsecs,Fpass,Fstop,Apass,Astop,dcic.Fs_out);
hcfir = design(dcp,'equiripple',...
    'StopBandShape','linear','StopBandDecay',60);
%%
% Halfband Filter Design
%%
% We finally use a 20th order halfband filter to bring the 40 kHz signal
% down to 20 kHz.
dhb = fdesign.decimator(2,'halfband','N',20,dcp.Fs_out);
hb = design(dhb);
%%
% The conventional DCC filter is obtained by cascading the three stages
% previously designed.
Hcddc = cascade(hcicnorm,hcfir,hb);

%% IF Subsampling
% Since the carrier frequency is discarded as part of the signal
% extraction, there is no need to preserve it during the data-sampling
% process. The Nyquist criterion for the carrier can actually be violated
% as long as Nyquist criterion for the bandwidth of complex envelope is
% satisfied. 
%
% This narrowband interpretation of the Nyquist criterion leads to an
% alternate data collection process known as IF subsampling. In this
% process, the A/D converter's sample rate is selected to be less than the
% signal's center frequency to intentionally alias the center frequency.
% Since Nyquist criterion is being intentionally violated, the analog
% signal must be conditioned to prevent multiple frequency intervals from
% aliasing to the same frequency location as the desired signal component
% will alias.
%
% The variable y represents approximately 3 sec of an audio signal
% modulated with a 450 kHz carrier frequency. The discrete signal ys
% represents the output of a 120 kHz A/D converter.
[y, ys, Fs] = loadadcio;
Fs_addc = 1.2e5;   % Sampling frequency

[Hys, Fys] = periodogram(ys,[],[],Fs,'power','centered');
N = length(Fys);

figure('color','white')
periodogram(y,[],[],Fs,'power','centered');
clear y;
hold on;
hl=plot((-(ceil(N/2*9)-1):floor(N/2*9))/N*Fs_addc/1000, ...
        repmat(10*log10(Hys),9,1),'r:');
axis([-50 500 -160 0])
legend('Input of A/D Converter','Aliased Output of A/D Converter',...
    'Location','NorthEast');

  
%%
% The frequency band around 450 kHz aliased around -30 kHz. Aliasing to a
% quarter of the sampling frequency maximizes the separation between
% positive and negative frequency aliases. This permits maximum transition
% bandwidth for the analog bandpass filter and therefore minimize its cost.
%%
% The choice of a 120 kHz sampling frequency also eases the subsequent task
% of down converting to 20 kHz which is accomplished by down sampling by a
% factor of 6. The down conversion can be achieved in two stages. First a
% 3-to-1 downsampling is performed by a complex bandpass filter followed by
% a 2-to-1 conversion with a half band filter. The structure of this
% aliasing DDC is shown below.
%
% <<ddc2.png>>
%%
% Complex Bandpass Filter Design
%%
% To obtain a complex bandpass filter, we translate a lowpass decimator
% prototype to quarter sample rate by multiplying the filter coefficients
% with the heterodyne terms exp(-j*pi/2*n). Notice that while the
% coefficients of the lowpass filter are real, the coefficients of the
% translated filter are complex. The figure below depicts the magnitude
% responses of these filters.
M = 3;               % Decimation Factor
TW   = Fstop-Fpass;  % Transition Width (Hz)
dlow = fdesign.decimator(M,'nyquist',M,TW,Astop,Fs_addc);
hlow = design(dlow); % Lowpass prototype
n = 0:length(hlow.Numerator)-1;
hcbp = mfilt.firdecim(M,hlow.Numerator.*exp(-1i*pi/2*n));
hfvt = fvtool(hlow,hcbp,'Fs',Fs_addc,'Color','White');
legend(hfvt,'Lowpass Decimator','Complex Bandpass Decimator', ...
    'Location','NorthEast')
%%
% We now apply the complex bandpass decimator to the output of A/D
% converter. It can be shown that a signal at a quarter sample-rate will
% always alias to a multiple of the quarter sample-rate under decimation by
% any integer factor. In our example the -30 kHz centered signal will alias
% to 40/4 = 10 kHz.
ycbp = filter(hcbp,ys);
figure('color','white')
periodogram(ycbp,[],[],dlow.Fs_out,'power','centered');
legend('Output of Complex Bandpass Decimator')
%%
% The output sequence ycbp is then heterodyned to zero.
yht = ycbp.*(-1i).^(0:length(ycbp)-1).';
figure('color','white')
periodogram(yht,[],[],dlow.Fs_out,'power','centered');
legend('Heterodyned Sequence')
%%
% Finally the heterodyned sequence is passed as input to the half band
% filter and decimated by 2. We can reuse the same halfband filter as in
% the conventional DCC. 
yf = filter(hb,yht);
figure('color','white')
periodogram(yf,[],[],dhb.Fs_out,'power','centered');
legend('Output of Aliasing DDC')
%% 
% Play the audio signal at the output of the "aliasing" DDC. (Copyright
% 2002 FingerBomb)
p = audioplayer(yf,dhb.Fs_out);
play(p)

%% Implementation Cost Comparison 
% Before we proceed to the cost analysis let's verify that the magnitude
% responses of the filters in the two DDC solutions are comparable. We
% exclude both the complex translation to baseband in the conventional DDC
% case and the heterodyne in the IF subsampling case. Furthermore, we use
% the lowpass prototype decimator in the later case since it has the same
% transition width, passband ripples and stopband attenuation as the
% complex band pass decimator.
Haddc = cascade(hlow,hb);
%%
% We verify that the filters used in both cases have very similar magnitude
% responses: less that 0.04 dB passband ripple, a 6dB cutoff frequency of
% 10 kHz and a 55 dB stopband attenuation at 13.4 kHz. It is therefore fair
% to proceed to the cost analysis.
set(hfvt, ...
    'Filters',[Hcddc,Haddc],'FrequencyRange','Specify freq. vector', ...
    'FrequencyVector',linspace(0,100e3,2048),'Fs',[Fs_cddc Fs_addc], ...
    'ShowReference','off','Color','White');
legend(hfvt,'Conventional DDC Filter', ...
    'Equivalent Digital IF Subsampling Filter',...
    'Location','NorthEast');
%%
% In the case of the conventional DDC, we must first take into account the
% cost of the baseband translation. We are assuming it is done with only
% one multiplier working at 2 MHz. We must then add the cost of the CIC and
% halfband filters. In the IF subsampling case, we must consider the cost
% of the heterodyne. We are assuming it is done with only one multiplier
% working at 40 kHz. We must then add the cost of the complex bandpass and
% halfband filters.

c_cddc = cost(Hcddc);            % Cost of CIC and halfband filters
c_addc = cost(cascade(hcbp,hb)); % Cost of complex bandpass
                                 % and halfband filters
ddccostcomp(Fs_cddc,c_cddc,Fs_addc,c_addc)

%%
% The number of multipliers, adders and states required in the IF
% subsampling case is comparable to that of conventional DDC but the number
% of operations per second is significantly reduced since it saves 71% of
% the number of multiplications per second and 85% of the number of
% additions per second.

%% Summary
% This example showed how complex multirate filters can be used when
% designing IF subsampling-based digital down converters. The IF
% subsampling technique can be cost efficient alternative to conventional
% DDCs in many applications. For more information on IF subsampling see
% Multirate Signal Processing for Communication Systems by fredric j
% harris, Prentice Hall, 2004.

displayEndOfDemoMessage(mfilename)

