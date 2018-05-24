for n=1:length(NRHO590)
    NRHO590(n).PSTHtypeCF='none';
    NRHO590(n).PSTHtypeDS='none';
    for k=1:length(D1_ABcType)
        if strcmp(NRHO590(n).thrds,D1_ABcType(k).thrds)==1
            NRHO590(n).PSTHtypeCF=D1_ABcType(k).PSTHtype;
            NRHO590(n).PSTHtypeDS=D1_ABcType(k).ds1.seqid;
        end;
    end;
    
end;

NRHO590type=structfilter(NRHO590,'strcmp($PSTHtypeCF$,''none'')==0');
NRHO590typeAB=structfilter(NRHO590type,'strcmp($Evalisi$,''A'')==1 | strcmp($Evalisi$,''B'')==1');
NRHO590typeAB1000=structfilter(NRHO590typeAB,'$burstDur$==1000');

for m=1:length(NRHO590typeAB1000)
    binwidth=0.05;Ntrial=100;AnaWindow=[50 1000];
    ds=dataset(NRHO590typeAB1000(m).ds1.filename,NRHO590typeAB1000(m).ds1.seqid);
    SPT = AnWin(ds, AnaWindow);
    N=size(SPT);
    PS=[];
    for k=1:N(1)
        SPTs = SPT(k,:);
        [p, NcoScrambled, Ppdf, Pcdf, Nco] = SACPeakSign(SPTs, binwidth, Ntrial);
        ps=p;
        PS=[PS ps];
    end;
    NRHO590typeAB1000(m).ConfidenceLevel=PS;
    disp(m)
end;


%structplot(NRHO590typeAB1000,'CF','ac.max')
%structplot(NRHO590typeAB1000,'CF','diff.max')

NRHO590typeAB1000_PHL=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''PHL'')');
NRHO590typeAB1000_PLN=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''PLN'')');
NRHO590typeAB1000_PL=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''PL'')');
NRHO590typeAB1000_C=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''C'')');
NRHO590typeAB1000_O=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''O'')');
NRHO590typeAB1000_Oi=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''Oi'')');
NRHO590typeAB1000_OL=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''OL'')');
NRHO590typeAB1000_Oc=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''Oc'')');
NRHO590typeAB1000_X=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''X'')');
NRHO590typeAB1000_HITH=structfilter(NRHO590typeAB1000,'strcmp($PSTHtypeCF$,''HITH'')');

structplot(...
    NRHO590typeAB1000_PLN,'CF','ac.max',...
    ...
    NRHO590typeAB1000_C,'CF','ac.max',...
    NRHO590typeAB1000_O,'CF','ac.max',...
    NRHO590typeAB1000_Oi,'CF','ac.max',...
    NRHO590typeAB1000_OL,'CF','ac.max',...
    ...
    NRHO590typeAB1000_X,'CF','ac.max',...
    'markers',{'^','*','s','s','s','x'}, 'Colors',{'k','k','k','b','g','k'})

structplot(...
    NRHO590typeAB1000_PLN,'CF','diff.max',...
    ...
    NRHO590typeAB1000_C,'CF','diff.max',...
    NRHO590typeAB1000_O,'CF','diff.max',...
    NRHO590typeAB1000_Oi,'CF','diff.max',...
    NRHO590typeAB1000_OL,'CF','diff.max',...
    ...
    NRHO590typeAB1000_X,'CF','diff.max',...
    'markers',{'^','*','s','s','s','x'}, 'Colors',{'k','k','k','b','g','k'})





