
load Minmotion_con;
Color1_1=Color1;

figure;
subplot(2,2,1);
plot(Vcont(1:nCont)*Color2(2),mdata(1:nCont),'bo-','markersize',6);
hold on;
plot(Vcont(nCont+1:end)*Color2(2),mdata(nCont+1:end),'bx-','markersize',6);
xlabel('緑の輝度　(monitor G, 0-1)');
ylabel(' 右と答えた割合');
grid on;
title('赤(0.7,0.1,0.4)');

subplot(2,2,3);
x=Vcont(1:nCont)*Color2(2);
y=(mdata(1:nCont)+(1-(mdata(nCont+1:end))))/2;
plot(x,y,'bo-','markersize',6);hold on;
xlabel('緑の輝度　(monitor G, 0-1)');
ylabel(' 右と答えた割合');
grid on;

f=inline('ones(size(x))./(1+power(10,-beta(1)*x+beta(2)))','beta','x');
[beta,res,J]=nlinfit(x,y,f,[7 3]);
yfit=f(beta,x);
plot(x,yfit,'k:');
xt1=beta(2)/beta(1);
%title(sprintf('y=0.5 -> x=%.1f',xt));

load Minmotion_con2;
Color1_2=Color1;

subplot(2,2,2);
plot(Vcont(1:nCont)*Color2(2),mdata(1:nCont),'ro-','markersize',6);
hold on;
plot(Vcont(nCont+1:end)*Color2(2),mdata(nCont+1:end),'rx-','markersize',6);
xlabel('緑の輝度　(monitor G, 0-1)');
ylabel(' 右と答えた割合');
grid on;
title('赤(0.98,0.14,0.56)');

subplot(2,2,3);
x=Vcont(1:nCont)*Color2(2);
y=(mdata(1:nCont)+(1-(mdata(nCont+1:end))))/2;
plot(x,y,'ro-','markersize',6);hold on;
%xlabel('Gの輝度');
%ylabel(' 右と答えた割合');
grid on;

f=inline('ones(size(x))./(1+power(10,-beta(1)*x+beta(2)))','beta','x');
[beta,res,J]=nlinfit(x,y,f,[7 3]);
yfit=f(beta,x);
plot(x,yfit,'k:');
xt2=beta(2)/beta(1);
%title(sprintf('y=0.5 -> x=%.1f',xt));

%legend({sprintf('Rの輝度=%.1f',RL1), '', sprintf('Rの輝度=%.1f',RL2), ''},2);

figure;
mColor2_1=xt1/Color2(2)*Color2;
mColor2_2=xt2/Color2(2)*Color2;
plot([0.7 mColor2_1(1)],[0.1 mColor2_1(2)],'bo-');hold on;
plot([0.7*1.4 mColor2_2(1)],[0.1*1.4 mColor2_2(2)],'ro-');hold on;
text(Color1_1(1),Color1_1(2)+0.05,'赤(0.7,0.1,0.4)');
text(mColor2_1(1),mColor2_1(2)+0.05,sprintf('緑(%.2f,%.2f,%.2f)',mColor2_1(1),mColor2_1(2),mColor2_1(3)));
text(Color1_2(1)-0.2,Color1_2(2)+0.05,'赤(0.98,0.14,0.56)');
text(mColor2_2(1),mColor2_2(2)+0.05,sprintf('緑(%.2f,%.2f,%.2f)',mColor2_2(1),mColor2_2(2),mColor2_1(3)));

xlim([0 1]);
ylim([0 1]);
xlabel('monitor R (0-1)');
ylabel('monitor G (0-1)');
title('最小運動法：結果');

load Flicker.mat;
clear mColor2
for i=1:length(Vcont_all)
    mColor2(i,:)=Vcont_all(i)*Color2;
end
mColor2_0=mean(mColor2,1);
plot(mColor2_0(1),mColor2_0(2)+0.05,'kx');
text(0.1,0.1,sprintf('X交照法　緑(%.2f,%.2f,0.4)',mColor2_0(1),mColor2_0(2)));