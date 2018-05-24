sacxac615_A1000(74).PSTHtype='X';

%sac plot
for k=1:length(sacxac615_A1000)
    if strcmp(sacxac615_A1000(k).PSTHtype,'PHL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PLN')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'C')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'O')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oi')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    %elseif strcmp(sacxac615_A1000(k).PSTHtype,'OL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        %semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','s','color','k','markersize',12);hold on;
        %semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oc')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'X')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','x','color','k','markersize',12);hold on;
    elseif isnan(sacxac615_A1000(k).PSTHtype)==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).ac.max,'marker','d','color','k','markersize',12);hold on;
    end;
end;

for n=1:length(sacxac615_A1000)
    if min(sacxac615_A1000(n).ConfidenceLevel)>0.99
        group=[];
        for m=1:length(sacxac615_A1000)
            if (strcmp(sacxac615_A1000(m).ds1.filename,sacxac615_A1000(n).ds1.filename))&...
                    (sacxac615_A1000(m).ds1.icell==sacxac615_A1000(n).ds1.icell)&...
                    (min(sacxac615_A1000(m).ConfidenceLevel)>0.99)
                group=[group;sacxac615_A1000(m)];
            end;
        end;
    
        groups=structsort(group,'$ac.max$');
        z=length(groups);
        line([groups(1).CF groups(z).CF],[groups(1).ac.max groups(z).ac.max],'color','k');hold on
        clear group;clear groups;
    end;
end;

%Compare with cat TB sac data
catTBsac=[[0.24;48] [0.59;45] [0.66;39] [1.1;20] [1.5;23] [1.6;8] [1.8;10] [1.9;9] [2;10] [2.2;12] [2.9;10] [3.5;7] [4.4;10] [5.1;11] [6.1;7] [6.9;6] [8.7;9] [13;8] [19;5] [20;5] [24;8] [29;5]];
x=catTBsac(1,:)*1000,y=catTBsac(2,:);
p = polyfit(x,y,6);
f = polyval(p,x);
%plot(x,y,'ro');hold on
plot(x,f,'k-');hold on
%Compare with cat AN sac data
catANsac=[[0.2;9.5] [0.25;10] [0.3;8] [0.4;8] [0.6;8] [1;7] [2;5] [3;4] [5;3] [10;2]];
x=catANsac(1,:)*1000,y=catANsac(2,:);
p = polyfit(x,y,6);
f = polyval(p,x);
%plot(x,y,'bo');hold on
plot(x,f,'k--');hold off

%difcor plot
figure

for k=1:length(sacxac615_A1000)
    if strcmp(sacxac615_A1000(k).PSTHtype,'PHL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PLN')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'C')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'O')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oi')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'OL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','s','color','k','markersize',12);hold on;
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oc')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'X')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','x','color','k','markersize',12);hold on;
    elseif isnan(sacxac615_A1000(k).PSTHtype)==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.max,'marker','d','color','k','markersize',12);hold on;
    end;
end;

for n=1:length(sacxac615_A1000)
    if min(sacxac615_A1000(n).ConfidenceLevel)>0.99
        group=[];
        for m=1:length(sacxac615_A1000)
            if (strcmp(sacxac615_A1000(m).ds1.filename,sacxac615_A1000(n).ds1.filename))&...
                    (sacxac615_A1000(m).ds1.icell==sacxac615_A1000(n).ds1.icell)&...
                    (min(sacxac615_A1000(m).ConfidenceLevel)>0.99)
                group=[group;sacxac615_A1000(m)];
            end;
        end;
    
        groups=structsort(group,'$diff.max$');
        z=length(groups);
        line([groups(1).CF groups(z).CF],[groups(1).diff.max groups(z).diff.max],'color','k');hold on
        clear group;clear groups;
    end;
end;

%Compare with cat TB difcor data
catTBdiff=[[0.24;47] [0.29;38] [0.31;23] [0.55;22] [0.61;18] [0.67;24] [0.7;17] [0.73;5] [0.88;4] [0.99;15] [1.05;16] [1.2;16] [1.3;16] [1.5;6] [1.8;5] [2.05;9] [2.7;4] [3;5] [3.7;3] [4.3;5] [5;1] [6.5;1] [7.5;1] [9;0.5] [10;0.5]];
x=catTBdiff(1,:)*1000,y=catTBdiff(2,:);
p = polyfit(x,y,6);
f = polyval(p,x);
%plot(x,y,'ro');hold on
plot(x,f,'k-');hold on
%Compare with cat AN difcor data
catANdiff=[[0.2;10] [0.35;10] [0.5;9] [0.7;8] [0.85;7] [2;5] [3;3] [4;2] [5;1] [10;0.5]];
x=catANdiff(1,:)*1000,y=catANdiff(2,:);
p = polyfit(x,y,6);
f = polyval(p,x);
%plot(x,y,'bo');hold on
plot(x,f,'k--');hold off

%df plot
figure

for k=1:length(sacxac615_A1000)
    if strcmp(sacxac615_A1000(k).PSTHtype,'PHL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','+','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PLN')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','^','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'PL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','o','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'C')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','*','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'O')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','s','color','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oi')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'OL')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','s','color','k','markersize',12);hold on;
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','s','color','k','markersize',6);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'Oc')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
    elseif strcmp(sacxac615_A1000(k).PSTHtype,'X')==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','x','color','k','markersize',12);hold on;
    elseif isnan(sacxac615_A1000(k).PSTHtype)==1 & min(sacxac615_A1000(k).ConfidenceLevel)>0.99
        semilogx(sacxac615_A1000(k).CF,sacxac615_A1000(k).diff.fft.df,'marker','d','color','k','markersize',12);hold on;
    end;
end;

for n=1:length(sacxac615_A1000)
    if min(sacxac615_A1000(n).ConfidenceLevel)>0.99
        group=[];
        for m=1:length(sacxac615_A1000)
            if (strcmp(sacxac615_A1000(m).ds1.filename,sacxac615_A1000(n).ds1.filename))&...
                    (sacxac615_A1000(m).ds1.icell==sacxac615_A1000(n).ds1.icell)&...
                    (min(sacxac615_A1000(m).ConfidenceLevel)>0.99)
                group=[group;sacxac615_A1000(m)];
            end;
        end;
    
        groups=structsort(group,'$diff.fft.df$');
        z=length(groups);
        line([groups(1).CF groups(z).CF],[groups(1).diff.fft.df groups(z).diff.fft.df],'color','k');hold on
        clear group;clear groups;
    end;
end;
line([100 100000],[100 100000],'color','k');