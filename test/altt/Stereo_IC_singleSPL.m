echo on
for k=1:211
    display(k)
    ds=dataset(BBICselectWithCF(k).ds1.filename,BBICselectWithCF(k).ds1.seqid);
    BBICselectWithCF(k).spl=ds.stimulus.StimParam.SPL(1);
    BBICselectWithCF(k).SPL=ds.stimulus.StimParam.SPL;
    clear ds;
end;
%different SPL??
BBICselectWithCF(24).spl=NaN;
BBICselectWithCF(25).spl=NaN;
BBICselectWithCF(208).spl=NaN;
BBICselectWithCF(209).spl=NaN;
BBICselectWithCF(211).spl=NaN;
%
for k=212:length(BBICselectWithCF)
    display(k)
    ds=dataset(BBICselectWithCF(k).ds1.filename,BBICselectWithCF(k).ds1.seqid);
    aa=ds.StimParam.indiv.stim(1);
    BBICselectWithCF(k).spl=aa{1,1}.spl;
    clear ds;clear aa;
end;
echo off;

BBICselectWithCF_70db=structfilter(BBICselectWithCF,'$spl$==70');
BBICselectWithCF_60db=structfilter(BBICselectWithCF,'$spl$==60');
BBICselectWithCF_50db=structfilter(BBICselectWithCF,'$spl$==50');
BBICselectWithCF_40db=structfilter(BBICselectWithCF,'$spl$==40');
BBICselectWithCF_30db=structfilter(BBICselectWithCF,'$spl$==30');


