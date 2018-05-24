%% IIR Filter Design Given a Prescribed Group Delay
% This example shows how to design arbitrary group delay filters using the
% fdesign.arbgrpdelay filter designer. This designer uses a least-Pth
% constrained optimization algorithm to design allpass IIR filters that
% meet a prescribed group delay.
%
% fdesign.arbgrpdelay can be used for group delay equalization.

% Copyright 1999-2012 The MathWorks, Inc.

%% Arbitrary Group Delay Filter Designer
% You can use fdesign.arbgrpdelay to design an allpass filter with a
% desired group delay response. The desired group delay is specified in a
% relative sense. The actual group delay depends on the filter order (the
% higher the order, the higher the delay). However, if you subtract the
% offset in the group delay due to the filter order, the group delay of the
% designed filter tends to match the desired group delay. The following
% code provides an example using two different filter orders.

N = 8;         % Filter order
N2 = 10;       % Alternate filter order
F = [0 0.1 1]; % Frequency vector
Gd = [2 3 1];  % Desired group delay
R = 0.99;      % Pole-radius constraint

%%
% Note that in an allpass filter, the numerator is always the reversed
% version of its denominator. For this reason, you cannot specify different
% numerator and denominator orders in fdesign.arbgrpdelay.

%%
% The following code shows a single band arbitrary group delay design with
% the desired group delay values, Gd, at the specified frequency points, F.
% In single band designs you specify the group delay over frequency values
% that cover the entire Nyquist interval [0 1]*pi rad/sample.
h = fdesign.arbgrpdelay('N,F,Gd',N,F,Gd)

%%
H1 = design(h,'MaxPoleRadius',R, 'SystemObject', true);

% Measure the total group delay at a set of frequency points from 0 to 1.
% Measure the nominal group delay of the filter using the measure method.
Fpoints = 0:0.001:1;
M1 = measure (h,H1,Fpoints);

% Design another filter with an order equal to N2.
h.FilterOrder = N2;
H2 = design(h,'MaxPoleRadius',R, 'SystemObject', true);
M2 = measure(h,H2,Fpoints);

% Plot the measured total group delay minus the nominal group delay.
plot(Fpoints, M1.TotalGroupDelay-M1.NomGrpDelay, 'b',...
     Fpoints, M2.TotalGroupDelay-M2.NomGrpDelay, 'g',...
     [0 0.1 1], [2 3 1], 'r');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Group delay (samples)'); grid on;
legend('8th order design','10th order design','desired response')

%% 
% The following plot shows that the actual group delay of the two designs
% is different. The significance of this result is that one must find a
% compromise between a better fit to the desired relative group delay (less
% ripple) and a larger overall delay in the filter.

hFVT = fvtool(H1,H2,'Analysis', 'grpdelay');
legend(hFVT, '8th order design','10th order design')

%% Passband Group Delay Equalization
% The primary use of fdesign.arbgrpdelay is to compensate for
% nonlinear-phase responses of IIR filters. Since the compensating filter
% is allpass, it can be cascaded with the filter you want to compensate
% without affecting its magnitude response. Since the cascade of the two
% filters is an IIR filter itself, it cannot have linear-phase (while being
% stable). However, it is possible to have approximately a linear phase
% response in the passband of the overall filter.

%% Lowpass Equalization
%
% The following example uses fdesign.arbgrpdelay to equalize the group
% delay response of a lowpass elliptic filter without affecting its
% magnitude response.
%
% You use a multiband design to specify desired group delay values over one
% or more bands of interest while leaving the group delay of all other
% frequency bands unspecified (don't care regions). In this example there
% is only one band of interest which equals the passband of the lowpass
% filter. You want to compensate the group delay in this band, and do not
% care about the resulting group delay values outside of it.

% Design an elliptic filter with a passband frequency of 0.2*pi
% rad/sample. Measure the total group delay over the passband.
Hellip = design(fdesign.lowpass('N,Fp,Ap,Ast',4,0.2,1,40),...
    'ellip', 'SystemObject', true);
wncomp = 0:0.001:0.2; 
g = grpdelay(Hellip,wncomp,2); % samples
g1 = max(g)-g;

% Design an 8th order arbitrary group delay allpass filter. Use a
% multiband design and specify a single band.
hgd = fdesign.arbgrpdelay('N,B,F,Gd',8,1,wncomp,g1)
Hgd = design(hgd,'iirlpnorm', 'SystemObject', true);

%%
% Cascade the original filter with the compensation filter to achieve the 
% desired group delay equalization. 
% Verify by processing white noise and estimating the group delay at the 
% two output stages
samplesPerFrame = 2048;
wn = (2/samplesPerFrame) * (0:samplesPerFrame-1);
numRealPoints = samplesPerFrame/2 + 1;
htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
      'SpectralAverages',64);
hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[0 40],...
      'YLabel','Group Delay (samples)',...
      'XLabel','Normalized Frequency (x pi rad/sample)',...
      'SampleIncrement',2/samplesPerFrame,...
      'Title',['Original (1), Compensated (2), ',...
      'Expected Compensated (3)'], 'ShowLegend', true);

gdOrig = grpdelay(Hellip, numRealPoints);
gdComp = grpdelay(Hgd, numRealPoints);
range = wn < wncomp(end);
gdExp = nan(numRealPoints, 1); 
gdExp(range) = gdOrig(range) + gdComp(range);

