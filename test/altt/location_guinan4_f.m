
%data plot
%subplot(1,2,1)
for n=1:length(contra_data)
    semilogx(contra_data(n).cf,contra_data(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
end;
for n=1:length(ipsi_data)
    semilogx(ipsi_data(n).cf,ipsi_data(n).ep_minus_vp_on_dp_minus_vp,'ro');hold on;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'contra')==1
    semilogx(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    end;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'ipsi')==1
    semilogx(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end;
base=greenwood(60000);
f=(100:100:60000);
semilogx(f,(base-greenwood(f))/base,'g');hold on;
%simple guinan data
line([1000 4000 10000 20000],[55/70 29/70 12/70 6/70],'color','k','marker','o','markerfacecolor','k');hold on;

CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);
% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);

set(HdlA,'units','centimeters','position',[2 6 6 10],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel([{'CF (Hz)'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'},...
    {'\color{black}o: from Guinan schema'}],'fontsize',10);
ylabel('ventral \leftarrow Normalized VD  \rightarrow dorsal','fontsize',10);
%Hdls=get(HdlA,'children')
ylim([0 1.1]);
box off;
close(CurFig);


%mean and SD plot

hold off;figure
Mean=mean([contra_data(1:6).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(1:6).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(1).cf),Mean,'bo');hold on;
line([greenwood(contra_data(1).cf) greenwood(contra_data(1).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%line([contra_data(1).cf contra_data(1).cf],[min([contra_data(1:6).ep_minus_vp_on_dp_minus_vp]) max([contra_data(1:6).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(1).cf,mean([contra_data(1:6).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(1).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(7:82).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(7:82).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(7).cf),Mean,'bo');hold on;
line([greenwood(contra_data(7).cf) greenwood(contra_data(7).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(7).cf,mean([contra_data(7:82).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(7).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(83:110).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(83:110).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(83).cf),Mean,'bo');hold on;
line([greenwood(contra_data(83).cf) greenwood(contra_data(83).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(83).cf,mean([contra_data(83:110).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(83).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(111:116).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(111:116).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(111).cf),Mean,'bo');hold on;
line([greenwood(contra_data(111).cf) greenwood(contra_data(111).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(111).cf,mean([contra_data(111:116).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(111).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(117:140).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(117:140).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(117).cf),Mean,'bo');hold on;
line([greenwood(contra_data(117).cf) greenwood(contra_data(117).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(117).cf,mean([contra_data(117:140).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(117).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(141:161).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(141:161).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(141).cf),Mean,'bo');hold on;
line([greenwood(contra_data(141).cf) greenwood(contra_data(141).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(141).cf,mean([contra_data(141:161).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(141).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(162:175).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(162:175).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(162).cf),Mean,'bo');hold on;
line([greenwood(contra_data(162).cf) greenwood(contra_data(162).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(162).cf,mean([contra_data(162:175).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(162).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(176:184).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(176:184).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(176).cf),Mean,'bo');hold on;
line([greenwood(contra_data(176).cf) greenwood(contra_data(176).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(176).cf,mean([contra_data(176:184).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(176).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(185:279).ep_minus_vp_on_dp_minus_vp]);
Std=std([contra_data(185:279).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(contra_data(185).cf),Mean,'bo');hold on;
line([greenwood(contra_data(185).cf) greenwood(contra_data(185).cf)],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(185).cf,mean([contra_data(185:279).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(185).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(1:22).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(1:22).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(1).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(1).cf) greenwood(ipsi_data(1).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(23:33).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(23:33).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(23).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(23).cf) greenwood(ipsi_data(23).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(34:40).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(34:40).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(34).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(34).cf) greenwood(ipsi_data(34).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(41:70).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(41:70).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(41).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(41).cf) greenwood(ipsi_data(41).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(71:81).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(71:81).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(71).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(71).cf) greenwood(ipsi_data(71).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(82:117).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(82:117).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(82).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(82).cf) greenwood(ipsi_data(82).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

Mean=mean([ipsi_data(118:121).ep_minus_vp_on_dp_minus_vp]);
Std=std([ipsi_data(118:121).ep_minus_vp_on_dp_minus_vp]);
plot(greenwood(ipsi_data(118).cf),Mean,'ro');hold on;
line([greenwood(ipsi_data(118).cf) greenwood(ipsi_data(118).cf)],[Mean-Std Mean+Std],'color','r');hold on;
clear Mean;clear Std;

for n=1:length(guinan)
    if strcmp(guinan(n).side,'contra')==1
    plot(greenwood(guinan(n).cf),guinan(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    end;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'ipsi')==1
    plot(greenwood(guinan(n).cf),guinan(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end; 

base=greenwood(60000);
f=(100:100:60000);
plot(greenwood(f),(base-greenwood(f))/base,'g');hold on;
%simple guinan data
line([greenwood(1000) greenwood(4000) greenwood(10000) greenwood(20000)],[55/70 29/70 12/70 6/70],'color','k','marker','o','markerfacecolor','k');

CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[9 6 6 10],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel([{'Cochlear distance (mm) from the apex'},...
    {' '},...
    {'\color{blue}o: contra Mean \pm SD (our data)'},...
    {'\color{red}o: ipsi Mean \pm SD (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'},...
    {'\color{black}o: from Guinan schema'}],'fontsize',10);
ylabel('');ylim([0 1.1]);xlim([0 25]);
%Hdls=get(HdlA,'children')
box off;

close(CurFig);


