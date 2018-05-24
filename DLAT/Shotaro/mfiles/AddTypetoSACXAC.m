for n=1:length(sacxac585)
    sacxac585(n).PSTHtypeCF='none';
    sacxac585(n).PSTHtypeDS='none';
    for k=1:length(D1_ABcType)
        if strcmp(sacxac585(n).thrds,D1_ABcType(k).thrds)==1
            sacxac585(n).PSTHtypeCF=D1_ABcType(k).PSTHtype;
            sacxac585(n).PSTHtypeDS=D1_ABcType(k).ds1.seqid;
        end;
    end;
    
end;

sacxac585type=structfilter(sacxac585,'strcmp($PSTHtypeCF$,''none'')==0');
sacxac585typeAB=structfilter(sacxac585type,'strcmp($Evalisi$,''A'')==1 | strcmp($Evalisi$,''B'')==1');
sacxac585typeAB1000=structfilter(sacxac585typeAB,'$burstDur$==1000');

for m=1:length(sacxac585typeAB1000)
    binwidth=0.05;Ntrial=100;AnaWindow=[50 1000];
    ds=dataset(sacxac585typeAB1000(m).ds1.filename,sacxac585typeAB1000(m).ds1.seqid);
    SPT = AnWin(ds, AnaWindow);
    N=size(SPT);
    PS=[];
    for k=1:N(1)
        SPTs = SPT(k,:);
        [p, NcoScrambled, Ppdf, Pcdf, Nco] = SACPeakSign(SPTs, binwidth, Ntrial);
        ps=p;
        PS=[PS ps];
    end;
    sacxac585typeAB1000(m).ConfidenceLevel=PS;
    disp(m)
end;


%structplot(sacxac585typeAB1000,'CF','ac.max')
%structplot(sacxac585typeAB1000,'CF','diff.max')

sacxac585typeAB1000_PHL=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''PHL'')');
sacxac585typeAB1000_PLN=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''PLN'')');
sacxac585typeAB1000_PL=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''PL'')');
sacxac585typeAB1000_C=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''C'')');
sacxac585typeAB1000_O=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''O'')');
sacxac585typeAB1000_Oi=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''Oi'')');
sacxac585typeAB1000_OL=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''OL'')');
sacxac585typeAB1000_Oc=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''Oc'')');
sacxac585typeAB1000_X=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''X'')');
sacxac585typeAB1000_HITH=structfilter(sacxac585typeAB1000,'strcmp($PSTHtypeCF$,''HITH'')');

structplot(...
    sacxac585typeAB1000_PLN,'CF','ac.max',...
    ...
    sacxac585typeAB1000_C,'CF','ac.max',...
    sacxac585typeAB1000_O,'CF','ac.max',...
    sacxac585typeAB1000_Oi,'CF','ac.max',...
    sacxac585typeAB1000_OL,'CF','ac.max',...
    ...
    sacxac585typeAB1000_X,'CF','ac.max',...
    'markers',{'^','*','s','s','s','x'}, 'Colors',{'k','k','k','b','g','k'})

structplot(...
    sacxac585typeAB1000_PLN,'CF','diff.max',...
    ...
    sacxac585typeAB1000_C,'CF','diff.max',...
    sacxac585typeAB1000_O,'CF','diff.max',...
    sacxac585typeAB1000_Oi,'CF','diff.max',...
    sacxac585typeAB1000_OL,'CF','diff.max',...
    ...
    sacxac585typeAB1000_X,'CF','diff.max',...
    'markers',{'^','*','s','s','s','x'}, 'Colors',{'k','k','k','b','g','k'})





