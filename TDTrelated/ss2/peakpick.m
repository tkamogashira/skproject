function [NRep, PkCount]=PeakPick(RootNameIn,RootNameOut,StimIdx)
%PEAKPICK -- Peak-picking for RAW files generated with the TDT3 system.
%Bandpass filter the raw waveforms and detect peaks that exceeds certain criterion.
%The results are stored in the Michigan PK format.
%
%Usage:  NRep = peakpick(FNameIn,FNameOut,NPts)
%RootNameIn: Root name for inputs, eg, 'D:\data\G010521\#0'
%RootNameOut: Output file name, eg, 'D:\data\G010521\#0\peaks'
%StimIdx: Stimulus index
%
%NRep: Number of repetitions
%PkCount: Number of peaks
%
%By SF, 6/21/02

%Read the Info file and get the info
Info=GetRecordInfo(RootNameIn);
MaxVolt=Info.MaxVolt;
Fs=Info.FsRA16;
DataPrec='int16';

nStimIdx=length(StimIdx);
NRep=zeros(1,nStimIdx);
PkCount=zeros(1,nStimIdx);

for iStimIdx=1:nStimIdx
    myStimIdx=StimIdx(iStimIdx);   
    
    I=find(Info.StimIndex(:,1)==myStimIdx);
    NPtsMat=Info.StimIndex(I,:);
    myNRep=length(I);
    
    %Open the WAV file
    FNameIn=fullfile(RootNameIn,sprintf('%03d.raw',myStimIdx));
    FidIn=fopen(FNameIn,'rb');
    if FidIn<0 
        fclose all;
        error('Cannot open input file');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Set parameters for the record
    
    %Sampling rate for down-sampling
    srateLow=Fs;
    %Make bandpass filter coefficients
    [B,A] = ellip(8,0.5,20,[300 5000]/(srateLow/2));
    
    %Sampling rate for up-resampling
    srateHigh=Fs*4; %Sampling rate for resampling
    tick=1/srateHigh*1000000; %tick size in micro sec
    
    % %
    % 
    % NPtsOneRawWav=floor(RecDur*srateHigh/1000); %No of points per raw waveform after resampling
    % t=(0:(NPtsOneRawWav-1))*tick; %PST after resampling
    % myRecDur=length(t(1:2:end))*(tick*2)/1000;
    
    %Threshold for candidate spikes
    CutFact=5;
    
    %Define temporal window for peaks
%    HalfWin=600; %Half of the window (us)
    HalfWin=600*2; %Half of the window (us)
    HalfWinPts=round(HalfWin/tick);
    WinPts=-HalfWinPts:HalfWinPts; %Index range for the window
    
    %Open files for output files
    FNameOut=fullfile(RootNameOut,sprintf('%03d.pk',myStimIdx));
    FidOutPk=fopen(FNameOut,'wb');
    if FidOutPk==-1 
        error('Cannot open output file');
    end
    
    %Write headers for the pk
    % Write the header of the output file
    %Format Identifier
    mystr='FORMAT Pk0501 '; 
    mystr=[mystr blanks(80-length(mystr))];
    fwrite(FidOutPk,mystr,'char');
    %Input file name
    mystr=[FNameIn blanks(80-length(FNameIn))];
    fwrite(FidOutPk,mystr,'char');
    %Sampling rate for the peak waveformas; 50kHz
    SRatePk=srateHigh;
    fwrite(FidOutPk,srateHigh,'uint32'); 
    %Number of points per peak wavelet
    fwrite(FidOutPk,length(WinPts),'uint32');
    %Number of channels
    fwrite(FidOutPk,1,'uint16');
    %Number of peaks per channel
    fwrite(FidOutPk,0,'uint32'); %All zeros for now
    %Number of bytes for a scalar
    fwrite(FidOutPk,4,'uint16');
    ScPrecPk='float32'; %Precision identifier for FREAD  
    %Number of bytes for a data point
    fwrite(FidOutPk,1,'int16'); 
    DatPrecPk='int8'; %Precision identifier for FREAD
    
    
    %Start processing
    myPkCount=0;
    h = waitbar(0,sprintf('Stim %d (%d / %d) ...',myStimIdx,iStimIdx,nStimIdx));
    for iRep=1:myNRep
        NPtsTrial=NPtsMat(iRep,2);
        
        y = fread(FidIn,[2+NPtsTrial, 1],DataPrec);
        %Check if the NPts for  the trial is consistent between the marker in the raw file
        %and the info in Info.txt.
        if y(1)~=32767 | y(2)~=-32768
            error('Inconsistent trial separation');
        end
        y (1:2)=[];
        
        %Scale
        y=y/32767*MaxVolt;
        
        %Bandpass filtering
        SigWav=filtfilt(B,A,y);
        
        %Up-sampling
        SigWav=resample(SigWav,round(srateHigh/srateLow),1); %Signal channel 
        t=(0:(NPtsTrial*round(srateHigh/srateLow)-1))*tick; %PST after resampling
        
        %Peak picking
        a=sort(SigWav(1:500));
        a=a(26:475);
        RMS=std(a,0); %Noise floor level
        %RMS=std(SigWav(1:500),0); %Noise floor level
        zeroone=(abs(SigWav)>RMS*CutFact) & ... %Amplitude above the threshold
            (...
            (diff([SigWav; 0])<0 & diff([0; SigWav])>=0 & SigWav>0) | ... %positive peak or
            (diff([SigWav; 0])>0 & diff([0; SigWav])<=0 & SigWav<0) ... %negative peak
            );
        IPeak=find(zeroone);
        NPeak=length(IPeak);
        
        for iPeak=1:NPeak
            myIPeak=IPeak(iPeak);
            IWin=myIPeak+WinPts;
            if IWin(1)>=1 & IWin(end)<=min([length(SigWav) length(t)])
                myPkCount=myPkCount+1;
                try
                    mypeak=SigWav(IWin);         
                    mypst=t(myIPeak); %in ms
                catch
                    keyboard
                end
                
                %write the peak waveform
                fwrite(FidOutPk,iRep,'uint32'); %Trial number
                fwrite(FidOutPk,mypst/10,'uint32'); %time after the trigger (x10 us)
                mymax=max(abs(mypeak));
                scalar=128/mymax;
                mypeak=mypeak*scalar;
                fwrite(FidOutPk,scalar,ScPrecPk); %scale factor
                fwrite(FidOutPk,mypeak,DatPrecPk); %peak waveform, decimated
            end
        end
        
        %plot(t,SigWav);
        %pause;
        
        waitbar(iRep/myNRep,h);
    end
    close (h)
    
    s=fseek(FidOutPk,0,'bof');
    s=fseek(FidOutPk,170,'bof');
    c=fwrite(FidOutPk,floor(myPkCount),'uint32'); %Number of peaks
    fclose (FidIn);
    fclose (FidOutPk);
    
    NRep(iStimIdx)=myNRep;
    PkCount(iStimIdx)=myPkCount;
end


fname=fullfile(RootNameOut,'Count');
save(fname,'StimIdx','NRep','PkCount');


