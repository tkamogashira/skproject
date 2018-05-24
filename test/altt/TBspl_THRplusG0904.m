D1_Ac(57).PSTHtype='O';
G=D1_Ac([1:6 8:9 11:17 19:83]);

figure %fig1
for n=1:length(G)
    semilogx(G(n).thrfreq,G(n).thrthr,'k');hold on
end;

semilogx([100 300 500 1000 2000 4000 8000 16000 32000 40000 50000 60000],...
    [42 29 19 6 3.4 2.7 5.4 5.3 16.5 22 40 66],'kO-');

hold off;


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

figure %fig2
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','x','color','k','markersize',12);hold on;
    end;
end;
%'markers',{'+','^','o','*','s','s','s','s','x'}, 'colors',{'k','k','k','k','k','b','g','r','k'})

figure %fig3
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','s','color','k','markersize',12);hold on;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).SR,'marker','x','color','k','markersize',12);hold on;
    end;
end;

figure %fig4
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','s','color','k','markersize',12);hold on;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq10,'marker','x','color','k','markersize',12);hold on;
    end;
end;

figure %fig5
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','s','color','k','markersize',12);hold on;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).thrq40,'marker','x','color','k','markersize',12);hold on;
    end;
end;

figure %fig6
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        H1=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H1,'marker','+','color','k','markersize',12);hold on;
        clear H1;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        H2=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H2,'marker','^','color','k','markersize',12);hold on;
        clear H2;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        H3=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H3,'marker','o','color','k','markersize',12);hold on;
        clear H3;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        H4=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H4,'marker','*','color','k','markersize',12);hold on;
        clear H4;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        H5=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H5,'marker','s','color','k','markersize',12);hold on;
        clear H5;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        H6=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H6,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
        clear H6;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %H7_1=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        %set(H7_1,'marker','s','color','k','markersize',12);hold on;
        %H7_2=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        %set(H7_2,'marker','s','color','k','markersize',6);hold on;
        %clear H7_1;clear H7_2;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        H8=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H8,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
        clear H8;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        H9=johnson(D1_Ac(k).CF,D1_Ac(k).maxR);hold on;grid on
        set(H9,'marker','x','color','k','markersize',12);hold on;
        clear H9;
    end;
end;

figure %fig7
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','s','color','k','markersize',12);hold on;
        %semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        semilogx(D1_Ac(k).CF,D1_Ac(k).depth,'marker','x','color','k','markersize',12);hold on;
    end;
end;

%ipsi
figure %fig8
for k=1:length(D1_Ac)
    if D1_Ac(k).RecSide == D1_Ac(k).StimSide
        if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','+','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','^','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','o','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','*','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
        %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
            %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
            %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',6);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','x','color','k','markersize',12);hold on;
        end;
    end;
end;

%contra
figure %fig9
for k=1:length(D1_Ac)
    if D1_Ac(k).RecSide ~= D1_Ac(k).StimSide
        if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','+','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','^','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','o','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','*','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
        %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
            %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',12);hold on;
            %semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markersize',6);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
        elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
            semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','x','color','k','markersize',12);hold on;
        end;
    end;
end;

figure %fig10
for k=1:length(D1_Ac)
    if D1_Ac(k).RecSide == D1_Ac(k).StimSide & strcmp(D1_Ac(k).PSTHtype,'HITH')==0
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','o','color','k','markerfacecolor','k','markersize',12);hold on;%ipsi
    elseif D1_Ac(k).RecSide ~= D1_Ac(k).StimSide & strcmp(D1_Ac(k).PSTHtype,'HITH')==0
        semilogx(D1_Ac(k).CF,D1_Ac(k).THR,'marker','o','color','k','markersize',12);hold on;%contra
    end;
end;
