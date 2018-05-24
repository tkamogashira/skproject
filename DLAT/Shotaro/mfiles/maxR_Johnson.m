D1_ABcType_PHL=structfilter(D1_ABcType,'strcmp($PSTHtype$,''PHL'')');
D1_ABcType_PLN=structfilter(D1_ABcType,'strcmp($PSTHtype$,''PLN'')');
D1_ABcType_PL=structfilter(D1_ABcType,'strcmp($PSTHtype$,''PL'')');
D1_ABcType_C=structfilter(D1_ABcType,'strcmp($PSTHtype$,''C'')');
D1_ABcType_O=structfilter(D1_ABcType,'strcmp($PSTHtype$,''O'')');
D1_ABcType_Oi=structfilter(D1_ABcType,'strcmp($PSTHtype$,''Oi'')');
D1_ABcType_OL=structfilter(D1_ABcType,'strcmp($PSTHtype$,''OL'')');
D1_ABcType_Oc=structfilter(D1_ABcType,'strcmp($PSTHtype$,''Oc'')');
D1_ABcType_X=structfilter(D1_ABcType,'strcmp($PSTHtype$,''X'')');
D1_ABcType_HITH=structfilter(D1_ABcType,'strcmp($PSTHtype$,''HITH'')');

for n=1:length(D1_ABcType_PHL)
    H=johnson(D1_ABcType_PHL(n).CF,D1_ABcType_PHL(n).maxR);hold on;grid on
    set(H,'Marker','+','Color','k');
end;
for n=1:length(D1_ABcType_PLN)
    H=johnson(D1_ABcType_PLN(n).CF,D1_ABcType_PLN(n).maxR);hold on;grid on
    set(H,'Marker','^','Color','k');
end;
for n=1:length(D1_ABcType_PL)
    H=johnson(D1_ABcType_PL(n).CF,D1_ABcType_PL(n).maxR);hold on;grid on
    set(H,'Marker','o','Color','k');
end;
for n=1:length(D1_ABcType_C)
    H=johnson(D1_ABcType_C(n).CF,D1_ABcType_C(n).maxR);hold on;grid on
    set(H,'Marker','*','Color','k');
end;
for n=1:length(D1_ABcType_O)
    H=johnson(D1_ABcType_O(n).CF,D1_ABcType_O(n).maxR);hold on;grid on
    set(H,'Marker','s','Color','k');
end;
for n=1:length(D1_ABcType_Oi)
    H=johnson(D1_ABcType_Oi(n).CF,D1_ABcType_Oi(n).maxR);hold on;grid on
    set(H,'Marker','s','Color','b');
end;
for n=1:length(D1_ABcType_OL)
    H=johnson(D1_ABcType_OL(n).CF,D1_ABcType_OL(n).maxR);hold on;grid on
    set(H,'Marker','s','Color','g');
end;
for n=1:length(D1_ABcType_Oc)
    H=johnson(D1_ABcType_Oc(n).CF,D1_ABcType_Oc(n).maxR);hold on;grid on
    set(H,'Marker','s','Color','r');
end;
for n=1:length(D1_ABcType_X)
    H=johnson(D1_ABcType_X(n).CF,D1_ABcType_X(n).maxR);hold on;grid on
    set(H,'Marker','x','Color','k');
end;

xlabel('CF');ylabel('Significant maxR');



