D1_Ac(57).PSTHtype='O';

for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    %D1_Ac(k).RCDR=T.rc.fit.dynrange;
    [maxC,maxI]=max(T.rc.rate);[minC,minI]=min(T.rc.rate);
    D1_Ac(k).RCDR=(T.rc.db(maxI))-(T.rc.db(minI));
    clear T;clear maxI;clear minI;
end;

D1_Ac_PHL=structfilter(D1_Ac,'strcmp($PSTHtype$,''PHL'')');
D1_Ac_PLN=structfilter(D1_Ac,'strcmp($PSTHtype$,''PLN'')');
D1_Ac_PL=structfilter(D1_Ac,'strcmp($PSTHtype$,''PL'')');
D1_Ac_C=structfilter(D1_Ac,'strcmp($PSTHtype$,''C'')');
D1_Ac_O=structfilter(D1_Ac,'strcmp($PSTHtype$,''O'')');
D1_Ac_Oi=structfilter(D1_Ac,'strcmp($PSTHtype$,''Oi'')');
%D1_Ac_OL=structfilter(D1_Ac,'strcmp($PSTHtype$,''OL'')');
D1_Ac_Oc=structfilter(D1_Ac,'strcmp($PSTHtype$,''Oc'')');
D1_Ac_X=structfilter(D1_Ac,'strcmp($PSTHtype$,''X'')');
D1_Ac_HITH=structfilter(D1_Ac,'strcmp($PSTHtype$,''HITH'')');

drmean_PHL=mean(structfield(D1_Ac_PHL,'RCDR'))
drstd_PHL=std(structfield(D1_Ac_PHL,'RCDR'))

drmean_PLN=mean(structfield(D1_Ac_PLN,'RCDR'))
drstd_PLN=std(structfield(D1_Ac_PLN,'RCDR'))

drmean_PL=mean(structfield(D1_Ac_PL,'RCDR'))
drstd_PL=std(structfield(D1_Ac_PL,'RCDR'))

drmean_C=mean(structfield(D1_Ac_C,'RCDR'))
drstd_C=std(structfield(D1_Ac_C,'RCDR'))

drmean_O=mean(structfield(D1_Ac_O,'RCDR'))
drstd_O=std(structfield(D1_Ac_O,'RCDR'))

drmean_Oi=mean(structfield(D1_Ac_Oi,'RCDR'))
drstd_Oi=std(structfield(D1_Ac_Oi,'RCDR'))

drmean_Oc=mean(structfield(D1_Ac_Oc,'RCDR'))
drstd_Oc=std(structfield(D1_Ac_Oc,'RCDR'))

drmean_X=mean(structfield(D1_Ac_X,'RCDR'))
drstd_X=std(structfield(D1_Ac_X,'RCDR'))


