function [StimIdx,pst]=MakeStimAndPstEz(DataRoot)
%MakeStimAndPstEz -- Merge the REG files for data by the TDT system.
%For given DataRoot (e.g.,'D:\data\g020613\#1'),
%obtain STIMIDX and PST. The root directory DataRoot should contain
%Info.txt. Also, assume that the directory 
%'sort' under DataRoot contains reg files.
%
%By SF, 12/18/02
%Usage: [StimIdx,pst]=MakeStimAndPstEz(DataRoot)


%Define data directories and get stim information
SortRoot=fullfile(DataRoot,'sort');
if exist(SortRoot,'dir')~=7
    StimIdx=NaN;
    pst=NaN;
    disp([DataRoot 'does not exist']);
    return;
end

%No of repetition
Rtn=GetRecordInfo(DataRoot);
myStimIdx=Rtn.StimIndex;
StimIdxList=1:max(myStimIdx(:,1));
NRepMat=hist(myStimIdx(:,1),StimIdxList);
NRep=min(NRepMat(:));
NCond=length(StimIdxList);
StimIdx=myStimIdx(:,1)';

%Load the data and save them in a PST matrix
for iCond=1:NCond
    Idx=StimIdxList(iCond);
    regfname=fullfile(SortRoot,sprintf('reg%03d',Idx));
    load(regfname,'SReg');
    if iCond==1
        NUnit=length(SReg);
        pst=cell(1,NUnit);
        [pst{:}]=deal(zeros(1,NRep*NCond));
    end
    for iUnit=1:NUnit
        mypst=reg2pst(SReg{iUnit},NRep);
        n=size(mypst,1);
        I=find(StimIdx==Idx);
        I=I(I<=NRep*NCond);
        %keyboard
        pst{iUnit}(1:n,I)=mypst;
    end
end

%Check Stability
for iUnit=1:NUnit
    mypst=pst{iUnit};
    cnt=mean(reshape(sum(mypst>0),[NRep,NCond]),2);
    myBlockRange=1:NRep;
    
    plot(cnt,'.-')
    myylim=ylim;
    myylim(1)=0;
    ylim(myylim);
    xlabel('Trial Number');
    ylabel('Mean Spike Count');
    drawnow
    if min(cnt)*3<max(cnt)
        disp([DataRoot ' Unit ' num2str(iUnit)]);
        rng=input('Unstable recording. Select range to use (0 for use all; Defult None): ');
        if ~isempty(rng)
            if ~rng(1)
                rng=1:NRep;
            end
        end
        myBlockRange=intersect(rng,1:NRep);
    end
    BlockRange{iUnit}=myBlockRange;
end

save(fullfile(DataRoot,'STIMIDX&PST'),'StimIdx','pst','BlockRange');
if exist('ParamList','var')
    save(fullfile(DataRoot,'STIMIDX&PST'),'ParamList','-append');
end        
