%% Efficient Sample Rate Conversion between Arbitrary Factors
% This example shows how to efficiently convert sample rates between
% arbitrary factors.
%
% The need for sample rate conversion by an arbitrary factor arises in many
% applications (e.g. symbol synchronization in digital receivers, speech
% coding and synthesis, computer simulation of continuous-time systems,
% etc...). In this example, we will examine an example where cascades of
% polynomial-based and polyphase filters form an efficient solution when it
% is desired to convert the sampling rate of a signal from 8 kHz to
% 44.1 kHz.

% Copyright 2007-2013 The MathWorks, Inc. 

%% Single Stage Polyphase Approach
% Polyphase structures are generally considered efficient implementations
% of multirate filters. However in the case of fractional sample rate
% conversion, the number of phases, and therefore the filter order, can
% quickly become excessively high. To resample a signal from 8 kHz to 44.1
% kHz, we interpolate by 441 and decimate by 80 (8*441/80=44.1).
SRC = dspdemo.SampleRateConverter('Bandwidth',6e3,'SampleRateIn',8e3,...
    'SampleRateOut',44.1e3,'MinimumAliasAttenuation',50);
%%
% This can be done in relatively efficient manner in two stages:
filts = getFilters(SRC);
cost(filts.Stage1)
cost(filts.Stage2)
%%
% Although the number of operations (roughly 95 multiplications and
% additions - keeping in mind that the rate increases after the first stage
% to 14.7 kHz) per input sample is reasonable, 1774 coefficients would have
% to be stored in memory in this case.

