for n=1:length(D1_ABcType)
    for k=1:length(Dthr186)
        if strcmp(Dthr186(k).ds.filename,D1_ABcType(n).thrfile)==1&...
                strcmp(Dthr186(k).ds.seqid,D1_ABcType(n).thrds)==1
            D1_ABcType(n).tag=Dthr186(k).tag;
        end;
    end;
    
    if D1_ABcType(n).tag==0
        THR=evalthr(dataset(D1_ABcType(n).thrfile,D1_ABcType(n).thrds));close all
        D1_ABcType(n).thrfreq=THR.thr.freq;
        D1_ABcType(n).thrthr=THR.thr.thr;
        D1_ABcType(n).thrcf=THR.thr.cf;
        D1_ABcType(n).thrminthr=THR.thr.minthr;
        D1_ABcType(n).thrq10=THR.thr.q10;
        clear THR
        [CF,SR,minThr,BW,Qfactor]=evalthr(dataset(D1_ABcType(n).thrfile,D1_ABcType(n).thrds),'thr',40);close all
        D1_ABcType(n).thrq40=Qfactor;
        
    end;
end;

for n=1:length(D1_ABcType)
    semilogx(D1_ABcType(n).thrfreq,D1_ABcType(n).thrthr,'b-');hold on
    semilogx(D1_ABcType(n).thrcf,D1_ABcType(n).thrminthr,'ro');hold on
    xlabel('Frequency');ylabel('SPL (dB)');
end;
hold off
figure
for n=1:length(D1_ABcType)
    semilogx(D1_ABcType(n).thrcf,D1_ABcType(n).thrq10,'bo');hold on
    semilogx(D1_ABcType(n).thrcf,D1_ABcType(n).thrq40,'ro');hold on
    xlabel('Frequency');ylabel('Q10 (Blue) & Q40 (Red)');
end;    