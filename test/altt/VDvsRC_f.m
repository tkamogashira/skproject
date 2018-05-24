% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

%contra
for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
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

structplot(contra8915116_cf840Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8703910_cf1345Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8810715_cf1345Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8902122_cf1498Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8914127_cf2018Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra871027_cf2397Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8900739_cf2470Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra870399_cf7184Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    contra8709127_cf10508Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    'info','no','xlim',[0 1],'ylim',[0 1.1],...
    'markers',{'^f','vw'},...
    'colors',{'k','b', 'b', 'c', 'c', 'g', 'g', 'r','r'});hold on;

%for n=1:length(guinan)
    %if strcmp(guinan(n).side,'contra')==1
    %plot(guinan(n).ep_minus_rp_on_cp_minus_rp,guinan(n).ep_minus_vp_on_dp_minus_vp,'k*','markersize',6);hold on;
    %end;
%end;

line([0 1],[1 1],'color','k');hold off;
CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
axes(HdlA);
set(HdlA,'units','centimeters','position',[2 17 10 6],'xtick',[0:0.2:1],'fontsize',8);
xlabel('rostal \leftarrow Normalized RC \rightarrow caudal','fontsize',10);
ylabel('ventral \leftarrow Normalized VD  \rightarrow dorsal','fontsize',10);
%Hdls=get(HdlA,'children')
box off;

set(HdlB,'units','centimeters','position',[12.5 17 6 6]);
axes(HdlB);
box off;
%Hdls=get(HdlA,'children')
close(CurFig);


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

structplot(ipsi8831120_cf200Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi8902122_cf1498Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi8705624_cf1903Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi9004315_cf2300Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi8900739_cf2470Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi8900743_cf2694Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    ipsi880113_cf5388Hz,'ep_minus_rp_on_cp_minus_rp','ep_minus_vp_on_dp_minus_vp',...
    'info','no','xlim',[0 1],'ylim',[0 1.1],...
    'markers',{'^f','vw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;


%for n=1:length(guinan)
    %if strcmp(guinan(n).side,'ipsi')==1
    %plot(guinan(n).ep_minus_rp_on_cp_minus_rp,guinan(n).ep_minus_vp_on_dp_minus_vp,'k*','markersize',6);hold on;
    %end;
%end;

line([0 1],[1 1],'color','k');hold off;
CurFig=gcf;
HdlA=getplot(CurFig,2);HdlB=getplot(CurFig,1);
HdlA=copyobj(HdlA,FigHdl);HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 9 10 6],'xtick',[0:0.2:1],'fontsize',8);
axes(HdlA);
xlabel('rostal \leftarrow Normalized RC \rightarrow caudal','fontsize',10);
ylabel('ventral \leftarrow Normalized VD  \rightarrow dorsal','fontsize',10);
%Hdls=get(HdlA,'children')
box off;
set(HdlB,'units','centimeters','position',[12.5 9 6 6]);
axes(HdlB);
box off;
close(CurFig);



