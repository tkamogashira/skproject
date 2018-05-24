%contra
for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
    
    contra_data(n).cp_z_rerp=contra_data(n).cp_z - contra_data(n).rp_z;
    contra_data(n).z_rerp=contra_data(n).z - contra_data(n).rp_z;
end;


contra8902122_cf1498Hz=contra_data(1:6);
contra8703910_cf1345Hz=contra_data(7:82);
contra871027_cf2397Hz=contra_data(83:110);
contra8900739_cf2470Hz=contra_data(111:116);
contra870399_cf7184Hz=contra_data(117:140);
contra8914127_cf2018Hz=contra_data(141:161);
contra8810715_cf1345Hz=contra_data(162:175);
contra8709127_cf10508Hz=contra_data(176:184);
contra8915116_cf840Hz=contra_data(185:279);


[Info, Slope, Yintercept] = structplotdata2(contra8915116_cf840Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(contra8915116_cf840Hz,'z_rerp'));
maxz=max(structfield(contra8915116_cf840Hz,'z_rerp'));
Maxz=max(structfield(contra8915116_cf840Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8915116_cf840Hz)
    contra8915116_cf840Hz(k).minCT=Slope*minz+Yintercept;
    contra8915116_cf840Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8915116_cf840Hz(k).MinCT=Yintercept;
    contra8915116_cf840Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8703910_cf1345Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8703910_cf1345Hz,'z_rerp'));
maxz=max(structfield(contra8703910_cf1345Hz,'z_rerp'));
Maxz=max(structfield(contra8703910_cf1345Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8703910_cf1345Hz)
    contra8703910_cf1345Hz(k).minCT=Slope*minz+Yintercept;
    contra8703910_cf1345Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8703910_cf1345Hz(k).MinCT=Yintercept;
    contra8703910_cf1345Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8810715_cf1345Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8810715_cf1345Hz,'z_rerp'));
maxz=max(structfield(contra8810715_cf1345Hz,'z_rerp'));
Maxz=max(structfield(contra8810715_cf1345Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8810715_cf1345Hz)
    contra8810715_cf1345Hz(k).minCT=Slope*minz+Yintercept;
    contra8810715_cf1345Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8810715_cf1345Hz(k).MinCT=Yintercept;
    contra8810715_cf1345Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8902122_cf1498Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8902122_cf1498Hz,'z_rerp'));
maxz=max(structfield(contra8902122_cf1498Hz,'z_rerp'));
Maxz=max(structfield(contra8902122_cf1498Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8902122_cf1498Hz)
    contra8902122_cf1498Hz(k).minCT=Slope*minz+Yintercept;
    contra8902122_cf1498Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8902122_cf1498Hz(k).MinCT=Yintercept;
    contra8902122_cf1498Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8914127_cf2018Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8914127_cf2018Hz,'z_rerp'));
maxz=max(structfield(contra8914127_cf2018Hz,'z_rerp'));
Maxz=max(structfield(contra8914127_cf2018Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8914127_cf2018Hz)
    contra8914127_cf2018Hz(k).minCT=Slope*minz+Yintercept;
    contra8914127_cf2018Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8914127_cf2018Hz(k).MinCT=Yintercept;
    contra8914127_cf2018Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra871027_cf2397Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra871027_cf2397Hz,'z_rerp'));
maxz=max(structfield(contra871027_cf2397Hz,'z_rerp'));
Maxz=max(structfield(contra871027_cf2397Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra871027_cf2397Hz)
    contra871027_cf2397Hz(k).minCT=Slope*minz+Yintercept;
    contra871027_cf2397Hz(k).maxCT=Slope*maxz+Yintercept;
    contra871027_cf2397Hz(k).MinCT=Yintercept;
    contra871027_cf2397Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8900739_cf2470Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8900739_cf2470Hz,'z_rerp'));
maxz=max(structfield(contra8900739_cf2470Hz,'z_rerp'));
Maxz=max(structfield(contra8900739_cf2470Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8900739_cf2470Hz)
    contra8900739_cf2470Hz(k).minCT=Slope*minz+Yintercept;
    contra8900739_cf2470Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8900739_cf2470Hz(k).MinCT=Yintercept;
    contra8900739_cf2470Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra870399_cf7184Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra870399_cf7184Hz,'z_rerp'));
