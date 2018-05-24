figure
for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        plot(T.rc.db,T.rc.rate,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        plot(T.rc.db,T.rc.rate,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        plot(T.rc.db,T.rc.rate,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        plot(T.rc.db,T.rc.rate,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        plot(T.rc.db,T.rc.rate,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        plot(T.rc.db,T.rc.rate,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        plot(T.rc.db,T.rc.rate,'marker','s','color','k','markersize',12);hold on;
        plot(T.rc.db,T.rc.rate,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        plot(T.rc.db,T.rc.rate,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        plot(T.rc.db,T.rc.rate,'marker','x','color','k','markersize',12);hold on;
    end;
    clear T;
end;