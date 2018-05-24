for n=1:length(CFcombiselect)
    x=CFcombiselect(n).BF;
    y=CFcombiselect(n).BestITD;
    z=CFcombiselect(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).BF;
    y=CFcombiselect241(n).BestITD;
    z=CFcombiselect241(n).CD;
    zmin=-1.5;zmax=1.5;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'s','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).BF;
    y=CFcombiselect898(n).BestITD;
    z=CFcombiselect898(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'d','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
    
end;

t=(250:1:3500);y1=-500./t;y2=500./t;plot(t,y1,'k',t,y2,'k');

hold off
figure

for n=1:length(CFcombiselect)
    x=CFcombiselect(n).BF;
    y=CFcombiselect(n).BestITD-CFcombiselect(n).CD;
    z=CFcombiselect(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD-CD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).BF;
    y=CFcombiselect241(n).BestITD-CFcombiselect241(n).CD;
    z=CFcombiselect241(n).CD;
    zmin=-1.5;zmax=1.5;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'s','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD-CD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).BF;
    y=CFcombiselect898(n).BestITD-CFcombiselect898(n).CD;
    z=CFcombiselect898(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'d','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD-CD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

t=(250:1:3500);y1=-500./t;y2=500./t;plot(t,y1,'k',t,y2,'k');