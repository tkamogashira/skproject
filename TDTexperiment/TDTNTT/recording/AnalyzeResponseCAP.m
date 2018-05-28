function AnalyzeResponseCAP

global ExptManParam STIM RESPONSE MonitorSetting
global FsRP2 FsRA16


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Use default setting if MonitorSetting
if isempty(MonitorSetting)
    Monitor DefaultSetting;
end %if isempty(MonitorSetting)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set window for spike waveform and sampling rate for spikes
ResampleFactor=4;
FsSpike=FsRA16*ResampleFactor; %Increase sampling rate for spike waveforms
SpikeWin=[-1 2]; %Window for spike waveforms (ms)
SpikeWinPts=round(SpikeWin/1000*FsSpike); %Window in points
SpikeWinPts=SpikeWinPts(1):SpikeWinPts(2);
SpikeTime=SpikeWinPts/FsSpike*1000; %Times for spike waveforms


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get raw data and normalize waveform amplitude
RawWave=RESPONSE.Wave/MonitorSetting.VoltageFor100Percent*1000*100;
Time=RESPONSE.Time;
StimIdx=RESPONSE.StimIdx;
NRep=RESPONSE.N(StimIdx);

%Switch the sign of the raw waveform depending on the monitor setting
if MonitorSetting.Waveform.ReverseFlag
    RawWave=-RawWave;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate IIR filter coefficients for the first time or after modifications
%of filter order and passband
if isempty(MonitorSetting.FilterB) | isempty(MonitorSetting.FilterA)
    
    N=MonitorSetting.FilterOrder;
    Wn=MonitorSetting.FilterPassband / (FsRA16/2);
    
    if max(Wn)<1 %Bandpass or lowpass
        [b,a]=cheby1(N,0.5,Wn);
    elseif min(Wn)>0 %Highpass
        [b,a]=cheby1(N,0.5,Wn,'high');
    else %All pass
        b=[];
        a=[];
    end
    
    MonitorSetting.FilterB=b; %Filter coefficients B
    MonitorSetting.FilterA=a; %Filter coefficients A
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply bandpass filter
b=MonitorSetting.FilterB;
a=MonitorSetting.FilterA;
if isempty(b) | isempty(a)
    FiltWave=RawWave; %Empty coefficients indicate all-pass filter
else
    FiltWave=filtfilt(b,a,RawWave);
end

%Set raw or filter waveform depending on the monitor setting
if MonitorSetting.Waveform.FilterFlag %Flag for bandpass filtering
    MonitorSetting.Waveform.YData=FiltWave;
else
    MonitorSetting.Waveform.YData=RawWave;
end
MonitorSetting.Waveform.XData=Time;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike sorting

%Get cutoff criteria
CutThresh=MonitorSetting.Spikes.CutThresh; %Cutoff threshold

Criterion1_t=MonitorSetting.Spikes.Criterion1.t; %Time of the criterion1
[dum,Criterion1_Idx]=min((SpikeTime-Criterion1_t).^2); %Index for criterion1
if MonitorSetting.Spikes.Criterion1.Flag
    Criterion1_Hi=MonitorSetting.Spikes.Criterion1.Hi; %Upper threshold
    Criterion1_Lo=MonitorSetting.Spikes.Criterion1.Lo; %Lower threshold
else
    Criterion1_Hi=100;
    Criterion1_Lo=-100;
end

Criterion2_t=MonitorSetting.Spikes.Criterion2.t; %Time of the criterion2
[dum,Criterion2_Idx]=min((SpikeTime-Criterion2_t).^2); %Index for criterion1
if MonitorSetting.Spikes.Criterion2.Flag
    Criterion2_Hi=MonitorSetting.Spikes.Criterion2.Hi; %Upper threshold
    Criterion2_Lo=MonitorSetting.Spikes.Criterion2.Lo; %Lower threshold
else
    Criterion2_Hi=100;
    Criterion2_Lo=-100;
end

%Increase sampling rate
y=resample(FiltWave,ResampleFactor,1)';
t=(1:length(Time)*ResampleFactor)/FsSpike*1000;

%Detection of threshold crossing
y1=[0; y(1:(end-1))]; %Shift the waveform by one point
%Detect points at which the amplitudes cross the threshold
IThreshCross=find(y>CutThresh & y1<=CutThresh);
%Exclude peaks at either extremes of the waveform
IThreshCross=IThreshCross(IThreshCross>abs(SpikeWinPts(1)) & IThreshCross<length(y)-abs(SpikeWinPts(end)));
%Number of peaks
NThreshCross=length(IThreshCross);