% Stream random samples through filter cascade
Nframes = 300;
for k = 1:Nframes
    x = randn(samplesPerFrame,1);  % Input signal = white Gaussian noise
    
    y_orig = step(Hellip,x);       % Filter noise with original IIR filter
    y_corr = step(Hgd,y_orig);     % Compensating filter
    
    Txy = step(htfe,[x, x],[y_orig, y_corr]);
    gdMeas = HelperMeasureGroupDelay(Txy, [], 20);
    step(hplot, [gdMeas, gdExp]);
end

%% Bandpass Equalization
%
% Design a passband group delay equalizer for a bandpass Chebyshev filter
% with a passband region in the [0.3 0.4]*pi rad/sample interval. As in the
% previous example, there is only one band of interest which corresponds to
% the passband of the filter. Because you want to compensate the group
% delay in this band and do not care about the resulting group delay values
% outside of it, you use a multiband design and specify a single band.

% Design a bandpass Chebyshev type-1 filter and measure its total group
% delay over the passband.
Hcheby1 = design(fdesign.bandpass('N,Fp1,Fp2,Ap',4,0.3,0.4,1),'cheby1', ...
    'SystemObject', true);
wncomp = 0.3:0.001:0.4;
g = grpdelay(Hcheby1,wncomp,2);
g1 = max(g)-g;

% Design an 8th order arbitrary group delay filter. The pole radius is
% constrained to not exceed 0.95.
hgd = fdesign.arbgrpdelay('N,B,F,Gd',8,1,wncomp,g1);
Hgd = design(hgd,'iirlpnorm','MaxPoleRadius',0.95, 'SystemObject', true);

% Cascade the original filter with the compensation filter to achieve the 
% desired group delay equalization. 
% Verify by processing white noise and estimating the group delay at the 
% two output stages
gdOrig = grpdelay(Hcheby1, numRealPoints);
gdComp = grpdelay(Hgd, numRealPoints);
range = wn > wncomp(1) & wn < wncomp(end);
gdExp = nan(numRealPoints,1); gdExp(range) = gdOrig(range) + gdComp(range);

release(hplot), hplot.YLimits = [0 55];
release(htfe)

% Stream random samples through filter cascade
for k = 1:Nframes
    x = randn(samplesPerFrame,1);  % Input signal = white Gaussian noise
    
    y_orig = step(Hcheby1,x);       % Filter noise with original IIR filter
    y_corr = step(Hgd,y_orig);     % Compensating filter
    
    Txy = step(htfe,[x, x],[y_orig, y_corr]);
    gdMeas = HelperMeasureGroupDelay(Txy, [], 20);
    step(hplot, [gdMeas, gdExp]);
end


%%
% The resulting filter has one pair of constrained poles. The group delay
% variation in the passband ([0.3 0.4]*pi rad/sample) is less than 0.2
% samples.

%% Bandstop Equalization
% Design a passband group delay equalizer for a bandstop Chebyshev filter
% operating with a sampling frequency of 1 KHz. The bandstop filter has two
% passband regions  in the [0 150] Hz and [200 500] Hz intervals. You want
% to compensate the group delay in these bands so you use a multiband
% design and specify two bands.

% Design a bandstop Chebyshev type-2 filter and measure its total group
% delay over the passbands. Convert the measured group delay to seconds
% because fdesign.arbgrpdelay expects group delay specifications in seconds
% when you specify a sampling frequency.

Fs = 1e3;
Hcheby2 = design(fdesign.bandstop('N,Fst1,Fst2,Ast',6,150,400,1,Fs), ...
    'cheby2', 'SystemObject', true);
f1 = 0.0:0.5:150; % Hz
g1 = grpdelay(Hcheby2,f1,Fs).'/Fs; % seconds
f2 = 400:0.5:Fs/2; % Hz
g2 = grpdelay(Hcheby2,f2,Fs).'/Fs; % seconds
maxg = max([g1 g2]);

% Design a 14th order arbitrary group delay allpass filter. The pole
% radius is constrained to not exceed 0.95. The group delay specifications
% are given in seconds and the frequency specifications are given in Hertz.

hgd = fdesign.arbgrpdelay('N,B,F,Gd',14,2,f1,maxg-g1,f2,maxg-g2,Fs);
Hgd = design(hgd,'iirlpnorm','MaxPoleRadius',0.95, 'SystemObject', true);

% Cascade the original filter with the compensation filter to process
% white noise and estimate the group delay at the two output stages

gdOrig = grpdelay(Hcheby2, numRealPoints);
gdComp = grpdelay(Hgd, numRealPoints);
fcomp = (Fs/samplesPerFrame) * (0:samplesPerFrame-1);
range = (fcomp>f1(1) & fcomp<f1(end)) | (fcomp>f2(1) & fcomp<f2(end));
gdExp = nan(numRealPoints,1); gdExp(range) = gdOrig(range) + gdComp(range);

release(hplot), 
    hplot.YLimits = [0 40];
    hplot.SampleIncrement = Fs/samplesPerFrame;
    hplot.YLabel = 'Group Delay (samples)';
    hplot.XLabel = 'Frequency (Hz)';
release(htfe)

% Stream random samples through filter cascade
Nframes = 300;
for k = 1:Nframes
    x = randn(samplesPerFrame,1);  % Input signal = white Gaussian noise
    
    y_orig = step(Hcheby2,x);       % Filter noise with original IIR filter
    y_corr = step(Hgd,y_orig);     % Compensating filter
    
    Txy = step(htfe,[x, x],[y_orig, y_corr]);
    gdMeas = HelperMeasureGroupDelay(Txy, [], 12);
    step(hplot, [gdMeas, gdExp]);
end

%%
% The resulting filter has one pair of constrained poles. The passbands
% have a group delay variation of less than 3 samples.

displayEndOfDemoMessage(mfilename)
