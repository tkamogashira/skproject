
load('ThreshMaskQ1.mat','data','theData');
[v id]=sort(data(:,1));
data=data(id,:);
sf=data(:,2);
logthresh=data(:,3);
thresh=power(10,logthresh);
sens=[1 1 1 1 1]'./thresh;


figure;
subplot(1,2,1);
semilogx(sf,logthresh,'ko-');hold on;
errorbar(sf,logthresh,data(:,4),'ko');
ylabel('閾値');
xlabel('cycle/image');
set(gca,'ytick',[-2 -1 0]);
set(gca,'yticklabel',cellstr(num2str(power(10,[-2 -1 0]'))));
ylim([-2 0]);


subplot(1,2,2);
loglog(sf,sens,'ko-');hold on;
ylabel('感度　（１/閾値）');
xlabel('cycle/image');
ylim([1 100]);

sens