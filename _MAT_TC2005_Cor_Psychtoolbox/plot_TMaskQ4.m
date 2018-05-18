load('ThreshMaskQ4.mat','data');

[v id]=sort(data(:,1));
data=data(id,:);
lumdata=power(10,data([3 1],3));
coldata=power(10,data([4 2],3));
slum=[1 1]'./lumdata
scol=[1 1]'./coldata

lumdata=lumdata/lumdata(1);
coldata=coldata/coldata(1);

figure;
semilogy([1 2],[1 1]'./lumdata,'ko-');hold on;
semilogy([1 2],[1 1]'./coldata,'ro-');
set(gca,'xtick',[1 2]);
set(gca,'xticklabel',{'無', '有'});
ylabel('感度');
xlabel('輝度マスク');
xlim([ 0 3]);
ylim([0.1 100])

