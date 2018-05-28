function [Signal,Atten,TotalDurMs]=Tone(varargin)
%function [Signal,Atten,TotalDurMs]=Tone(FreqStr,SPLStr,ITDStr,FixEnvStr,ILDStr,DurationStr,Fs)
%Tone -- Generate single tone bursts for 2 channels for the use in RunSeries
%Frequency, SPL, ITD, ILD, and Duration can be specified. The envelope is 
%either fixed between channels or set equal to the ITD for fine structure
%
%<<Input>> 
% !!!! Note !!!! Freq - Duration are all STRINGs.
%Freq :  Frequency and Delta F between the 1st and 2nd channels.
%SPL : Mean SPL of the 2 channels (dB)
%ITD : Interaural time difference (us). Positive number indicates that the channel 1 is delayed.
%FixEnv : 1 for synchronized envelope, 0 for equal to ITD
%ILD : Interaural level difference (dB). Positive number indicates that the channel 1 is lower.
%Duration: Durations (ms) of Silence1, Tone, Silence2, and Ramp
%Fs: Sampling frequency (Hz)
%
%<<Output>>
%Signal: (2-by-NPts matrix) Row vectors of signal; 1st and 2nd row for channels 1 and 2.
%Atten : (1-by-2 matrix) Attenuations by PA5 for channel1 and 2
%TotalDur: Scalar duration of signal (ms)
%
%By SF, 10/10/01
%

%Get input variables
if length(varargin)<7
    error('Insufficient number of input arguments');
end
[FreqStr,SPLStr,ITDStr,FixEnvStr,ILDStr,DurationStr,Fs]=deal(varargin{[1:6 end]});
%keyboard

%Convert the string format of the stimulus paramters to numeric
[Freq,SPL,ITD,FixEnv,ILD,Duration]=deal(str2num(FreqStr),str2num(SPLStr),str2num(ITDStr),str2num(FixEnvStr),...
    str2num(ILDStr),str2num(DurationStr));
DF=Freq(2);
Freq=Freq(1);
%ITD
DTFine=ITD*1e-6; %Fine structure
if FixEnv %Envelope
    DTEnv=0; 
else
    DTEnv=ITD*1e-6;
end
%Duration
myDuration=Duration*1e-3;
[Silence1 ToneDur Silence2 Ramp]=deal(myDuration(1),myDuration(2),myDuration(3),myDuration(4));
TotalDur=Silence1+ToneDur+Silence2;
TotalDurMs=TotalDur*1000;

%Determine the factor of the fine sampling rate relative to
%the final rate, so that FsFactor*Fs is close to 100kHz
FsFactor=round(100000/Fs);
FsFine=FsFactor*Fs;
NPtsFine=TotalDur*FsFine; %Number of points for the fine sampling rate
t=(1:NPtsFine)/FsFine; %time

%Generate waveforms
NPts=length(1:FsFactor:NPtsFine);
tDecimate=(1:NPts)/Fs; %Time for the decimated waveform (i.e., Signal)
Signal=zeros(2,NPts);
for iChan=1:2
    if iChan==1 %Advance time and phase for Channel 1 (Left)
        myDTEnv=DTEnv/2;
        myDTFine=DTFine/2;
        
        %Generate sine wave
        mySignal=sin(2*pi*Freq*(t+myDTFine));
    else %Delay time and phase for Channel 1 (Left)
        myDTEnv=-DTEnv/2;
        myDTFine=-DTFine/2;
        
        %Generate sine wave
        mySignal=sin(2*pi*(Freq+DF)*(t+myDTFine));
    end    
    
    
    %%%% Apply envelope %%%%%%%%%%%%
    %Silence period 1
    I=find(t>=0 & t<Silence1+myDTEnv);
    mySignal(I)=0;
    if Ramp>0
        %Onset ramp
        I=find(t>=Silence1+myDTEnv & t<Silence1+myDTEnv+Ramp);
        %mySignal(I)=mySignal(I).*linspace(0,1,length(I)); %Linear ramp
        mySignal(I)=mySignal(I).*(1-cos((1:length(I))/length(I)*pi/2).^2); %raised-cosine ramp
        %Offset ramp
        I=find(t>=Silence1+myDTEnv+ToneDur-Ramp & t<Silence1+myDTEnv+ToneDur);
        %mySignal(I)=mySignal(I).*linspace(1,0,length(I)); %Linear ramp
        mySignal(I)=mySignal(I).* cos((1:length(I))/length(I)*pi/2).^2; %raised-cosine ramp
    end
    %Silence period 2
    I=find(t>=Silence1+myDTEnv+ToneDur);
    mySignal(I)=0;
    
    %Decimate
    Signal(iChan,:)=decimate(mySignal,FsFactor);
   
    %Make sure that zero-signal portions have really zeros
    %This action is necessary because the DECIMATE function often adds small non-zero noise to the signal
    %(probably in the course of lowpass filtering)
    I=find(tDecimate<Silence1+myDTEnv | tDecimate>Silence1+myDTEnv+ToneDur);
    Signal(iChan,I)=0;
end

%Determine the attenuater gains
OrigSPL=20*log10(1/sqrt(2)); %SPL of original signal
Atten=zeros(1,2);
Atten(1)=OrigSPL-(SPL+ILD/2);
Atten(2)=OrigSPL-(SPL-ILD/2);
