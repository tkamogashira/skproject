function [Signal,Atten,TotalDurMs]=EchoStim(varargin)
%function [Signal,Atten,TotalDurMs]=EchoStim(SourceStr,SPLStr,AmpRatioStr,DelayStr,ITDStr,ILDStr,DurationStr,Fs)
%EchoStim -- Generate stimulus simulating echo for 2 channels for the use in RunSeries
%
%<<Input>> 
% !!!! Note !!!! Source - Duration are all STRINGs.
%Source :  Source types. 'Noise' for Gaussian, 'Click' for click, and other
%for the file that specifies
%SPL : Mean SPL of the 2 channels (dB)
%AmpRatio : The ratio of the echo amplitude to the direct sound
%Delay : Delay of the direct and the delayed sounds (msec)
%ITD : Interaural time difference (us). Positive number indicates that the channel 1 is delayed.
%ILD : Interaural level difference (dB). Positive number indicates that the channel 1 is lower.
%Duration: Durations (ms) of Silence1, Tone, Silence2, and Ramp
%Fs: Sampling frequency (Hz)
%
%<<Output>>
%Signal: (2-by-NPts matrix) Row vectors of signal; 1st and 2nd row for channels 1 and 2.
%Atten : (1-by-2 matrix) Attenuations by PA5 for channel1 and 2
%TotalDur: Scalar duration of signal (ms)
%
%By SF, 12/16/02
%

%Get input variables
if length(varargin)<8
    error('Insufficient number of input arguments');
end
[SourceStr,SPLStr,AmpRatioStr,DelayStr,ITDStr,ILDStr,DurationStr,Fs]=deal(varargin{[1:7 end]});
%keyboard

%Convert the string format of the stimulus paramters to numeric
[Source,SPL,AmpRatio,Delay,ITD,ILD,Duration]=deal(SourceStr,...
    str2num(SPLStr),str2num(AmpRatioStr),str2num(DelayStr),str2num(ITDStr),str2num(ILDStr),str2num(DurationStr));

%ITD
DTEnv=ITD*1e-6;

%Duration
myDuration=Duration*1e-3;
[Silence1 NoiseDur Silence2 Ramp]=deal(myDuration(1),myDuration(2),myDuration(3),myDuration(4));
TotalDur=Silence1+NoiseDur+Silence2;
TotalDurMs=TotalDur*1000;

%Determine the factor of the fine sampling rate relative to
%the final rate, so that FsFactor*Fs is close to 1000kHz
FsFactor=round(1000000/Fs);
FsFine=FsFactor*Fs;
NPtsFine=ceil(TotalDur*FsFine); %Number of points for the fine sampling rate
t=(1:NPtsFine)/FsFine; %time

NPts4Source=ceil(NoiseDur*FsFine); %NPts for noise
NDelay=ceil(Delay*1e-3*FsFine);
NRamp=ceil(Ramp*FsFine);

NPts=length(1:FsFactor:NPtsFine);
tDecimate=(1:NPts)/Fs; %Time for the decimated waveform (i.e., Signal)
Signal=zeros(2,NPts);

%Generate source waveform
switch Source
    case 'Noise'
        SourceWav=randn(1,NPts4Source);
        SourceWav=Cos2RampNPts(SourceWav,NRamp); %Apply ramps
        RMS=[1; 1];
    case 'Click'
        SourceWav=zeros(1,NPts4Source);
        SourceWav(1)=1;
        RMS=[1; 1]/FsFactor;
    otherwise
        load (Source,'y');
        y=y(:)';
        if length(y)>=NPts4Source
            y=y(1:NPts4Source);
        else
            y=[y zeros(1,NPts4Source-length(y))];
        end
        SourceWav=y;
        RMS=[1; 1]*sqrt(mean(SourceWav.^2));
end

%Add echo
SourceWav=[SourceWav zeros(1,NDelay)];
SourceWav(NDelay+(1:NPts4Source))=SourceWav(NDelay+(1:NPts4Source))+AmpRatio*SourceWav(1:NPts4Source);


for iChan=1:2
    if iChan==1 %Advance time and phase for Channel 1 (Left)
        myDTEnv=DTEnv/2;
    else %Delay time and phase for Channel 1 (Left)
        myDTEnv=-DTEnv/2;
    end    
    
    %Place it in the matrix with specified delay
    mySignal=zeros(1,NPtsFine);
    I=find(t>=Silence1+myDTEnv);
    if length(I)<length(SourceWav)
        mySignal(I)=SourceWav(1:length(I));
    else
        IRng=I(1)+(1:length(SourceWav))-1;
        mySignal(IRng)=SourceWav;    
    end
   
    %Decimate
    Signal(iChan,:)=decimate(mySignal,FsFactor);
   
    %Make sure that zero-signal portions have really zeros
    %This action is necessary because the DECIMATE function often adds small non-zero noise to the signal
    %(probably in the course of lowpass filtering)
    I=find(tDecimate<Silence1+myDTEnv | tDecimate>Silence1+myDTEnv+NoiseDur);
    Signal(iChan,I)=0;
end
%Determine the attenuater gains
Atten=zeros(1,2);
if isinf(ILD)
    if ILD>0
    Atten(1)=20*log10(RMS(1))-(SPL/2);
    Atten(2)=120;
    Signal(2,:)=0;
    else
    Atten(1)=120;
    Signal(1,:)=0;
    Atten(2)=20*log10(RMS(2))-(SPL/2);
    end
else
    Atten(1)=20*log10(RMS(1))-(SPL+ILD/2);
    Atten(2)=20*log10(RMS(2))-(SPL-ILD/2);
end
