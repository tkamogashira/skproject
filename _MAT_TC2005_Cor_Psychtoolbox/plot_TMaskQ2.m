load('ThreshMaskQ2.mat','data','theData');
[v id]=sort(data(:,1));
data=data(id,:);
sf=data(:,2)
logcoldata=data(:,3);
coldata=power(10,logcoldata);
scol=[1 1 1 1 1]'./coldata;

load('ThreshMaskQ1.mat','data');
[v id]=sort(data(:,1));
data=data(id,:);
sf=data(:,2)
loglumdata=data(:,3);
lumdata=power(10,loglumdata);
slum=[1 1 1 1 1]'./lumdata;


figure;
subplot(1,2,1);
loglog(sf,slum,'ko-');hold on;
loglog(sf,scol,'ro-');
ylabel('Š´“x');
xlabel('cycle/image');
ylim([1 100]);

subplot(1,2,2);
loglog(sf,slum/slum(1),'ko-');hold on;
loglog(sf,scol/scol(1),'ro-');
ylabel('Š´“x');
xlabel('cycle/image');
ylim([0.1 10]);

scol
