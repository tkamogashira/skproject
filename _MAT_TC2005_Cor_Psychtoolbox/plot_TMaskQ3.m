
load('ThreshMaskQ3.mat','data');
[v id]=sort(data(:,1));
logthresh=data(id,3);
threshmask=power(10,logthresh);
sf=data(id,2)

load('ThreshMaskQ1.mat','data');
[v id]=sort(data(:,1));
logthresh=data(id,3);
threshnomask=power(10,logthresh);
sf=data(id,2)

smask=[1 1 1 1 1]'./threshmask;
snomask=[1 1 1 1 1]'./threshnomask;

figure;
subplot(1,2,1);
loglog(sf,smask,'ko-');hold on;
loglog(sf,snomask,'ko:');
ylabel('Š´“x');
xlabel('cycle/image');
ylim([1 100]);

subplot(1,2,2);
semilogx(sf,snomask-smask,'ko-');hold on;
ylabel('Š´“x’á‰º');
xlabel('cycle/image');
ylim([-50 50]);

smask