function [Wav,Fs]=GetWav(RootName,StimIdx,TrialNo)
%GetWav -- Load the recorded waveforms
%
%Usage: [Wav,Fs]=GetWav(RootName,StimIdx,TrialNo)
%
%RootName : Name of the root directory for the data (eg, 'c:\data\g020613\#1')
%StimIdx : Index for stimulus (Scalar or a vector)
%TrialNo : Trial number(s) to retrieve
%Wav : Matrix or cell array for the waveforms.
%   If length(StimIdx) is 1, Wav is a matrix with a size of [NPts, NTrials].
%   Otherwise, Wav is a cell array, each cell containing a matrix as above.
%Fs : Sampling rate
%
%By SF, 060902


%Get information about the record
Info=GetRecordInfo(RootName);
StimIdxList=unique(Info.StimIndex(:,1));
[NTrialMat,x]=hist(Info.StimIndex(:,1),StimIdxList);

%Default
if nargin<3
    TrialNo=1:max(NTrialMat);
    if nargin<2
        StimIdx=1:max(StimIdxList);
    end
end

nStimIdx=length(StimIdx);
nTrialNo=length(TrialNo);

Wav=cell(1,nStimIdx); %Initialize
if nStimIdx>1
    h=waitbar(0,'Loading ...');
    Count=0;
end
for iStimIdx=1:nStimIdx
    myStimIdx=StimIdx(iStimIdx);
    
    %Total number of trials and number of points for one waveform
    I=find(Info.StimIndex(:,1)==myStimIdx);
    NTrial=length(I);
    NPts=Info.StimIndex(I(1),2);
    
    %Initialize the matrix
    myWav=zeros(NPts,nTrialNo)+NaN;
    
    %Load the data
    fname=fullfile(RootName,sprintf('%03d.raw',myStimIdx));
    fid=fopen(fname,'rb');
    for iTrialNo=1:nTrialNo
        myTrialNo=TrialNo(iTrialNo);
        
        %Move to the top of the trial
        offset=(myTrialNo-1)*(NPts+2)*2;
        fseek(fid,offset,'bof');
        
        %Read the data
        %Note that the first two points are dummy numbers [-9999 9999]
        %indicating beginning of a trial
        [a,c]=fread(fid,[NPts+2 1],'int16');
        if c==NPts+2
            %Scale the waveform so that the amplitude represents mV
            a=a(3:end)/32767*Info.MaxVolt;
            myWav(:,iTrialNo)=a;
        end
        if nStimIdx>1   
            Count=Count+1;
            waitbar(Count/(nStimIdx*nTrialNo));
        end
    end %    for iTrialNo=1:nTrialNo

    if nStimIdx==1              %If only one stim is specified,
        Wav=myWav;              %return matrix,
    else                        %otherwise,
        Wav{iStimIdx}=myWav;    %cell array
    end
end %for iStimIdx=1:nStimIdx
if nStimIdx>1
    close(h);
end
%Sampling rate
Fs=Info.FsRA16;

