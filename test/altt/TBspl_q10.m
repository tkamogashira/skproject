%New data
D1_A=structfilter(D,'strcmp($Evalisi$,''A'')');
D1_Ac=structfilter(D1_A,'$CF$-$StimFreq$>-1 & $CF$-$StimFreq$<1');
assignin('base','D1_Ac',D1_Ac);
figure        
for n=1:length(D1_Ac)
    if D1_Ac(n).SR>18 %High SR
        semilogx(D1_Ac(n).CF,D1_Ac(n).thrq10,'co');hold on;grid on
    elseif D1_Ac(n).SR<=0.5 %Low SR
        semilogx(D1_Ac(n).CF,D1_Ac(n).thrq10,'c^');hold on;grid on
    else %Medium SR
        semilogx(D1_Ac(n).CF,D1_Ac(n).thrq10,'cx');hold on;grid on
    end;
end;
%Old data
for n=1:length(D1_AcType)
    if D1_AcType(n).SR>18 %High SR
        semilogx(D1_AcType(n).CF,D1_AcType(n).thrq10,'bo');hold on;grid on
    elseif D1_AcType(n).SR<=0.5 %Low SR
        semilogx(D1_AcType(n).CF,D1_AcType(n).thrq10,'b^');hold on;grid on
    else %Medium SR
        semilogx(D1_AcType(n).CF,D1_AcType(n).thrq10,'bx');hold on;grid on
    end;
end;
hold off


