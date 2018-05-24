subplot(1,2,1)

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

text('position',[100000,55/70],'string','1000','color','k','fontsize',10);line([100 100000],[55/70,55/70],'color','k');hold on;
text('position',[100000,29/70],'string','4000','color','k','fontsize',10);line([100 100000],[29/70,29/70],'color','k');hold on;
text('position',[100000,12/70],'string','10000','color','k','fontsize',10);line([100 100000],[12/70,12/70],'color','k');hold on;
text('position',[100000,6/70],'string','20000','color','k','fontsize',10);line([100 100000],[6/70,6/70],'color','k');hold on;
line([1000 4000 10000 20000],[55/70 29/70 12/70 6/70],'color','k');hold on;

xlabel([{'CF'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'}]);

ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;

subplot(1,2,2)

semilogx(contra_data(1).cf,mean([contra_data(1:6).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(1).cf contra_data(1).cf],[min([contra_data(1:6).ep_minus_vp_on_dp_minus_vp]) max([contra_data(1:6).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(1).cf,mean([contra_data(1:6).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(1).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(7).cf,mean([contra_data(7:82).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(7).cf contra_data(7).cf],[min([contra_data(7:82).ep_minus_vp_on_dp_minus_vp]) max([contra_data(7:82).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(7).cf,mean([contra_data(7:82).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(7).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(83).cf,mean([contra_data(83:110).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(83).cf contra_data(83).cf],[min([contra_data(83:110).ep_minus_vp_on_dp_minus_vp]) max([contra_data(83:110).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(83).cf,mean([contra_data(83:110).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(83).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(111).cf,mean([contra_data(111:116).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(111).cf contra_data(111).cf],[min([contra_data(111:116).ep_minus_vp_on_dp_minus_vp]) max([contra_data(111:116).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(111).cf,mean([contra_data(111:116).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(111).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(117).cf,mean([contra_data(117:140).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(117).cf contra_data(117).cf],[min([contra_data(117:140).ep_minus_vp_on_dp_minus_vp]) max([contra_data(117:140).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(117).cf,mean([contra_data(117:140).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(117).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(141).cf,mean([contra_data(141:161).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(141).cf contra_data(141).cf],[min([contra_data(141:161).ep_minus_vp_on_dp_minus_vp]) max([contra_data(141:161).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(141).cf,mean([contra_data(141:161).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(141).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(162).cf,mean([contra_data(162:175).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(162).cf contra_data(162).cf],[min([contra_data(162:175).ep_minus_vp_on_dp_minus_vp]) max([contra_data(162:175).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(162).cf,mean([contra_data(162:175).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(162).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(176).cf,mean([contra_data(176:184).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(176).cf contra_data(176).cf],[min([contra_data(176:184).ep_minus_vp_on_dp_minus_vp]) max([contra_data(176:184).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(176).cf,mean([contra_data(176:184).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(176).cf),'color','b','fontsize',10);hold on;

semilogx(contra_data(185).cf,mean([contra_data(185:279).ep_minus_vp_on_dp_minus_vp]),'bo');hold on;
line([contra_data(185).cf contra_data(185).cf],[min([contra_data(185:279).ep_minus_vp_on_dp_minus_vp]) max([contra_data(185:279).ep_minus_vp_on_dp_minus_vp])],'color','b');hold on;
%text('position',[contra_data(185).cf,mean([contra_data(185:279).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(185).cf),'color','b','fontsize',10);hold on;

semilogx(ipsi_data(1).cf,mean([ipsi_data(1:22).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(1).cf ipsi_data(1).cf],[min([ipsi_data(1:22).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(1:22).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(23).cf,mean([ipsi_data(23:33).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(23).cf ipsi_data(23).cf],[min([ipsi_data(23:33).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(23:33).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(34).cf,mean([ipsi_data(34:40).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(34).cf ipsi_data(34).cf],[min([ipsi_data(34:40).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(34:40).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(41).cf,mean([ipsi_data(41:70).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(41).cf ipsi_data(41).cf],[min([ipsi_data(41:70).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(41:70).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(71).cf,mean([ipsi_data(71:81).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(71).cf ipsi_data(71).cf],[min([ipsi_data(71:81).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(71:81).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(82).cf,mean([ipsi_data(82:117).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(82).cf ipsi_data(82).cf],[min([ipsi_data(82:117).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(82:117).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;

semilogx(ipsi_data(118).cf,mean([ipsi_data(118:121).ep_minus_vp_on_dp_minus_vp]),'ro');hold on;
line([ipsi_data(118).cf ipsi_data(118).cf],[min([ipsi_data(118:121).ep_minus_vp_on_dp_minus_vp]) max([ipsi_data(118:121).ep_minus_vp_on_dp_minus_vp])],'color','r');hold on;



base=greenwood(60000);
f=(100:100:60000);
semilogx(f,(base-greenwood(f))/base,'g');hold on;


text('position',[100000,55/70],'string','1000','color','k','fontsize',10);line([100 100000],[55/70,55/70],'color','k');hold on;
text('position',[100000,29/70],'string','4000','color','k','fontsize',10);line([100 100000],[29/70,29/70],'color','k');hold on;
text('position',[100000,12/70],'string','10000','color','k','fontsize',10);line([100 100000],[12/70,12/70],'color','k');hold on;
text('position',[100000,6/70],'string','20000','color','k','fontsize',10);line([100 100000],[6/70,6/70],'color','k');hold on;
line([1000 4000 10000 20000],[55/70 29/70 12/70 6/70],'color','k');hold on;

xlabel([{'CF'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    %{'\color{blue}*: contra (Guinan)'},...
    %{'\color{red}*: ipsi (Guinan)'}...
    ]);

ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;




