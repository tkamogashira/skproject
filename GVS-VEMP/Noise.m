function [Signal,Atten,TotalDurMs]=Noise(varargin)
%function [Signal,Atten,TotalDurMs]=Noise(PassbandStr,FiltOrderStr,SPLStr,ITDStr,UncorrelatedStr,ILDStr,DurationStr,Fs)
%Noise -- Generate bandpassed noise bursts for 2 channels for the use in RunSeries
%Passband, IIR filter order (ellip), SPL, ITD, ILD, and Duration can be specified. Whether the fine structure is 
%correlated or uncorrelated between channels is specified.
%
%<<Input>> 
% !!!! Note !!!! Passband - Duration are all STRINGs.
%Passband :  [LoCut HiCut] (Hz) common for the 1st and 2nd channels.
%FiltOrder : IIR filter order (ellip)
%SPL : Mean SPL of the 2 channels (dB)
%ITD : Interaural time difference (us). Positive number indicates that the channel 1 is delayed.
%Uncorrelated : 1 for uncorrelated fine structure, 0 for identical
%ILD : Interaural level difference (dB). Positive number indicates that the channel 1 is lower.
%Duration: Durations (ms) of Silence1, Tone, Silence2, and Ramp
%Fs: Sampling frequency (Hz)
%
%<<Output>>
%Signal: (2-by-NPts matrix) Row vectors of signal; 1st and 2nd row for channels 1 and 2.
%Atten : (1-by-2 matrix) Attenuations by PA5 for channel1 and 2
%TotalDur: Scalar duration of signal (ms)
%
%By SF, 4/1/02
%

%Get input variables
if length(varargin)<8
    error('Insufficient number of input arguments');
end
[PassbandStr,FiltOrderStr,SPLStr,ITDStr,UncorrelatedStr,ILDStr,DurationStr,Fs]=deal(varargin{[1:7 end]});
%keyboard

%Convert the string format of the stimulus paramters to numeric
[Passband,FiltOrder,SPL,ITD,Uncorrelated,ILD,Duration]=deal(str2num(PassbandStr),str2num(FiltOrderStr),...
    str2num(SPLStr),str2num(ITDStr),str2num(UncorrelatedStr),str2num(ILDStr),str2num(DurationStr));

%ITD
DTEnv=ITD*1e-6;

%Duration
myDuration=Duration*1e-3;
[Silence1 NoiseDur Silence2 Ramp]=deal(myDuration(1),myDuration(2),myDuration(3),myDuration(4));
TotalDur=Silence1+NoiseDur+Silence2;
TotalDurMs=TotalDur*1000;

%Determine the factor of the fine sampling rate relative to
%the final rate, so that FsFactor*Fs is close to 100kHz
FsFactor=round(100000/Fs);
FsFine=FsFactor*Fs;
NPtsFine=ceil(TotalDur*FsFine); %Number of points for the fine sampling rate
t=(1:NPtsFine)/FsFine; %time

%Get filter coefficients
[B,A]=ellip(FiltOrder,.5,20,Passband/(FsFine/2));

%Generate waveforms
NPts4Noise=ceil(NoiseDur*FsFine); %NPts for noise
NRamp=ceil(Ramp*FsFine);
NPts=length(1:FsFactor:NPtsFine);
tDecimate=(1:NPts)/Fs; %Time for the decimated waveform (i.e., Signal)
Signal=zeros(2,NPts);
RMS=zeros(2,1);
for iChan=1:2
    if iChan==1 %Advance time and phase for Channel 1 (Left)
        myDTEnv=DTEnv/2;
    else %Delay time and phase for Channel 1 (Left)
        myDTEnv=-DTEnv/2;
    end    
    
    %Determine correlation between channels
    if iChan==1
        Seed=randn('state');
    elseif ~Uncorrelated
        randn('state',Seed);
    end
    %Generate noise
    mynoise=randn(1,NPts4Noise+1000); %Generate extra points to reduce the effect of the initial transient
    mynoise=filter(B,A,mynoise); %Filter
    RMS(iChan)=sqrt(mean(mynoise.^2));
    mynoise=mynoise(1000+(1:NPts4Noise)); %Remove the first points
    mynoise=Cos2RampNPts(mynoise,NRamp); %Apply ramps
    
    %Place it in the matrix with specified delay
    mySignal=zeros(1,NPtsFine);
    I=find(t>=Silence1+myDTEnv);
    IRng=I(1)+(1:length(mynoise))-1;
    mySignal(IRng)=mynoise;    
   
    %Decimate
    Signal(iChan,:)=decimate(mySignal,FsFactor);
   
    %Make sure that zero-signal portions have really zeros
    %This action is necessary because the DECIMATE function often adds small non-zero noise to the signal
    %(probably in the course of lowpass filtering)
    I=find(tDecimate<Silence1+myDTEnv | tDecimate>Silence1+myDTEnv+NoiseDur);
    Signal(iChan,I)=0;
end

%Determine the attenuater gains
OrigSPL=20*log10(1/sqrt(2)); %SPL of original signal
Atten=zeros(1,2);
Atten(1)=20*log10(RMS(1))-(SPL+ILD/2);
Atten(2)=20*log10(RMS(2))-(SPL-ILD/2);