maxz=max(structfield(contra870399_cf7184Hz,'z_rerp'));
Maxz=max(structfield(contra870399_cf7184Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra870399_cf7184Hz)
    contra870399_cf7184Hz(k).minCT=Slope*minz+Yintercept;
    contra870399_cf7184Hz(k).maxCT=Slope*maxz+Yintercept;
    contra870399_cf7184Hz(k).MinCT=Yintercept;
    contra870399_cf7184Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(contra8709127_cf10508Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
minz=min(structfield(contra8709127_cf10508Hz,'z_rerp'));
maxz=max(structfield(contra8709127_cf10508Hz,'z_rerp'));
Maxz=max(structfield(contra8709127_cf10508Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(contra8709127_cf10508Hz)
    contra8709127_cf10508Hz(k).minCT=Slope*minz+Yintercept;
    contra8709127_cf10508Hz(k).maxCT=Slope*maxz+Yintercept;
    contra8709127_cf10508Hz(k).MinCT=Yintercept;
    contra8709127_cf10508Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;



% Create template
scrsz = get(0,'ScreenSize')
FigHdl = figure('Units','centimeters','Position',[0 0 17.6 22]);

%contrafigure
structplot(contra8915116_cf840Hz,'z_rerp','ctsum',...
    contra8703910_cf1345Hz,'z_rerp','ctsum',...
    contra8810715_cf1345Hz,'z_rerp','ctsum',...
    contra8902122_cf1498Hz,'z_rerp','ctsum',...
    contra8914127_cf2018Hz,'z_rerp','ctsum',...
    contra871027_cf2397Hz,'z_rerp','ctsum',...
    contra8900739_cf2470Hz,'z_rerp','ctsum',...
    contra870399_cf7184Hz,'z_rerp','ctsum',...
    contra8709127_cf10508Hz,'z_rerp','ctsum',...
    'info','no','fit','linear','xlim',[0 5000],'ylim',[0.15 0.45],...
    'markers',{'^f','vw'},...
    'colors',{'k','b', 'b', 'c', 'c', 'g', 'g', 'r','r'});hold on;
plot(contra8915116_cf840Hz(1).cp_z_rerp,contra8915116_cf840Hz(1).MaxCT,'k*',...
    contra8703910_cf1345Hz(1).cp_z_rerp,   contra8703910_cf1345Hz(1).MaxCT,'b*',...
    contra8810715_cf1345Hz(1).cp_z_rerp,   contra8810715_cf1345Hz(1).MaxCT,'b*',...
    contra8902122_cf1498Hz(1).cp_z_rerp,   contra8902122_cf1498Hz(1).MaxCT,'c*',...
    contra8914127_cf2018Hz(1).cp_z_rerp,   contra8914127_cf2018Hz(1).MaxCT,'c*',...
    contra871027_cf2397Hz(1).cp_z_rerp,   contra871027_cf2397Hz(1).MaxCT,'g*',...
    contra8900739_cf2470Hz(1).cp_z_rerp,   contra8900739_cf2470Hz(1).MaxCT,'g*',...
    contra870399_cf7184Hz(1).cp_z_rerp,   contra870399_cf7184Hz(1).MaxCT,'r*',...
    contra8709127_cf10508Hz(1).cp_z_rerp,   contra8709127_cf10508Hz(1).MaxCT,'r*');
hold off;

set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 12 6 6],'fontsize',8);
axes(HdlA);
xlabel('Z-value from RP plane (\mum)','fontsize',8);
ylabel('Conduction time from ML to EP (ms)','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[2 8 6 3]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
%Hdls=get(HdlA,'children')
close(CurFig);



%ipsi
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
    
    ipsi_data(n).cp_z_rerp=ipsi_data(n).cp_z - ipsi_data(n).rp_z;
    ipsi_data(n).z_rerp=ipsi_data(n).z - ipsi_data(n).rp_z;
end;

ipsi8902122_cf1498Hz=ipsi_data(1:22);
ipsi8900739_cf2470Hz=ipsi_data(23:33);
ipsi8900743_cf2694Hz=ipsi_data(34:40);
ipsi9004315_cf2300Hz=ipsi_data(41:70);
ipsi8705624_cf1903Hz=ipsi_data(71:81);
ipsi8831120_cf200Hz=ipsi_data(82:117);
ipsi880113_cf5388Hz=ipsi_data(118:121);

[Info, Slope, Yintercept] = structplotdata2(ipsi8831120_cf200Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi8831120_cf200Hz,'z_rerp'));
maxz=max(structfield(ipsi8831120_cf200Hz,'z_rerp'));
Maxz=max(structfield(ipsi8831120_cf200Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi8831120_cf200Hz)
    ipsi8831120_cf200Hz(k).minCT=Slope*minz+Yintercept;
    ipsi8831120_cf200Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi8831120_cf200Hz(k).MinCT=Yintercept;
    ipsi8831120_cf200Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi8902122_cf1498Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi8902122_cf1498Hz,'z_rerp'));
maxz=max(structfield(ipsi8902122_cf1498Hz,'z_rerp'));
Maxz=max(structfield(ipsi8902122_cf1498Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi8902122_cf1498Hz)
    ipsi8902122_cf1498Hz(k).minCT=Slope*minz+Yintercept;
    ipsi8902122_cf1498Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi8902122_cf1498Hz(k).MinCT=Yintercept;
    ipsi8902122_cf1498Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi8705624_cf1903Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi8705624_cf1903Hz,'z_rerp'));