%Extract spike waveforms and apply the critria
if NThreshCross
    I1=repmat(IThreshCross(:)',[length(SpikeWinPts),1]); %array of spike indeces
    I2=repmat(SpikeWinPts(:),[1,NThreshCross]); %array of points relative to the thrshold-crossing point
    I=I1+I2; %Indeces for spike waveforms
    SpikeMat=y(I); %Spike waveforms
    
    try
        %Find spikes that pass the critria
        zeroone=SpikeMat(Criterion1_Idx,:)<=Criterion1_Hi & SpikeMat(Criterion1_Idx,:)>=Criterion1_Lo & ...
            SpikeMat(Criterion2_Idx,:)<=Criterion2_Hi & SpikeMat(Criterion2_Idx,:)>=Criterion2_Lo;
        IPass=find(zeroone);
        IFail=find(~zeroone);
        TPass=t(IThreshCross(IPass));
    catch
        disp('Error in spike detection')
        keyboard
    end
else
    SpikeMat=[];
    IPass=[];
    IFail=[];
    TPass=[];
end

%Set data matrices for the monitor
if isempty(SpikeMat)
    MonitorSetting.Spikes.XData=[];
    MonitorSetting.Spikes.YDataFail=[];
    MonitorSetting.Spikes.YDataPass=[];
else
    MonitorSetting.Spikes.XData=SpikeTime(:);
    MonitorSetting.Spikes.YDataFail=SpikeMat(:,IFail);
    MonitorSetting.Spikes.YDataPass=SpikeMat(:,IPass);display(SpikeMat(:,IPass));%Shotaro
end

%Vectors indicating spikes by 1ms bin
ZeroOne=full(sparse(1,ceil(TPass),1,1,ceil(max(Time))));

%Adjust bin width for long stimuli
% n=length(ZeroOne);
% if n>1000
%     binwidth=10;
%     rng=1:(binwidth*floor(n/binwidth));
%     myZeroOne=mean(reshape(ZeroOne(rng),[binwidth, floor(n/binwidth)]));
%     myZeroOne=repmat(myZeroOne,[binwidth,1]);
%     ZeroOne(rng)=myZeroOne;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update raster
x=MonitorSetting.Raster.XData;
y=MonitorSetting.Raster.YData;
z=MonitorSetting.Raster.ZData;

NRowRaster=30;
%If the first time, initialize the matrix
if isempty(z) 
    x=1:length(ZeroOne);
    y=1:NRowRaster;
    z=zeros(length(y),length(x));
end
%Append zeros to the matrix if necessary
dNColRaster=length(ZeroOne)-size(z,2);
if dNColRaster>0
    x=1:length(ZeroOne);
    z=[z zeros(NRowRaster,dNColRaster)];
elseif dNColRaster<0
    ZeroOne=[ZeroOne zeros(1,abs(dNColRaster))];
end

%Update
z=[z(2:end,:); ZeroOne>0];
%Set the variables    
MonitorSetting.Raster.XData=x;
MonitorSetting.Raster.YData=y;
MonitorSetting.Raster.ZData=z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update PSTH
x=MonitorSetting.PSTH.XData;
y=MonitorSetting.PSTH.YData;
z=MonitorSetting.PSTH.ZData;

NRowPSTH=size(STIM,1);
%If the first time, initialize the matrix
if isempty(z) 
    x=1:length(ZeroOne);
    y=1:NRowPSTH;
    z=zeros(length(y),length(x));
end
%Append zeros to the matrix if necessary
dNColPSTH=length(ZeroOne)-size(z,2);
if dNColPSTH>0
    x=1:length(ZeroOne);
    z=[z zeros(NRowPSTH,dNColPSTH)];
elseif dNColPSTH<0
    ZeroOne=[ZeroOne zeros(1,abs(dNColPSTH))];
end

%Update
myz=z(StimIdx,:);
myz=(myz*(NRep-1)+ZeroOne)/NRep;
z(StimIdx,:)=myz;

%Set the variables    
MonitorSetting.PSTH.XData=x;
MonitorSetting.PSTH.YData=y;
MonitorSetting.PSTH.ZData=z;
MonitorSetting.PSTH.StimIdx=StimIdx;