%% Single Stage Farrow Approach
% Polynomial-based filters overcome this problem by computing on the fly
% the coefficients that are applied to each input sample. Farrow structures
% are efficient implementations for such filters. To convert a polyphase
% filter to a polynomial-based (a.k.a. Farrow) filter, we simply
% approximate each column of the polyphase decomposition by a low-order
% polynomial. 
L = 441;      % Interpolation factor
M = 80;       % Decimation factor
TW = 1/(L*2); % Transition Width
Astop = 50;   % Minimum stopband attenuation 
f = fdesign.rsrc(L,M,'Nyquist',L,'TW,Ast',TW,Astop);
h1 = design(f,'SystemObject',true);
p=polyphase(h1); % Polyphase decomposition
Np = size(p,2);  % Length of each polyphase filter  
N = 4;           % Polynomial order
X = 0:1/L:(L-1)/L;
for i=1:Np,
    fp(Np-i+1,:)=polyfit(X,p(:,i).',N);
end   
h1far = mfilt.farrowsrc(L,M,fp);
%%
% With 3rd-order polynomials we get only 49 dB a attenuation in the
% stopband. We verify that 4th-order polynomials form a good approximation
% of the original polyphase filter, meeting the specified transition width
% and minimum stopband attenuation. For the analysis of multirate filters,
% we ignore the polyphase implementations and use an
% "upsample-filter-downsample" equivalent model that allow us to attach a
% sampling frequency value for each filter.
W = linspace(0,44.1e3,2048);  % Define the frequency range analysis
Fs1 = 8e3*147;  % The equivalent single stage filter is clocked at 3.528 MHz
hfvt = fvtool(filts.Stage1,h1far,'FrequencyRange',...
    'Specify freq. vector', ...
    'FrequencyVector',W,'Fs',[Fs1 3*Fs1], ...
    'NormalizeMagnitudeto1','on', 'Color', 'white');
legend(hfvt,'Polyphase Sample-Rate Converter','Farrow Interpolator',...
    'Location','NorthEast')
%%
% Let's examine the implementation cost of this filter:
cost(h1far)
%%
% When compared to the cost of the polyphase filter, the number of
% coefficients to store in memory is drastically reduced from 5178 to 64.
% However the number of operations per input sample has increased
% significantly (from 65 to 353 multiplications per sample and from 59 to
% 325 additions per sample). Depending on the application and the hardware
% target, this loss of performance may or may not be acceptable. 

%% Cascade of Farrow and FIR Polyphase Structures
% We now try to design a hybrid solution that would take advantage of the
% two types of filters that we have previously seen. Polyphase filters are
% particularly well adapted for interpolation or decimation by an integer
% factor and for fractional rate conversions when the interpolation and the
% decimation factors are low. Farrow filters can efficiently implement
% arbitrary (including irrational) rate change factors. First, we
% interpolate the original 8 kHz signal by 4 using a cascade of FIR
% halfband filters.
SRC2 = dspdemo.SampleRateConverter('Bandwidth',6e3,'SampleRateIn',8e3,...
    'SampleRateOut',32e3,'MinimumAliasAttenuation',50);
%%
% Then, we interpolate the intermediate 8x4=32 kHz signal by 44.1/32 =
% 1.378125 to get the desired 44.1 kHz final sampling frequency. We use a
% cubic Lagrange polynomial-based filter for this purpose. 
Np = 3;  % Polynomial Order
[L,M]=rat(1.378125); % Interpolation and decimation factors
ffar = fdesign.polysrc(L,M,'Fractional Delay','Np',Np);
hfar = design(ffar,'lagrange');  
%%
% The overall filter is simply obtained by cascading the two filters.
filts2 = getFilters(SRC2);
cost(filts2.Stage1)
cost(filts2.Stage2)
cost(hfar)
%%
% The number of coefficients of this hybrid design is the lowest so far (32
% compared to 64 for the single stage Farrow design and 5178 for the single
% stage polyphase design). Moreover, the number of operations per input
% sample is still around 95, roughly the same as with the single stage
% polyphase design. These numbers make the hybrid design the most efficient
% solution so far. We now turn to the analysis of the frequency response of
% these different filters.
Fsfir = 32e3;            % The equivalent filter is clocked at 32 kHz
Fsfar = 32e3*441;        % The equivalent filter is clocked at 14.112 MHz
hfvt = fvtool(filts2.Stage1,filts2.Stage2,hfar,'FrequencyRange',...
    'Specify freq. vector', 'FrequencyVector',W,...
    'Fs',[16e3 32e3 Fsfar],'NormalizeMagnitudeto1','on');
legend(hfvt,'FIR Interpolate by 2','FIR Interpolate by 2',...
    'Farrow Interpolator','Location','NorthEast')

%%
% On this magnitude response plot, we can see that the second FIR
% Interpolator suppressed half of the replicas from the first FIR
% Interpolator and the Farrow filter suppresses the remaining replicas. We
% now overlay the frequency responses of the single-stage and the
% multistage designs. Clearly the responses are very comparable.
SA = dsp.SpectrumAnalyzer('SpectralAverages',50,'SampleRate',44.1e3,...
    'PlotAsTwoSidedSpectrum',false,'YLimits', [-80 20]);
tic,
while toc < 20
    % Run for 10 seconds
    x = randn(8000,1);
    
    % Convert rate using multistage FIR filters
    y1 = step(SRC,x);
    
    % Convert rate using cascade of multistage FIR and Farrow filter
    ytemp  = step(SRC2,x);
    y2     = filter(hfar,ytemp);
    
    % Compare the output from both approaches
    step(SA,[y1,y2])
end
%%
% The two designs have almost identical transition widths and they both
% meet the specification of a 50 dB minimum attenuation in the stopband.

%% Cascade of Farrow and IIR Polyphase Structures
% If the exact phase linearity constraint can be relaxed, we can use IIR
% halfband design techniques in lieu of the 4th band FIR Nyquist filter to
% get an approximately linear phase filter in the passband.
TW = .125; % Transition Width
f2 = fdesign.interpolator(4,'Nyquist',4,'TW,Ast',TW,Astop);
hiir = design(f2,'multistage','HalfbandDesignMethod','iirlinphase');
h3 = cascade(hiir,hfar);
cost(h3)
%%
% IIR polyphase filters require even less coefficients than their FIR
% polyphase counterparts. The number of coefficients is further reduced
% from 32 to 19. Furthermore, the number of multiplications (76 compared to
% 94) and additions (81 compared to 86) per input sample is also reduced.
tic
while toc < 20
    % Run for 10 seconds
    x = randn(8000,1);
    
    % Convert rate using cascade of multistage FIR and Farrow filter
    ytemp  = step(SRC2,x);
    y1     = filter(hfar,ytemp);
    
    % Convert rate using cascade of IIR polyphase and Farrow filter
    y2 = filter(h3,x);
    
    % Compare the output from both approaches
    step(SA,[y1,y2])
end

%% Summary
% Multirate Farrow filters along with FIR and IIR polyphase filters
% constitute essential building blocks of modern multirate multistage
% systems. Polyphase filters are particularly well adapted for
% interpolation or decimation by an integer factor and for fractional rate
% conversions when the interpolation and the decimation factors are low.
% Farrow filters can efficiently implement arbitrary (including irrational)
% rate change factors. 

displayEndOfDemoMessage(mfilename)




