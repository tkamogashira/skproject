for n=1:length(BBICselectWithCF)
    x=BBICselectWithCF(n).CPr;
    y=BBICselectWithCF(n).CD;
    z=BBICselectWithCF(n).BestITD;
    zmin=-2;zmax=2;m=64;
    if (z>=-2)&(z<=2)
        index = fix((z-zmin)/(zmax-zmin)*m)+1;
        aaa=colormap(jet);
        CC=aaa(index,:);
        plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
        xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
        colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
        title('ICdata BestITD on Colorbar');
    end;
end;

hold off

structplot(BBICselectWithCF,'CPr','CD','execevalfnc','evalBB2(dataset($ds1.filename$,$ds1.seqid$))')
xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);grid on;
