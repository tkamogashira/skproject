%data plot

contra8902122_cf1498Hz=contra_data(1:6);
contra8703910_cf1345Hz=contra_data(7:82);
contra871027_cf2397Hz=contra_data(83:110);
contra8900739_cf2470Hz=contra_data(111:116);
contra870399_cf7184Hz=contra_data(117:140);
contra8914127_cf2018Hz=contra_data(141:161);
contra8810715_cf1345Hz=contra_data(162:175);
contra8709127_cf10508Hz=contra_data(176:184);
contra8915116_cf840Hz=contra_data(185:279);

G=contra8915116_cf840Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'k^','markersize',5,'markerfacecolor','k');hold on;
end;
G=contra8703910_cf1345Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'bv','markersize',5);hold on;
end;
G=contra8810715_cf1345Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'b^','markersize',5,'markerfacecolor','b');hold on;
end;
G=contra8902122_cf1498Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'cv','markersize',5);hold on;
end;
G=contra8914127_cf2018Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'c^','markersize',5,'markerfacecolor','c');hold on;
end;
G=contra871027_cf2397Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'gv','markersize',5);hold on;
end;
G=contra8900739_cf2470Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'g^','markersize',5,'markerfacecolor','g');hold on;
end;
G=contra870399_cf7184Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'rv','markersize',5);hold on;
end;
G=contra8709127_cf10508Hz;
for n=1:length(G)
    semilogx(G(n).cf,G(n).al_from_ml,'r^','markersize',5,'markerfacecolor','r');hold on;
end;


CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);
% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);

set(HdlA,'units','centimeters','position',[2 15.5 6 6],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel('CF (Hz)','fontsize',8);xlim([500 20000]);
ylabel('Axonal length from ML (\mum)','fontsize',8);ylim([4000 7500]);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')

box off;
close(CurFig);

%mean and SD
hold off;figure

G=contra8915116_cf840Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','^','color','k','markerfacecolor','k');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','k');hold on;
clear Mean;clear Std;

G=contra8703910_cf1345Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','v','color','b');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','b');hold on;
clear Mean;clear Std;

G=contra8810715_cf1345Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','^','color','b','markerfacecolor','b');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','b');hold on;
clear Mean;clear Std;

G=contra8902122_cf1498Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','v','color','c');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','c');hold on;
clear Mean;clear Std;

G=contra8914127_cf2018Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','^','color','c','markerfacecolor','c');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','c');hold on;
clear Mean;clear Std;

G=contra871027_cf2397Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','v','color','g');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','g');hold on;
clear Mean;clear Std;

G=contra8900739_cf2470Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','^','color','g','markerfacecolor','g');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','g');hold on;
clear Mean;clear Std;

G=contra870399_cf7184Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','v','color','r');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','r');hold on;
clear Mean;clear Std;

G=contra8709127_cf10508Hz;
Mean=mean([G.al_from_ml]);
Std=std([G.al_from_ml]);
semilogx(G(1).cf,Mean,'marker','^','color','r','markerfacecolor','r');hold on;
line([G(1).cf G(1).cf],[Mean-Std Mean+Std],'marker','none','color','r');hold on;
clear Mean;clear Std;

CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 8 6 6],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel('CF (Hz)','fontsize',8);xlim([500 20000]);
ylabel('Axonal length from ML (\mum)','fontsize',8);ylim([4000 7500]);
set(findobj(gca,'Type','line'),'markersize',8);
%Hdls=get(HdlA,'children')
box off;

close(CurFig);




