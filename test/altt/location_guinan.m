
%for n=1:length(guinan)
%    if strcmp(guinan(n).side,'contra')==1
%    text('position',[1,guinan(n).ep_minus_vp_on_dp_minus_vp],'string',num2str(guinan(n).cf),'color','b','fontsize',10);hold on;
%    end;
%end;
line([0 0],[0,1],'color','k');
text('position',[0,55/70],'string','1000','color','k','fontsize',12);line([-10 10],[55/70,55/70],'color','k');hold on;
text('position',[0,29/70],'string','4000','color','k','fontsize',12);line([-10 10],[29/70,29/70],'color','k');hold on;
text('position',[0,12/70],'string','10000','color','k','fontsize',12);line([-10 10],[12/70,12/70],'color','k');hold on;
text('position',[0,6/70],'string','20000','color','k','fontsize',12);line([-10 10],[6/70,6/70],'color','k');hold on;

for n=1:6
    plot(-6,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-6,mean([contra_data(1:6).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(1).cf),'color','b','fontsize',12);hold on;

for n=7:82
    plot(-8,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-8,mean([contra_data(7:82).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(7).cf),'color','b','fontsize',12);hold on;

for n=83:110
    plot(-4,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-4,mean([contra_data(83:110).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(83).cf),'color','b','fontsize',12);hold on;

for n=111:116
    plot(-3,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-3,mean([contra_data(111:116).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(111).cf),'color','b','fontsize',12);hold on;

for n=117:140
    plot(-2,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-2,mean([contra_data(117:140).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(117).cf),'color','b','fontsize',12);hold on;

for n=141:161
    plot(-5,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-5,mean([contra_data(141:161).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(141).cf),'color','b','fontsize',12);hold on;

for n=162:175
    plot(-7,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-7,mean([contra_data(162:175).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(162).cf),'color','b','fontsize',12);hold on;

for n=176:184
    plot(-1,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-1,mean([contra_data(176:184).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(176).cf),'color','b','fontsize',12);hold on;

for n=185:279
    plot(-9,contra_data(n).ep_minus_vp_on_dp_minus_vp,'ko');hold on;
end;
text('position',[-9,mean([contra_data(185:279).ep_minus_vp_on_dp_minus_vp])],'string',num2str(contra_data(185).cf),'color','b','fontsize',12);hold on;


axis([-10 10 0 1]);
hold off;


