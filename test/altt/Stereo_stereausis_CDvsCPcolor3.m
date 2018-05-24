for n=1:length(CFcombiselect4CATS_NearCF2)
    if CFcombiselect4CATS_NearCF2(n).BestITD>=-2&CFcombiselect4CATS_NearCF2(n).BestITD<=2
    x=CFcombiselect4CATS_NearCF2(n).CPr;
    y=CFcombiselect4CATS_NearCF2(n).CD;
    z=CFcombiselect4CATS_NearCF2(n).bumpdif;
    u=CFcombiselect4CATS_NearCF2(n).BestITD;
    zmin=-0.6;zmax=0.6;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
    line([0 x],[u y],'Color',CC,'LineWidth',2);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-0.6;-0.3;0;0.3;0.6]);
    end;
end;


