function Stereo_CDvsCP_model(x,y)
df=(200:100:2000);
flimitposi=df.^(-1)*500;
flimitnega=df.^(-1)*(-500);
distrib=[0;0;0;0;0];
for k=1:length(df)
    bestitd=(flimitnega(k):0.1:flimitposi(k));
    num=length(bestitd);
    
    bestitdmin=-3;bestitdmax=3;m=64;
    index = fix((bestitd-bestitdmin*ones(1,num))/(bestitdmax-bestitdmin)*m)+1
    aaa=colormap(jet);
    CC=(aaa(index,:))';
    add=[(ones(1,num)*df(k));bestitd;CC];
    distrib=[distrib add];
end;
SIZE=size(distrib,2);
distrib=distrib(:,(2:SIZE));
SIZE=size(distrib,2);
lowbestitd=x;highbestitd=y;
selectidx=find(distrib(2,:)>=lowbestitd & distrib(2,:)<=highbestitd);
select=distrib(:,selectidx);
selectSIZE=size(select,2);

subplot(1,2,1)
for p=1:selectSIZE
    plot(select(1,p),select(2,p),'o','MarkerFaceColor',(select((3:5),p))','MarkerEdgeColor',(select((3:5),p))','MarkerSize',3);hold on;grid on;
end;
f=(200:1:2000);
plot(f,f.^(-1)*500,'k');hold on;
plot(f,f.^(-1)*(-500),'k');hold off;
xlabel('DF');ylabel('BestITD');xlim([0 2000]);

subplot(1,2,2)
cp=(-0.5:0.05:0.5);
for n=1:selectSIZE
    cd=cp*(select(1,n)^(-1)*(-1))*1000+select(2,n)*ones(1,length(cp));
    plot(cp,cd,'o','MarkerFaceColor',(select((3:5),n))','MarkerEdgeColor',(select((3:5),n))','MarkerSize',4);hold on;grid on;
end;xlabel('CP');ylabel('CD');ylim([-5 5]);
hold off;
colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-3;-1.5;0;1.5;3]);