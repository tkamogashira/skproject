D1_Ac(57).PSTHtype='O';

for k=1:length(D1_Ac)
    T=EvalRC(dataset(D1_Ac(k).ds1.filename,D1_Ac(k).ds1.seqid),'plot','no');
    D1_Ac(k).accfrac=T.rc.fit.accfrac;
    if D1_Ac(k).accfrac>=0.95
        D1_Ac(k).RCDR=T.rc.fit.dynrange;
    else
        D1_Ac(k).RCDR=NaN;
    end;
    %[maxC,maxI]=max(T.rc.rate);[minC,minI]=min(T.rc.rate);
    %D1_Ac(k).RCDR=(T.rc.db(maxI))-(T.rc.db(minI));
    clear T;%clear maxI;clear minI;
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

z=structfield(D1_Ac_PHL,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_PHL=mean(z(zi))
drstd_PHL=std(z(zi))

z=structfield(D1_Ac_PLN,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_PLN=mean(z(zi))
drstd_PLN=std(z(zi))

z=structfield(D1_Ac_PL,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_PL=mean(z(zi))
drstd_PL=std(z(zi))

z=structfield(D1_Ac_C,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_C=mean(z(zi))
drstd_C=std(z(zi))

z=structfield(D1_Ac_O,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_O=mean(z(zi))
drstd_O=std(z(zi))

z=structfield(D1_Ac_Oi,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_Oi=mean(z(zi))
drstd_Oi=std(z(zi))

z=structfield(D1_Ac_Oc,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_Oc=mean(z(zi))
drstd_Oc=std(z(zi))

z=structfield(D1_Ac_X,'RCDR');zi=find(isfinite(z)==1&z>0);
drmean_X=mean(z(zi))
drstd_X=std(z(zi))




