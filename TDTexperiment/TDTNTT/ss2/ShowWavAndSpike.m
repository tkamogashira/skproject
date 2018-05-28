function ShowWavAndSpike(RootName,StimIdx,TrialNo)
%ShowWavAndSpike -- Show a raw trace of a record and mark the selected
%spikes.
%
%<Input>
%RootName : Root name of the data, eg, 'D:\data\g021118\#6'
%StimIdx : (Scalar) Stimulus index
%TrialNo : (Scalar) Trial number
%
%Usage :  ShowWavAndSpike(RootName,StimIdx,TrialNo)
%By SF, 11/21/02

if length(StimIdx)~=1
    error('Only 1 StimIdx is allowed');
end
if length(TrialNo)~=1
    error('Only 1 TrialNo is allowed');
end

%Load wav
[Wav,Fs]=GetWavFilt(RootName,StimIdx,TrialNo);
Wav=resample(Wav,4,1);
Fs=Fs*4;

n=length(Wav);
t=(1:n)/Fs;
plot(t,Wav,'b-');
hold on

%Load spike register data
regfname=fullfile(RootName,'sort',sprintf('reg%03d',StimIdx));
load(regfname,'SReg');
nUnit=length(SReg);
MarkerCell={'r.','g.','m.','c.','r+','g+','m+','c+'};
for iUnit=1:nUnit
    myReg=SReg{iUnit};
    ITrial=find(myReg(:,1)==TrialNo);
    if ~isempty(ITrial)
        I=ceil(myReg(ITrial,2)/100000*Fs);
        plot(t(I),Wav(I),MarkerCell{iUnit});
    end
end
hold off


