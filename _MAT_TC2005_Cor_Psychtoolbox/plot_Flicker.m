
load Flicker;

figure;
clear mColor2
for i=1:length(Vcont_all)
    mColor2(i,:)=Vcont_all(i)*Color2;
end
meanmColor2=mean(mColor2,1);
scatter(mColor2(:,1),mColor2(:,2),'kx');hold on;
scatter(meanmColor2(1),meanmColor2(2),'ko');
scatter(Color1(1),Color1(2),'r');
text(Color1(1),Color1(2)+0.05,'ê‘(0.7,0.1,0.4)');
text(meanmColor2(1),meanmColor2(2)+0.05,sprintf('óŒ(%.2f,%.2f,%.2f)',meanmColor2(1),meanmColor2(2),meanmColor2(3)));
xlabel('monitor R (0-1)');
ylabel('monitor G (0-1)');
xlim([0 1]);
ylim([0 0.5]);
title('åè∆ñ@ÅFåãâ ');


if 0
maxlum=[20 40 10];
figure;
bar(1,sum(Color1.*maxlum));hold on;
bar(2,Vcont_mean*sum((Color2.*maxlum)));
plot(2,Vcont_all*sum((Color2.*maxlum)),'ko','markersize',10);
xlim([0 3])
set(gca,'XTick',[1 2]);
set(gca,'XTickLabel',{'R','G'});
ylabel('ãPìx');
end
