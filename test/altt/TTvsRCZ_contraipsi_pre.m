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

%ipsi
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
end;

ipsi8902122_cf1498Hz=ipsi_data(1:22);
ipsi8900739_cf2470Hz=ipsi_data(23:33);
ipsi8900743_cf2694Hz=ipsi_data(34:40);
ipsi9004315_cf2300Hz=ipsi_data(41:70);
ipsi8705624_cf1903Hz=ipsi_data(71:81);
ipsi8831120_cf200Hz=ipsi_data(82:117);
ipsi880113_cf5388Hz=ipsi_data(118:121);

structplot(ipsi8831120_cf200Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi8902122_cf1498Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi8705624_cf1903Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi9004315_cf2300Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi8900739_cf2470Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi8900743_cf2694Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
structplot(ipsi880113_cf5388Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);

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
    'info','no','fit','linear','xlim',[0 4000],'ylim',[0.15 0.45],...
    'markers',{'^f','vw'},...
    'colors',{'k','b', 'b', 'c', 'c', 'g', 'g', 'r','r'});hold on;
hold off;

set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 10 6 6],'xtick',[0:1000:4000],'fontsize',8);
axes(HdlA);
xlabel('Z-value from RP plane (\mum)','fontsize',8);
ylabel('Conduction time from ML to EP (ms)','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[2 6 6 3]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
%Hdls=get(HdlA,'children')
close(CurFig);

%delay panel
plot(...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).minCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).maxCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MinCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MaxCT, 'b^',...

contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).minCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).maxCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MinCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MaxCT, 'b^',...

contra8703910_cf1345Hz=contra_data(7:82);

contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).minCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).maxCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MinCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MaxCT, 'b^',...

contra871027_cf2397Hz=contra_data(83:110);

contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).minCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).maxCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MinCT, 'b^',...
contra8902122_cf1498Hz(1).cf, contra8902122_cf1498Hz(1).MaxCT, 'b^',...

contra8900739_cf2470Hz=contra_data(111:116);
contra870399_cf7184Hz=contra_data(117:140);
contra8914127_cf2018Hz=contra_data(141:161);
contra8810715_cf1345Hz=contra_data(162:175);
contra8709127_cf10508Hz=contra_data(176:184);
contra8915116_cf840Hz=contra_data(185:279);

%ipsifigure
structplot(ipsi8831120_cf200Hz,'ep_minus_rp','ctsum',...
    ipsi8902122_cf1498Hz,'ep_minus_rp','ctsum',...
    ipsi8705624_cf1903Hz,'ep_minus_rp','ctsum',...
    ipsi9004315_cf2300Hz,'ep_minus_rp','ctsum',...
    ipsi8900739_cf2470Hz,'ep_minus_rp','ctsum',...
    ipsi8900743_cf2694Hz,'ep_minus_rp','ctsum',...
    ipsi880113_cf5388Hz,'ep_minus_rp','ctsum',...
    'info','no','fit','linear','xlim',[0 4000],'ylim',[0 0.5],...
    'markers',{'^f','vw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;
hold off;


set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);


CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[10 10 6 6],'xtick',[0:1000:4000],'fontsize',8);
axes(HdlA);
xlabel('Cartesian distance between RP and EP (\mum)','fontsize',8);
ylabel('Conduction time from FB to EP (ms)','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[10 6 6 2.5]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
close(CurFig);