maxz=max(structfield(ipsi8705624_cf1903Hz,'z_rerp'));
Maxz=max(structfield(ipsi8705624_cf1903Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi8705624_cf1903Hz)
    ipsi8705624_cf1903Hz(k).minCT=Slope*minz+Yintercept;
    ipsi8705624_cf1903Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi8705624_cf1903Hz(k).MinCT=Yintercept;
    ipsi8705624_cf1903Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi9004315_cf2300Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi9004315_cf2300Hz,'z_rerp'));
maxz=max(structfield(ipsi9004315_cf2300Hz,'z_rerp'));
Maxz=max(structfield(ipsi9004315_cf2300Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi9004315_cf2300Hz)
    ipsi9004315_cf2300Hz(k).minCT=Slope*minz+Yintercept;
    ipsi9004315_cf2300Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi9004315_cf2300Hz(k).MinCT=Yintercept;
    ipsi9004315_cf2300Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi8900739_cf2470Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi8900739_cf2470Hz,'z_rerp'));
maxz=max(structfield(ipsi8900739_cf2470Hz,'z_rerp'));
Maxz=max(structfield(ipsi8900739_cf2470Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi8900739_cf2470Hz)
    ipsi8900739_cf2470Hz(k).minCT=Slope*minz+Yintercept;
    ipsi8900739_cf2470Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi8900739_cf2470Hz(k).MinCT=Yintercept;
    ipsi8900739_cf2470Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi8900743_cf2694Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi8900743_cf2694Hz,'z_rerp'));
