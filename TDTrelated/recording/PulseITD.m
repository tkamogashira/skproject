function [Signal,Atten,TotalDur]=PulseITD(varargin)
%function [Signal,Atten,TotalDur]=PulseITD(PulseTypeStr,FreqLeftStr,FreqRightStr,PolarityStr,PulseWidthStr,LevelStr,ITDStr,DurationStr,Fs)

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
if length(varargin)<9
    error('Insufficient number of input arguments');
end
[PulseType,FreqLeftStr,FreqRightStr,PolarityStr,PulseWidthStr,LevelStr,ITDStr,DurationStr,Fs]=deal(varargin{:});

%Convert the string format of the stimulus paramters to numeric
[FreqLeft,FreqRight,Polarity,PulseWidth,Level,ITD,Duration]=deal(str2num(FreqLeftStr),str2num(FreqRightStr),...
    str2num(PolarityStr),str2num(PulseWidthStr),str2num(LevelStr),str2num(ITDStr),str2num(DurationStr));
OffsetDur=Duration(1);
TotalDur=Duration(2);

%PulseWidth, ITD and Duration in Sec
myPulseWidth=PulseWidth*1e-3;
myITD=ITD*1e-6;
myOffsetDur=OffsetDur*1e-3;
myTotalDur=TotalDur*1e-3;

%Determine the factor of the fine sampling rate relative to
%the final rate, so that FsFactor*Fs is close to 1000kHz
FsFactor=round(1000000/Fs);
FsFine=FsFactor*Fs;
NPtsFine=ceil(myTotalDur*FsFine); %Number of points for the fine sampling rate
t=(1:NPtsFine)/FsFine; %time

%Generate waveforms -- depending on the pulse type
switch lower(PulseType)
    case lower('GaussModTone')
        n=ceil(myPulseWidth*4*FsFine);
        t_gauss=(-n:n)/FsFine;
        gauss=exp(-(t_gauss/myPulseWidth).^2);
        tone_l=sin(2*pi*FreqLeft*t_gauss+rand(1)*2*pi).*gauss;
        tone_r=sin(2*pi*FreqRight*t_gauss+rand(1)*2*pi).*gauss;
        mySignal=zeros(2,NPtsFine);
        if ~isinf(myITD)
            %Left ear
            [mymin,Imin]=min(abs(t-(myOffsetDur+myITD/2)));
            mySignal(1,Imin+(-n:n))=tone_l;
            [mymin,Imin]=min(abs(t-(myOffsetDur-myITD/2)));
            mySignal(2,Imin+(-n:n))=tone_l;
        else
            [mymin,Imin]=min(abs(t-myOffsetDur));
            if myITD<0 %Monaural -- left
                mySignal(1,Imin+(-n:n))=tone_l;
            else %Monaural -- right
                mySignal(2,Imin+(-n:n))=tone_r;
            end
        end
        
        %Peak-to-peak amplitude
        PkPkAmp=2;
        
    case lower('GaussModNoise')
        n=ceil(myPulseWidth*4*FsFine);
        t_gauss=(-n:n)/FsFine;
        gauss=exp(-(t_gauss/myPulseWidth).^2);
        noise_l=randn(size(t_gauss)).*gauss;
        noise_l=noise_l/max(abs(noise_l));
        noise_r=randn(size(t_gauss)).*gauss;
        noise_r=noise_r/max(abs(noise_r));
        mySignal=zeros(2,NPtsFine);
        if ~isinf(myITD)
            %Left ear
            [mymin,Imin]=min(abs(t-(myOffsetDur+myITD/2)));
            mySignal(1,Imin+(-n:n))=noise_l;
            [mymin,Imin]=min(abs(t-(myOffsetDur-myITD/2)));
            mySignal(2,Imin+(-n:n))=noise_r;
        else
            [mymin,Imin]=min(abs(t-myOffsetDur));
            if myITD<0 %Monaural -- left
                mySignal(1,Imin+(-n:n))=noise_l;
            else %Monaural -- right
                mySignal(2,Imin+(-n:n))=noise_r;
            end
        end
        
        %Peak-to-peak amplitude
        PkPkAmp=2;
        
    case lower('GaussPulse')
        n=ceil(myPulseWidth*4*FsFine);
        t_gauss=(-n:n)/FsFine;
        gauss=exp(-(t_gauss/myPulseWidth).^2)*Polarity;
        mySignal=zeros(2,NPtsFine);
        if ~isinf(myITD)
            %Left ear
            [mymin,Imin]=min(abs(t-(myOffsetDur+myITD/2)));
            mySignal(1,Imin+(-n:n))=gauss;
            [mymin,Imin]=min(abs(t-(myOffsetDur-myITD/2)));
            mySignal(2,Imin+(-n:n))=gauss;
        else
            [mymin,Imin]=min(abs(t-myOffsetDur));
            if myITD<0 %Monaural -- left
                Signal(1,Imin+(-n:n))=gauss;
            else %mySignal -- right
                mySignal(2,Imin+(-n:n))=gauss;
            end
        end
        
        %Peak-to-peak amplitude
        PkPkAmp=1;
        
    case lower('MonoClick')
        n=ceil(myPulseWidth*FsFine);
        click=ones(1,n)*Polarity;
        mySignal=zeros(2,NPtsFine);
        if ~isinf(myITD)
            %Left ear
            [mymin,Imin]=min(abs(t-(myOffsetDur+myITD/2)));
            mySignal(1,Imin+(1:n)-1)=click;
            [mymin,Imin]=min(abs(t-(myOffsetDur-myITD/2)));
            mySignal(2,Imin+(1:n)-1)=click;
        else
            [mymin,Imin]=min(abs(t-myOffsetDur));
            if myITD<0 %Monaural -- left
                mySignal(1,Imin+(1:n)-1)=click;
            else %Monaural -- right
                mySignal(2,Imin+(1:n)-1)=click;
            end
        end
        
        %Peak-to-peak amplitude
        PkPkAmp=1;
        
    case lower('BiClick')
        n=round(myPulseWidth*FsFine/2);
        click=[ones(1,n), -1*ones(1,n)]*Polarity;
        mySignal=zeros(2,NPtsFine);
        if ~isinf(myITD)
            %Left ear
            [mymin,Imin]=min(abs(t-(myOffsetDur+myITD/2)));
            mySignal(1,Imin+(1:2*n)-1)=click;
            [mymin,Imin]=min(abs(t-(myOffsetDur-myITD/2)));
            mySignal(2,Imin+(1:2*n)-1)=click;
        else
            [mymin,Imin]=min(abs(t-myOffsetDur));
            if myITD<0 %Monaural -- left
                mySignal(1,Imin+(1:2*n)-1)=click;
            else %Monaural -- right
                mySignal(2,Imin+(1:2*n)-1)=click;
            end
        end
        
        %Peak-to-peak amplitude
        PkPkAmp=1;
        
    otherwise
        error(sprintf('PulseType %s is not recognized',PulseType));
end

NPts=length(1:FsFactor:NPtsFine);
tDecimate=(1:NPts)/Fs; %Time for the decimated waveform (i.e., Signal)

%Decimate
Signal=[decimate(mySignal(1,:),FsFactor); decimate(mySignal(2,:),FsFactor)];

%Determine the attenuater gains
OrigSPL=20*log10(1/sqrt(2)*PkPkAmp/2); %Peak-to-peak equivalent SPL of the original signal
Atten=[1; 1]*(OrigSPL-Level);
