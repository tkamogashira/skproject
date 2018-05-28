function AnalyzeResponse

global ExptManParam STIM RESPONSE
global Monitor1Setting Monitor2Setting Monitor3Setting Monitor4Setting
global FsRP2 FsRA16


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Use default setting if MonitorSetting does not exist
if isempty(Monitor1Setting) & ExptManParam.ChanFlag(1)
    Monitor1 DefaultSetting;
end %if isempty(MonitorSetting)
if isempty(Monitor2Setting) & ExptManParam.ChanFlag(2)
    Monitor2 DefaultSetting;
end %if isempty(MonitorSetting)
if isempty(Monitor3Setting) & ExptManParam.ChanFlag(3)
    Monitor3 DefaultSetting;
end %if isempty(MonitorSetting)
if isempty(Monitor4Setting) & ExptManParam.ChanFlag(4)
    Monitor4 DefaultSetting;
end %if isempty(MonitorSetting)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set window for spike waveform and sampling rate for spikes
ResampleFactor=4;
FsSpike=FsRA16*ResampleFactor; %Increase sampling rate for spike waveforms
SpikeWin=[-1 2]; %Window for spike waveforms (ms)
SpikeWinPts=round(SpikeWin/1000*FsSpike); %Window in points
SpikeWinPts=SpikeWinPts(1):SpikeWinPts(2);
SpikeTime=SpikeWinPts/FsSpike*1000; %Times for spike waveforms

for iChan=1:4
    
    if ~ExptManParam.ChanFlag(iChan)
        continue;
    end
    
    eval(sprintf('myMonitorSetting=Monitor%dSetting;',iChan));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get raw data and normalize waveform amplitude
    RawWave=RESPONSE.Wave{iChan}/myMonitorSetting.VoltageFor100Percent*1000*100;
    %Time=RESPONSE.Time;
    Time=(1:length(RawWave))/FsRA16*1000;
    StimIdx=RESPONSE.StimIdx;
    NRep=RESPONSE.N(StimIdx);
    
    %Switch the sign of the raw waveform depending on the monitor setting
    if myMonitorSetting.Waveform.ReverseFlag
        RawWave=-RawWave;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Generate IIR filter coefficients for the first time or after modifications
    %of filter order and passband
    if isempty(myMonitorSetting.FilterA) | isempty(myMonitorSetting.FilterB)
        
        N=myMonitorSetting.FilterOrder;
        Wn=myMonitorSetting.FilterPassband / (FsRA16/2);    
        
        if max(Wn)<1 %Bandpass or lowpass
            [b,a]=cheby1(N,0.5,Wn);
        elseif min(Wn)>0 %Highpass
            [b,a]=cheby1(N,0.5,Wn,'high');
        else %All pass
            b=[];
            a=[];
        end
        
        myMonitorSetting.FilterA=a;    
        myMonitorSetting.FilterB=b;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Apply bandpass filter
    b=myMonitorSetting.FilterB;
    a=myMonitorSetting.FilterA;
    if isempty(b) | isempty(a)
        FiltWave=RawWave; %Empty coefficients indicate all-pass filter
    else
        FiltWave=filtfilt(b,a,RawWave);
    end
    
    %Set raw or filter waveform depending on the monitor setting
    if myMonitorSetting.Waveform.FilterFlag %Flag for bandpass filtering
        myMonitorSetting.Waveform.YData=FiltWave;   
    else
        myMonitorSetting.Waveform.YData=RawWave;   
    end
    myMonitorSetting.Waveform.XData=Time;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Spike sorting
    
    %Get cutoff criteria
    CutThresh=myMonitorSetting.Spikes.CutThresh; %Cutoff threshold
    
    Criterion1_t=myMonitorSetting.Spikes.Criterion1.t; %Time of the criterion1
    [dum,Criterion1_Idx]=min((SpikeTime-Criterion1_t).^2); %Index for criterion1
    if myMonitorSetting.Spikes.Criterion1.Flag
        Criterion1_Hi=myMonitorSetting.Spikes.Criterion1.Hi; %Upper threshold
        Criterion1_Lo=myMonitorSetting.Spikes.Criterion1.Lo; %Lower threshold
    else
        Criterion1_Hi=100;
        Criterion1_Lo=-100;
    end
    
    Criterion2_t=myMonitorSetting.Spikes.Criterion2.t; %Time of the criterion2
    [dum,Criterion2_Idx]=min((SpikeTime-Criterion2_t).^2); %Index for criterion1
    if myMonitorSetting.Spikes.Criterion2.Flag
        Criterion2_Hi=myMonitorSetting.Spikes.Criterion2.Hi; %Upper threshold
        Criterion2_Lo=myMonitorSetting.Spikes.Criterion2.Lo; %Lower threshold
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
        myMonitorSetting.Spikes.XData=[];
        myMonitorSetting.Spikes.YDataFail=[];
        myMonitorSetting.Spikes.YDataPass=[];
    else
        myMonitorSetting.Spikes.XData=SpikeTime(:);
        myMonitorSetting.Spikes.YDataFail=SpikeMat(:,IFail);
        myMonitorSetting.Spikes.YDataPass=SpikeMat(:,IPass);
    end
    
    %Vectors indicating spikes by 1ms bin
    ZeroOne=full(sparse(1,ceil(TPass),1,1,ceil(max(Time))));
    
    %Adjust bin width for long stimuli
    %     n=length(ZeroOne);
    %     if n>1000
    %         binwidth=10;
    %         rng=1:(binwidth*floor(n/binwidth));
    %         myZeroOne=mean(reshape(ZeroOne(rng),[binwidth, floor(n/binwidth)]));
    %         myZeroOne=repmat(myZeroOne,[binwidth,1]);
    %         ZeroOne(rng)=myZeroOne;
    %     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update raster
    x=myMonitorSetting.Raster.XData;
    y=myMonitorSetting.Raster.YData;
    z=myMonitorSetting.Raster.ZData;
    
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
    myMonitorSetting.Raster.XData=x;
    myMonitorSetting.Raster.YData=y;
    myMonitorSetting.Raster.ZData=z;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update PSTH
    x=myMonitorSetting.PSTH.XData;
    y=myMonitorSetting.PSTH.YData;
    z=myMonitorSetting.PSTH.ZData;
    
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
    myMonitorSetting.PSTH.XData=x;
    myMonitorSetting.PSTH.YData=y;
    myMonitorSetting.PSTH.ZData=z;
    myMonitorSetting.PSTH.StimIdx=StimIdx;
    

    %% set back the monitor setting 
    eval(sprintf('Monitor%dSetting=myMonitorSetting;',iChan));
   
end
