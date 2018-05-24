for n=1:length(CFcombiselect)
    x=CFcombiselect(n).CPr;
    y=CFcombiselect(n).CD;
    z=CFcombiselect(n).DeltaCF;
    zmin=0;zmax=0.4;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(DeltaCF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.1;0.2;0.3;0.4]);
end;

for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).CPr;
    y=CFcombiselect241(n).CD;
    z=CFcombiselect241(n).DeltaCF;
    zmin=0;zmax=0.4;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'s','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(DeltaCF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.1;0.2;0.3;0.4]);
end;

for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).CPr;
    y=CFcombiselect898(n).CD;
    z=CFcombiselect898(n).DeltaCF;
    zmin=0;zmax=0.4;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'d','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(DeltaCF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.1;0.2;0.3;0.4]);
end;