maxz=max(structfield(ipsi8900743_cf2694Hz,'z_rerp'));
Maxz=max(structfield(ipsi8900743_cf2694Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi8900743_cf2694Hz)
    ipsi8900743_cf2694Hz(k).minCT=Slope*minz+Yintercept;
    ipsi8900743_cf2694Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi8900743_cf2694Hz(k).MinCT=Yintercept;
    ipsi8900743_cf2694Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

[Info, Slope, Yintercept] = structplotdata2(ipsi880113_cf5388Hz,'z_rerp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5])
minz=min(structfield(ipsi880113_cf5388Hz,'z_rerp'));
maxz=max(structfield(ipsi880113_cf5388Hz,'z_rerp'));
Maxz=max(structfield(ipsi880113_cf5388Hz,'cp_z_rerp'));%all values are same within a fiber
for k=1:length(ipsi880113_cf5388Hz)
    ipsi880113_cf5388Hz(k).minCT=Slope*minz+Yintercept;
    ipsi880113_cf5388Hz(k).maxCT=Slope*maxz+Yintercept;
    ipsi880113_cf5388Hz(k).MinCT=Yintercept;
    ipsi880113_cf5388Hz(k).MaxCT=Slope*Maxz+Yintercept;
end;

%ipsifigure
structplot(ipsi8831120_cf200Hz,'z_rerp','ctsum',...
    ipsi8902122_cf1498Hz,'z_rerp','ctsum',...
    ipsi8705624_cf1903Hz,'z_rerp','ctsum',...
    ipsi9004315_cf2300Hz,'z_rerp','ctsum',...
    ipsi8900739_cf2470Hz,'z_rerp','ctsum',...
    ipsi8900743_cf2694Hz,'z_rerp','ctsum',...
    ipsi880113_cf5388Hz,'z_rerp','ctsum',...
    'info','no','fit','linear','xlim',[0 5000],'ylim',[-0.1 0.5],...
    'markers',{'sf','sw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;

plot(ipsi8831120_cf200Hz(1).cp_z_rerp,   ipsi8831120_cf200Hz(1).MaxCT,'b*',...
    ipsi8902122_cf1498Hz(1).cp_z_rerp,   ipsi8902122_cf1498Hz(1).MaxCT,'c*',...
    ipsi8705624_cf1903Hz(1).cp_z_rerp,   ipsi8705624_cf1903Hz(1).MaxCT,'c*',...
    ipsi9004315_cf2300Hz(1).cp_z_rerp,   ipsi9004315_cf2300Hz(1).MaxCT,'g*',...
    ipsi8900739_cf2470Hz(1).cp_z_rerp,   ipsi8900739_cf2470Hz(1).MaxCT,'g*',...
    ipsi8900743_cf2694Hz(1).cp_z_rerp,   ipsi8900743_cf2694Hz(1).MaxCT,'r*',...
    ipsi880113_cf5388Hz(1).cp_z_rerp,   ipsi880113_cf5388Hz(1).MaxCT,'r*');
hold off;

set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[10 12 6 6],'fontsize',8);
axes(HdlA);
xlabel('Z-value from RP plane (\mum)','fontsize',8);
ylabel('Conduction time from FB to EP (ms)','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[10 8 6 3]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
%Hdls=get(HdlA,'children')
close(CurFig);


%contra and ipsi delay panel
figure
%contra delay plot

x=contra8915116_cf840Hz(1).cf;
yc=contra8915116_cf840Hz(1).MaxCT - contra8915116_cf840Hz(1).MinCT;
y1=contra8915116_cf840Hz(1).minCT - contra8915116_cf840Hz(1).MinCT;
y2=contra8915116_cf840Hz(1).maxCT - contra8915116_cf840Hz(1).MinCT;
line([x x],[y1 y2],'color','k','marker','^','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
line([x x],[0 yc],'color','k');hold on;

x=contra8703910_cf1345Hz(1).cf;
yc=contra8703910_cf1345Hz(1).MaxCT - contra8703910_cf1345Hz(1).MinCT;
y1=contra8703910_cf1345Hz(1).minCT - contra8703910_cf1345Hz(1).MinCT;
y2=contra8703910_cf1345Hz(1).maxCT - contra8703910_cf1345Hz(1).MinCT;
line([x x],[y1 y2],'color','b','marker','v','MarkerEdgeColor','b','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','b');hold on;

x=contra8810715_cf1345Hz(1).cf;
yc=contra8810715_cf1345Hz(1).MaxCT - contra8810715_cf1345Hz(1).MinCT;
y1=contra8810715_cf1345Hz(1).minCT - contra8810715_cf1345Hz(1).MinCT;
y2=contra8810715_cf1345Hz(1).maxCT - contra8810715_cf1345Hz(1).MinCT;
line([x x],[y1 y2],'color','b','marker','^','MarkerEdgeColor','b','MarkerFaceColor','b');hold on;
line([x x],[0 yc],'color','b');hold on;

x=contra8902122_cf1498Hz(1).cf;
yc=contra8902122_cf1498Hz(1).MaxCT - contra8902122_cf1498Hz(1).MinCT;
y1=contra8902122_cf1498Hz(1).minCT - contra8902122_cf1498Hz(1).MinCT;
y2=contra8902122_cf1498Hz(1).maxCT - contra8902122_cf1498Hz(1).MinCT;
line([x x],[y1 y2],'color','c','marker','v','MarkerEdgeColor','c','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','c');hold on;

x=contra8914127_cf2018Hz(1).cf;
yc=contra8914127_cf2018Hz(1).MaxCT - contra8914127_cf2018Hz(1).MinCT;
y1=contra8914127_cf2018Hz(1).minCT - contra8914127_cf2018Hz(1).MinCT;
y2=contra8914127_cf2018Hz(1).maxCT - contra8914127_cf2018Hz(1).MinCT;
line([x x],[y1 y2],'color','c','marker','^','MarkerEdgeColor','c','MarkerFaceColor','c');hold on;
line([x x],[0 yc],'color','c');hold on;

x=contra871027_cf2397Hz(1).cf;
yc=contra871027_cf2397Hz(1).MaxCT - contra871027_cf2397Hz(1).MinCT;
y1=contra871027_cf2397Hz(1).minCT - contra871027_cf2397Hz(1).MinCT;
y2=contra871027_cf2397Hz(1).maxCT - contra871027_cf2397Hz(1).MinCT;
line([x x],[y1 y2],'color','g','marker','v','MarkerEdgeColor','g','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','g');hold on;

x=contra8900739_cf2470Hz(1).cf;
yc=contra8900739_cf2470Hz(1).MaxCT - contra8900739_cf2470Hz(1).MinCT;
y1=contra8900739_cf2470Hz(1).minCT - contra8900739_cf2470Hz(1).MinCT;
y2=contra8900739_cf2470Hz(1).maxCT - contra8900739_cf2470Hz(1).MinCT;
line([x x],[y1 y2],'color','g','marker','^','MarkerEdgeColor','g','MarkerFaceColor','g');hold on;
line([x x],[0 yc],'color','g');hold on;

x=contra870399_cf7184Hz(1).cf;
yc=contra870399_cf7184Hz(1).MaxCT - contra870399_cf7184Hz(1).MinCT;
y1=contra870399_cf7184Hz(1).minCT - contra870399_cf7184Hz(1).MinCT;
y2=contra870399_cf7184Hz(1).maxCT - contra870399_cf7184Hz(1).MinCT;
line([x x],[y1 y2],'color','r','marker','v','MarkerEdgeColor','r','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','r');hold on;

x=contra8709127_cf10508Hz(1).cf;
yc=contra8709127_cf10508Hz(1).MaxCT - contra8709127_cf10508Hz(1).MinCT;
y1=contra8709127_cf10508Hz(1).minCT - contra8709127_cf10508Hz(1).MinCT;
y2=contra8709127_cf10508Hz(1).maxCT - contra8709127_cf10508Hz(1).MinCT;
line([x x],[y1 y2],'color','r','marker','^','MarkerEdgeColor','r','MarkerFaceColor','r');hold on;
line([x x],[0 yc],'color','r');hold on;

%ipsi delay plot

x=ipsi8831120_cf200Hz(1).cf;
yc=ipsi8831120_cf200Hz(1).MaxCT - ipsi8831120_cf200Hz(1).MinCT;
y1=ipsi8831120_cf200Hz(1).minCT - ipsi8831120_cf200Hz(1).MinCT;
y2=ipsi8831120_cf200Hz(1).maxCT - ipsi8831120_cf200Hz(1).MinCT;
line([x x],[y1 y2],'color','b','marker','s','MarkerEdgeColor','b','MarkerFaceColor','b');hold on;
line([x x],[0 yc],'color','b');hold on;

x=ipsi8902122_cf1498Hz(1).cf;
yc=ipsi8902122_cf1498Hz(1).MaxCT - ipsi8902122_cf1498Hz(1).MinCT;
y1=ipsi8902122_cf1498Hz(1).minCT - ipsi8902122_cf1498Hz(1).MinCT;
y2=ipsi8902122_cf1498Hz(1).maxCT - ipsi8902122_cf1498Hz(1).MinCT;
line([x x],[y1 y2],'color','c','marker','s','MarkerEdgeColor','c','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','c');hold on;

x=ipsi8705624_cf1903Hz(1).cf;
yc=ipsi8705624_cf1903Hz(1).MaxCT - ipsi8705624_cf1903Hz(1).MinCT;
y1=ipsi8705624_cf1903Hz(1).minCT - ipsi8705624_cf1903Hz(1).MinCT;
y2=ipsi8705624_cf1903Hz(1).maxCT - ipsi8705624_cf1903Hz(1).MinCT;
line([x x],[y1 y2],'color','c','marker','s','MarkerEdgeColor','c','MarkerFaceColor','c');hold on;
line([x x],[0 yc],'color','c');hold on;

x=ipsi9004315_cf2300Hz(1).cf;
yc=ipsi9004315_cf2300Hz(1).MaxCT - ipsi9004315_cf2300Hz(1).MinCT;
y1=ipsi9004315_cf2300Hz(1).minCT - ipsi9004315_cf2300Hz(1).MinCT;
y2=ipsi9004315_cf2300Hz(1).maxCT - ipsi9004315_cf2300Hz(1).MinCT;
line([x x],[y1 y2],'color','g','marker','s','MarkerEdgeColor','g','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','g');hold on;

x=ipsi8900739_cf2470Hz(1).cf;
yc=ipsi8900739_cf2470Hz(1).MaxCT - ipsi8900739_cf2470Hz(1).MinCT;
y1=ipsi8900739_cf2470Hz(1).minCT - ipsi8900739_cf2470Hz(1).MinCT;
y2=ipsi8900739_cf2470Hz(1).maxCT - ipsi8900739_cf2470Hz(1).MinCT;
line([x x],[y1 y2],'color','g','marker','s','MarkerEdgeColor','g','MarkerFaceColor','g');hold on;
line([x x],[0 yc],'color','g');hold on;

x=ipsi8900743_cf2694Hz(1).cf;
yc=ipsi8900743_cf2694Hz(1).MaxCT - ipsi8900743_cf2694Hz(1).MinCT;
y1=ipsi8900743_cf2694Hz(1).minCT - ipsi8900743_cf2694Hz(1).MinCT;
y2=ipsi8900743_cf2694Hz(1).maxCT - ipsi8900743_cf2694Hz(1).MinCT;
line([x x],[y1 y2],'color','r','marker','s','MarkerEdgeColor','r','MarkerFaceColor','w');hold on;
line([x x],[0 yc],'color','r');hold on;

x=ipsi880113_cf5388Hz(1).cf;
yc=ipsi880113_cf5388Hz(1).MaxCT - ipsi880113_cf5388Hz(1).MinCT;
y1=ipsi880113_cf5388Hz(1).minCT - ipsi880113_cf5388Hz(1).MinCT;
y2=ipsi880113_cf5388Hz(1).maxCT - ipsi880113_cf5388Hz(1).MinCT;
line([x x],[y1 y2],'color','r','marker','s','MarkerEdgeColor','r','MarkerFaceColor','r');hold on;
line([x x],[0 yc],'color','r');hold on;


%additinal lines
ff=(0:10:11000);
line([0 12000],[0 0],'color','k');
plot(ff,ff.^(-1)*500,'k');
plot(ff,ff.^(-1)*(-500),'k');


ylim([-0.5 0.5]);xlim([0 11000]);
hold off;

set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);


CurFig=gcf;
HdlA=getplot(CurFig,1);%HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 1.5 14 6],'fontsize',10);
axes(HdlA);
xlabel('CF (Hz)','fontsize',8);
ylabel('Delay from RP (ms)','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;

%set(HdlB,'units','centimeters','position',[10 6 6 2.5]);
%axes(HdlB);
%set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
%box off;
close(CurFig);
















