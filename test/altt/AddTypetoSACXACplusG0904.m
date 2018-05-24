sacxac615_A=structfilter(sacxac615,'strncmp($Evalisi$,''A'',1)');

for k=1:length(sacxac615_A)
    sacxac615_A(k).PSTHtype=NaN;
    for n=1:length(D1_Ac)
        if (strcmp(D1_Ac(n).thrfile,sacxac615_A(k).thrfile)==1)&(strcmp(D1_Ac(n).thrds,sacxac615_A(k).thrds)==1)
            sacxac615_A(k).PSTHtype=D1_Ac(n).PSTHtype;
        end;
    end;
end;
    
