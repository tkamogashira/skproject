function [Signal,Atten,TotalDurMs]=AdaptIPD(varargin)
%function [Signal,Atten,TotalDurMs]=AdaptIPD(AdaptParamStr,GapParamStr,ProbeParamStr,FixEnvStr,TimeParamStr,Fs)
%AdaptIPD -- Generate tone sequence (Adapter and Probe) for 2 channels for the use in RunSeries.
%Frequency, SPL, ITD, and Duration can be specified independently for the adapter and the probe. The envelope is 
%either fixed between channels or set equal to the ITD for fine structure
%
%<<Input>> 
% !!!! Note !!!! All the input except Fs are all STRINGs.
%AdaptParam :  Parameter for the adapter; Duration (ms), Frequency (Hz), SPL (dB), and ITD (us).
%GapParam : Gap duration (ms)
%ProbeParam :  Parameter for the probe; Duration (ms), Frequency (Hz), SPL (dB), and ITD (us).
%FixEnv : 1 for synchronized envelope, 0 for equal to ITD
%TimeParam: Durations (ms) of Silence1, Silence2, and Ramp
%Fs: Sampling frequency (Hz)
%
%<<Output>>
%Signal: (2-by-NPts matrix) Row vectors of signal; 1st and 2nd row for channels 1 and 2.
%Atten : (1-by-2 matrix) Attenuations by PA5 for channel1 and 2
%TotalDur: Scalar duration of signal (ms)
%
%By SF, 05/06/02
%

%Get input variables
if length(varargin)<6
    error('Insufficient number of input arguments');
end
[AdaptParamStr,GapParamStr,ProbeParamStr,FixEnvStr,TimeParamStr,Fs]=deal(varargin{[1:5 end]});
%keyboard

%Convert the string format of the stimulus paramters to numeric
[AdaptParam,GapDur,ProbeParam,FixEnv,TimeParam]=deal(str2num(AdaptParamStr),str2num(GapParamStr),...
    str2num(ProbeParamStr),str2num(FixEnvStr),str2num(TimeParamStr));
[AdaptDur, AdaptFreq, AdaptSPL, AdaptITD]=deal(AdaptParam(1),AdaptParam(2),AdaptParam(3),AdaptParam(4));
[ProbeDur, ProbeFreq, ProbeSPL, ProbeITD]=deal(ProbeParam(1),ProbeParam(2),ProbeParam(3),ProbeParam(4));
[Silence1, Silence2, Ramp]=deal(TimeParam(1),TimeParam(2),TimeParam(3));

%Ratio of the probe amplitude to the adapter
AmpRatio=10^((AdaptSPL-ProbeSPL)/20);

%ITD in sec
AdaptDTFine=AdaptITD*1e-6; %Fine structure
ProbeDTFine=ProbeITD*1e-6; %Fine structure
if FixEnv %Envelope
    AdaptDTEnv=0; 
    ProbeDTEnv=0; 
else
    AdaptDTEnv=AdaptDTFine;
    ProbeDTEnv=ProbeDTFine;
end
%If AdaptITD=NaN (i.e., no adapter), set dummy number
if isnan(AdaptITD)
    AdaptDTFine=0;
    AdaptDTEnv=0;
end

%Total Duration in ms
TotalDurMs=Silence1+AdaptDur+GapDur+ProbeDur+Silence2;

