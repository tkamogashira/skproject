function [Signal,Atten,TotalDurMs]=ILD(varargin)
%function [Signal,Atten,TotalDurMs]=ILD(FreqStr,SPLStr,ILDStr,DurationStr,TotalDurationStr,Fs)
%ILD -- Generate signal that differ between the ears for the use in RunSeries
%Frequency (tone freq, or noise passband), SPL, ILD, and Duration can be specified.
%
%<<Input>> 
% !!!! Note !!!! Freq - TotalDuration are all STRINGs.
%Freq : (2-by-3) Rows 1 and 2 for left and right channels.
%     For tone, the first column is the frequency, the other column being dummy.
%     For noise, [LoCut HiCut] (Hz) and filter order (ellip).
%SPL : (1-by-2) Column 1 for SPL, column 2 for index for whether the SPL refers to left (1), right (2),
%     or mean(0);
%ILD : Interaural level difference (Right - Left) (dB). 
%Duration: (2-by-2) Rows 1 and 2 for left and right channels. Column 1 for
%       onset time, column 2 for durtaion of the tone/noise.
%TotalDuration: Total duration and ramp duration
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
if length(varargin)<6
    error('Insufficient number of input arguments');
end
[FreqStr,SPLStr,ILDStr,DurationStr,TotalDurationStr,Fs]=deal(varargin{[1:5 end]});

%Convert the string format of the stimulus paramters to numeric
[Freq,SPL,ILD,Duration,TotalDuration]=deal(str2num(FreqStr),str2num(SPLStr),str2num(ILDStr),str2num(DurationStr),str2num(TotalDurationStr));

%Duration
TotalDurMs=TotalDuration(1);
TotalDur=TotalDurMs*1e-3;
Ramp=TotalDuration(2)*1e-3;
Silence1=Duration(:,1)*1e-3;
ToneDur=Duration(:,2)*1e-3;
Silence2=(TotalDurMs-Duration(:,1)-Duration(:,2))*1e-3;

NPts=ceil(TotalDur*Fs); %Number of points
t=(1:NPts)/Fs; %time

%Generate waveforms
NPts4Tone=ceil(ToneDur*Fs); %NPts for tone
NRamp=ceil(Ramp*Fs);
Signal=zeros(2,NPts);
RMS=zeros(2,1);
for iChan=1:2
    if iChan==1
        Seed=randn('state');
    else
        randn('state',Seed);
    end
    
    %Generate signal -- if zero-freq is specified, skip the channel
    if Freq(iChan,1) %
        if Freq(iChan,2) %Non-zero value in the second column -- Noise
            %Get filter coefficients
            [B,A]=ellip(Freq(iChan,3),.5,20,Freq(iChan,1:2)/(Fs/2));

            %Generate noise
            mysignal=randn(1,NPts4Tone(iChan)+1000); %Generate extra points to reduce the effect of the initial transient
            mysignal=filter(B,A,mysignal); %Filter
            RMS(iChan)=sqrt(mean(mysignal.^2));
            mysignal=mysignal(1000+(1:NPts4Tone(iChan))); %Remove the first points
            mysignal=Cos2RampNPts(mysignal,NRamp); %Apply ramps
        else %Zero in the second column -- Tone
            t=(1:NPts4Tone(iChan))/Fs;
            mysignal=sin(2*pi*Freq(iChan,1)*t);
            RMS(iChan)=sqrt(mean(mysignal.^2));
            mysignal=Cos2RampNPts(mysignal,NRamp); %Apply ramps
        end
        
        %Silence
        NSilence=ceil(Silence1(iChan)*Fs);
        Signal(iChan,NSilence+(1:NPts4Tone(iChan)))=mysignal;
   end
end

%Determine the attenuater gains
if SPL(2)==1
    SPL_L=SPL(1);
    SPL_R=SPL(1)+ILD;
elseif SPL(2)==2
    SPL_L=SPL(1)-ILD;
    SPL_R=SPL(1);
else
    SPL_L=SPL(1)-ILD/2;
    SPL_R=SPL(1)+ILD/2;
end


Atten=zeros(1,2);
if ~RMS(1)
    Atten(1)=120;
else
    Atten(1)=20*log10(RMS(1))-SPL_L;
end
if ~RMS(1)
    Atten(2)=120;
else
    Atten(2)=20*log10(RMS(2))-SPL_R;
end
