%% Complex Bandpass Filter Design
% This example shows how to design complex bandpass filters. Complex
% bandpass filters are used in many applications from IF subsampling
% digital down converters to vestigial sideband modulation schemes for
% analog and digital television broadcast. One easy way to design a complex
% bandpass filter is to start with a lowpass prototype and apply a complex
% shift frequency transformation. In this example, we review several cases
% of lowpass prototypes from single-stage single-rate FIR filters to
% multistage multirate FIR filters to IIR filters.

% Copyright 2007-2012 The MathWorks, Inc.

%% Single-Stage Single-Rate FIR Design
% In the case of a single-rate FIR design, we simply multiply each set of
% coefficients by (aka 'heterodyne with') a complex exponential. In the
% next example, we rotate the zeros of the lowpass Nyquist filter prototype
% by a normalized frequency of .6. 
Hlp = design(fdesign.nyquist(8));     % Lowpass prototype
N = length(Hlp.Numerator)-1;
Fc = .6;                              % Desired frequency shift
j = complex(0,1);
Hbp = copy(Hlp);
Hbp.Numerator = Hbp.Numerator.*exp(j*Fc*pi*(0:N));
hfvt = fvtool(Hlp,Hbp,'Color','white');
legend(hfvt,'Lowpass Prototype','Complex Bandpass','Location','NorthWest')
%%
% The same technique also applies to single-stage multirate filters.

%% Multirate Multistage FIR Design
% In the case of multirate multistage FIR filters, we need to account for
% the different relative frequencies each filter operates on. In the case
% of a multistage *decimator*, the desired frequency shift applies only to
% the *first* stage. Subsequent stages must also scale the desired
% frequency shift by their respective cumulative decimation factor.
f = fdesign.decimator(16,'nyquist',16,'TW,Ast',.01,75);
Hd = design(f,'multistage');
N1 = length(Hd.Stage(1).Numerator)-1;
N2 = length(Hd.Stage(2).Numerator)-1;
N3 = length(Hd.Stage(3).Numerator)-1;
M12 = Hd.Stage(1).DecimationFactor; % Decimation factor between stage 1 & 2
M23 = Hd.Stage(2).DecimationFactor; % Decimation factor between stage 2 & 3
Fc  = -.2;                          % Desired frequency shift 
Fc1 = Fc;                     % Frequency shift applied to the first stage
Fc2 = Fc*M12;                 % Frequency shift applied to the second stage
Fc3 = Fc*M12*M23;             % Frequency shift applied to the third stage
Hdbp = copy(Hd);
Hdbp.Stage(1).Numerator = Hdbp.Stage(1).Numerator.*exp(j*Fc1*pi*(0:N1));
Hdbp.Stage(2).Numerator = Hdbp.Stage(2).Numerator.*exp(j*Fc2*pi*(0:N2));
Hdbp.Stage(3).Numerator = Hdbp.Stage(3).Numerator.*exp(j*Fc3*pi*(0:N3));
set(hfvt,'Filters',[Hd,Hdbp])
legend(hfvt,'Lowpass Prototype','Complex Bandpass','Location','NorthWest')
%%
% Similarly, in the case of a multistage *interpolator*, the desired
% frequency shift applies only to the *last* stage. Previous stages must
% also scale the desired frequency shift by their respective cumulative
% interpolation factor.
f = fdesign.interpolator(16,'nyquist',16,'TW,Ast',.01,75);
Hi = design(f,'multistage');
N1 = length(Hi.Stage(1).Numerator)-1;
N2 = length(Hi.Stage(2).Numerator)-1;
N3 = length(Hi.Stage(3).Numerator)-1;
L12 = Hi.Stage(2).InterpolationFactor; % Interpolation factor
                                       % between stage 1 & 2
L23 = Hi.Stage(3).InterpolationFactor; % Interpolation factor
                                       % between stage 2 & 3
Fc = .4;                               % Desired frequency shift 
Fc3 = Fc;                    % Frequency shift applied to the third stage
Fc2 = Fc*L23;                % Frequency shift applied to the second stage
Fc1 = Fc*L12*L23;            % Frequency shift applied to the first stage
Hibp = copy(Hi);
Hibp.Stage(1).Numerator = Hibp.Stage(1).Numerator.*exp(j*Fc1*pi*(0:N1));
Hibp.Stage(2).Numerator = Hibp.Stage(2).Numerator.*exp(j*Fc2*pi*(0:N2));
Hibp.Stage(3).Numerator = Hibp.Stage(3).Numerator.*exp(j*Fc3*pi*(0:N3));
set(hfvt,'Filters',[Hi,Hibp])
legend(hfvt,'Lowpass Prototype','Complex Bandpass','Location','NorthWest')

%% Single-Rate IIR Design
% Finally in case of single-rate IIR designs, we can either use a complex
% shift frequency transformation or a lowpass to complex bandpass IIR
% transformation. In the latter case, the bandwidth of the bandpass filter
% may also be modified.
Fp = .2;
Hiirlp = design(fdesign.lowpass(Fp,.25,.5,80),'ellip');
Fc  = .6;                         % Desired frequency shift 
Hiircbp = ciirxform(Hiirlp, ...   % Shift frequency transformation
    'zpkshiftc', 0, Fc);          % DC shifted to Fc
Hiircbp2 = iirlp2bpc(Hiirlp, ...  % Lowpass to complex bandpass transf.
    Fp, [Fc-Fp, Fc+Fp]);          % Lowpass passband frequency mapped
                                  % to bandpass passband frequencies       
set(hfvt,'Filters',[Hiirlp,Hiircbp,Hiircbp2])
legend(hfvt,'Lowpass Prototype','Complex Bandpass #1',...
    'Complex Bandpass #2','Location','NorthWest')


displayEndOfDemoMessage(mfilename)


