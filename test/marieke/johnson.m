function h=johnson(x,y)
y2=(1-y).^(-1);
h=loglog(x,y2);
tick1=[0 0.5 0.6 0.7 0.8 0.9 0.99];
set(gca,'YTick',(1-tick1).^(-1));
set(gca,'YTickLabel',{'0','0.5','0.6','0.7','0.8','0.9','0.99'});