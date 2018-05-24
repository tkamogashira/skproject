

for n=1:length(D1_AcType)
    for k=1:length(Dthr186)
        if strcmp(D1_AcType(n).thrfile,Dthr186(k).ds.filename)==1&strcmp(D1_AcType(n).thrds,Dthr186(k).ds.seqid)==1
            D1_AcType(n).TAG=Dthr186(k).tag;
        end;
    end;
    if D1_AcType(n).TAG==0
        THR=evalthr(dataset(D1_AcType(n).thrfile,D1_AcType(n).thrds));close all
        D1_AcType(n).thrfreq=THR.thr.freq;
        D1_AcType(n).thrthr=THR.thr.thr;
        D1_AcType(n).thrcf=THR.thr.cf;
        D1_AcType(n).thrminthr=THR.thr.minthr;
        D1_AcType(n).thrq10=THR.thr.q10;
        
        clear THR
        [CF,SR,minThr,BW,Qfactor]=evalthr(dataset(D1_AcType(n).thrfile,D1_AcType(n).thrds),'thr',40);close all
        D1_AcType(n).thrq40=Qfactor;
        D1_AcType(n).SR=SR;
    else
        D1_AcType(n).thrfreq=NaN;
        D1_AcType(n).thrthr=NaN;
        D1_AcType(n).thrcf=NaN;
        D1_AcType(n).thrminthr=NaN;
        D1_AcType(n).thrq10=NaN;
        D1_AcType(n).SR=NaN;
        D1_AcType(n).thrq40=NaN;
        D1_AcType(n).SR=NaN;
    end;
end;
