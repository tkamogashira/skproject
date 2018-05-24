% Create template
scrsz = get(0,'ScreenSize')
FigHdl = figure('Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);
%scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);
%set(gcf,'resize','off');
%contra
for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
end;

%normalize axonal length using RPtoCP
for n=1:6
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4225.27;
end;
for n=7:82
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3055.33;
end;
for n=83:110
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4101.46;
end;
for n=111:116
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4169.28;
end;
for n=117:140
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3055.33;
end;
for n=141:161
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3869.3;
end;
for n=162:175
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3936.53;
end;
for n=176:184
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3137.97;
end;
for n=185:279
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4295.17;
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


%normalize axonal length using RPtoCP
structplot(contra8915116_cf840Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8703910_cf1345Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8810715_cf1345Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8902122_cf1498Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8914127_cf2018Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra871027_cf2397Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8900739_cf2470Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra870399_cf7184Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra8709127_cf10508Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'info','no','fit','linear','xlim',[0 1],'ylim',[0 1.5],...
    'markers',{'^f','vw'},...
    'colors',{'k','b', 'b', 'c', 'c', 'g', 'g', 'r','r'});hold on;

line([0 1],[0 1],'color','k');hold off;
set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);


CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[1 15 6 6],'xtick',[0:0.2:1],'fontsize',8);
axes(HdlA);
xlabel('rostal \leftarrow Normalized RC \rightarrow caudal','fontsize',8);
ylabel('Normalized axonal length from FB','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[1 11 6 3]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
%Hdls=get(HdlA,'children')
close(CurFig);



%ipsi
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
end;

%normalize axonal length using RPtoCP
for n=1:22
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4199.75;
end;
for n=23:33
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4108.17;
end;
for n=34:40
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4169.28;
end;
for n=41:70
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4279.84;
end;
for n=71:81
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/3136.7;
end;
for n=82:117
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4001.14;
end;
for n=118:121
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4771.82;
end;

ipsi8902122_cf1498Hz=ipsi_data(1:22);
ipsi8900739_cf2470Hz=ipsi_data(23:33);
ipsi8900743_cf2694Hz=ipsi_data(34:40);
ipsi9004315_cf2300Hz=ipsi_data(41:70);
ipsi8705624_cf1903Hz=ipsi_data(71:81);
ipsi8831120_cf200Hz=ipsi_data(82:117);
ipsi880113_cf5388Hz=ipsi_data(118:121);

%normalize axonal length using RPtoCP for figure
structplot(ipsi8831120_cf200Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi8902122_cf1498Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi8705624_cf1903Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi9004315_cf2300Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi8900739_cf2470Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi8900743_cf2694Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi880113_cf5388Hz,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'info','no','fit','linear','xlim',[0 1],'ylim',[0 2.5],...
    'markers',{'^f','vw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;
line([0 1],[0 1],'color','k');hold off;
set(gcf,'Units','centimeters','Position',[0 0 17.6 22]);%,'PaperType', 'A4', 'PaperOrientation','Portrait');%,'PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);


CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[1 4 6 6],'xtick',[0:0.2:1],'fontsize',8);
axes(HdlA);
xlabel('rostal \leftarrow Normalized RC \rightarrow caudal','fontsize',8);
ylabel('Normalized axonal length from FB','fontsize',8);
set(findobj(gca,'Type','line'),'markersize',5);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[1 1 6 2.5]);
axes(HdlB);
set(findobj(gca,'Type','line'),'markersize',5,'linestyle','none');
box off;
close(CurFig);



