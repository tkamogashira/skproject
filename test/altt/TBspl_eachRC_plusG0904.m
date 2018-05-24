D1_Ac(57).PSTHtype='O';
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        plot(normspl,normrate,'marker','+','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        plot(normspl,normrate,'marker','^','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;    
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        plot(normspl,normrate,'marker','o','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'C')==1;
        plot(normspl,normrate,'marker','*','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'O')==1;
        plot(normspl,normrate,'marker','s','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        plot(normspl,normrate,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
%figure
%for k=1:length(D1_Ac)
    %T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    %normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    %normrate=T.rc.rate/max(T.rc.rate);
    %if strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %plot(normspl,normrate,'marker','s','color','k','markersize',12);hold on;
        %plot(normspl,normrate,'marker','s','color','k','markersize',6);hold on;
    %end;clear T;clear normspl;clear normrate;
%end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        plot(normspl,normrate,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;
figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    normspl=T.rc.db-ones(1,length(T.rc.db))*D1_Ac(k).THR;
    normrate=T.rc.rate/max(T.rc.rate);
    if strcmp(D1_Ac(k).PSTHtype,'X')==1;
        plot(normspl,normrate,'marker','x','color','k','markersize',12);hold on;
    end;clear T;clear normspl;clear normrate;
end;hold off;