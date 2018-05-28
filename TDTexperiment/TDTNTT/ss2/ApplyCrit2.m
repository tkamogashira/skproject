function ApplyCrit2(PkRoot,FileIdx,SortRoot,CritFName)
%Example
%Root='d:\data\g010704\unit2_adapt';
%PkRoot=fullfile(Root,'peaks');
%FileIdx=0:107;
%SortRoot=fullfile(Root,'sort');
%CritFName=fullfile(Root,'Criterion');
%
%Usage -- ApplyCrit2(PkRoot,FileIdx,SortRoot,CritFName)


%Load template and criterion RSSD
load (CritFName,'Template','IRange','CutRSSD');
if iscell(Template)
    NUnit=length(Template);
    myTemplate=Template;
    myIRange=IRange;
    myCutRSSD=CutRSSD;
else
    NUnit=1;
    myTemplate={Template};
    myIRange={IRange};
    myCutRSSD={CutRSSD};
end



for iFile=1:length(FileIdx)
    SReg=cell(1,NUnit);
    for iUnit=1:NUnit
        
        myTemp=myTemplate{iUnit};
        myTemp=myTemp(myIRange{iUnit});
        
        PkFile=fullfile(PkRoot,sprintf('%03d.pk',FileIdx(iFile))); %Peak file name
        SortFile=fullfile(SortRoot,sprintf('reg%03d',FileIdx(iFile)));
        disp([PkFile ' => ' SortFile]);
        
        [peakmat, reg, srate]=pkload2(PkFile, 1); %Load 
        peakmat=peakmat(myIRange{iUnit},:); %Use the specified range only
        npeaks=size(peakmat,2);
        RSSD=sqrt(sum((peakmat-repmat(myTemp(:),[1 npeaks])).^2)); %Compute RSSD
        Igood=find(RSSD<myCutRSSD{iUnit}); %Peak that clears the criterion
        SReg{iUnit}=reg(Igood,:); %Keep it in a cell array
    end
    save(SortFile,'SReg');
end
%end


