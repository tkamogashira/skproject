for m=1:length(D1_AcType)
    for k=1:length(Dthr186)
        if strcmp(Dthr186(k).ds.filename,D1_AcType(m).thrfile)==1&strcmp(Dthr186(k).ds.seqid,D1_AcType(m).thrds)==1
            plot(Dthr186(k).thr.freq,Dthr186(k).thr.thr,'b-');hold on
            plot(D1_AcType(m).CF,D1_AcType(m).THR,'ro');hold on
        end;
    end;
end;

DA=D(1:35);
for n=1:length(DA)
    if DA(n).CF-DA(n).StimFreq>-1&DA(n).CF-DA(n).StimFreq<1
        plot(DA(n).thrfreq,DA(n).thrthr,'c-');hold on
        plot(DA(n).CF,DA(n).THR,'mo');hold on
    end;
end;