%Duration in sec
TotalDur=TotalDurMs*1e-3;
[Silence1, AdaptDur, GapDur, ProbeDur, Silence2, Ramp]=...
    deal(Silence1*1e-3, AdaptDur*1e-3, GapDur*1e-3, ProbeDur*1e-3, Silence2*1e-3, Ramp*1e-3);

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
        %Adapter
        myAdaptDTEnv=AdaptDTEnv/2;
        myAdaptDTFine=AdaptDTFine/2;
        %Probe
        myProbeDTEnv=ProbeDTEnv/2;
        myProbeDTFine=ProbeDTFine/2;
    else %Delay time and phase for Channel 1 (Left)
        %Adapter
        myAdaptDTEnv=-AdaptDTEnv/2;
        myAdaptDTFine=-AdaptDTFine/2;
        %Probe
        myProbeDTEnv=-ProbeDTEnv/2;
        myProbeDTFine=-ProbeDTFine/2;
    end    
       
    %Make zero vector
    mySignal=zeros(size(t));

    %%%% Apply envelope for adapter%%%%%%%%%%%%
    if isnan(AdaptITD)
        skipAdapt=1;
    elseif AdaptITD>=1e6
        myAdaptDTEnv=0;
        myAdaptDTFine=0;
        if iChan==1
            skipAdapt=0;
        else
            skipAdapt=1;
        end
    elseif AdaptITD<=-1e6
        myAdaptDTEnv=0;
        myAdaptDTFine=0;
        if iChan==2
            skipAdapt=0;
        else
            skipAdapt=1;
        end
    else
        skipAdapt=0;
    end

    
    if ~skipAdapt %If AdaptITD=NaN, present no adapter
        
        AdaptWav=sin(2*pi*AdaptFreq*(t+myAdaptDTFine))*AmpRatio; %Generate sine wave for the adapter
        
        Offset=Silence1;
        %Onset ramp
        I=find(t>=Offset+myAdaptDTEnv & t<Offset+myAdaptDTEnv+Ramp);
        mySignal(I)=AdaptWav(I).*(1-cos((1:length(I))/length(I)*pi/2).^2); %raised-cosine ramp
        %Steady part
        I=find(t>=Offset+myAdaptDTEnv+Ramp & t<Offset+myAdaptDTEnv+AdaptDur-Ramp);
        mySignal(I)=AdaptWav(I);
        %Offset ramp
        I=find(t>=Offset+myAdaptDTEnv+AdaptDur-Ramp & t<Offset+myAdaptDTEnv+AdaptDur);
        mySignal(I)=AdaptWav(I).* cos((1:length(I))/length(I)*pi/2).^2; %raised-cosine ramp
    end

    %%%% Apply envelope for probe%%%%%%%%%%%%
    if isnan(ProbeITD)
        skipProbe=1;
    elseif ProbeITD>=1e6
        myProbeDTEnv=0;
        myProbeDTFine=0;
        if iChan==1
            skipProbe=0;
        else
            skipProbe=1;
        end
    elseif ProbeITD<=-1e6
        myProbeDTEnv=0;
        myProbeDTFine=0;
        if iChan==2
            skipProbe=0;
        else
            skipProbe=1;
        end
    else
        skipProbe=0;
    end
    
    if ~skipProbe
        ProbeWav=sin(2*pi*ProbeFreq*(t+myProbeDTFine)); %Generate sine wave for the probe
        
        Offset=Silence1+AdaptDur+GapDur;
        %Onset ramp
        I=find(t>=Offset+myProbeDTEnv & t<Offset+myProbeDTEnv+Ramp);
        mySignal(I)=ProbeWav(I).*(1-cos((1:length(I))/length(I)*pi/2).^2); %raised-cosine ramp
        %Steady part
        I=find(t>=Offset+myProbeDTEnv+Ramp & t<Offset+myProbeDTEnv+ProbeDur-Ramp);
        mySignal(I)=ProbeWav(I);
        %Offset ramp
        I=find(t>=Offset+myProbeDTEnv+ProbeDur-Ramp & t<Offset+myProbeDTEnv+ProbeDur);
        mySignal(I)=ProbeWav(I).* cos((1:length(I))/length(I)*pi/2).^2; %raised-cosine ramp
    end
    
    %Decimate
    Signal(iChan,:)=decimate(mySignal,FsFactor);
   
    %Make sure that zero-signal portions have really zeros
    %This action is necessary because the DECIMATE function often adds small non-zero noise to the signal
    %(probably in the course of lowpass filtering)
    I=find(tDecimate<Silence1);
    if skipAdapt %If AdaptITD=NaN, present no adapter
        I=[I find(tDecimate>=Silence1 & tDecimate<Silence1+myAdaptDTEnv+AdaptDur)];
    end
    I=[I find(tDecimate>=Silence1+myAdaptDTEnv+AdaptDur & tDecimate<Silence1+myAdaptDTEnv+AdaptDur+GapDur)];
    if skipProbe %
        I=[I find(tDecimate>=Silence1+myAdaptDTEnv+AdaptDur+GapDur & ...
                tDecimate<Silence1+myAdaptDTEnv+AdaptDur+GapDur+ProbeDur)];
    end
    I=[I find(tDecimate>=Silence1+myAdaptDTEnv+AdaptDur+GapDur+ProbeDur)];
    
    Signal(iChan,I)=0;
    

end

%Determine the attenuater gains
OrigSPL=20*log10(1/sqrt(2)); %SPL of original signal (based on the probe amplitude)
Atten=zeros(1,2)+OrigSPL-ProbeSPL;
