for n=1:length(CFcombiselect)
    x=CFcombiselect(n).BF;
    y=CFcombiselect(n).BestITD;
    z=CFcombiselect(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    
    plot3(x,y,CFcombiselect(n).CPr,'ko','MarkerFaceColor',CC,'MarkerSize',10);hold on;grid on;

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
    
    plot3(x,y,CFcombiselect241(n).CPr,'ko','MarkerFaceColor',CC,'MarkerSize',10);hold on;grid on;

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
    
    plot3(x,y,CFcombiselect898(n).CPr,'ko','MarkerFaceColor',CC,'MarkerSize',10);hold on;grid on;

    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

