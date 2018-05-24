for n=1:length(CFcombiselect242)
    x=CFcombiselect242(n).CPr;
    y=CFcombiselect242(n).CD;
    z=CFcombiselect242(n).BestITD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
    %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
end;
%figure
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).BestITD>=-2&CFcombiselect8121(n).BestITD<=2
        x=CFcombiselect8121(n).CPr;
        y=CFcombiselect8121(n).CD;
        z=CFcombiselect8121(n).BestITD;
        zmin=-2;zmax=2;m=64;
        index = fix((z-zmin)/(zmax-zmin)*m)+1;
        aaa=colormap(jet);
        CC=aaa(index,:);
        plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
        %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
        xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -2 2]);
        colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
    end;
end;
%figure
for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).CPr;
    y=CFcombiselect241(n).CD;
    z=CFcombiselect241(n).BestITD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
    %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
end;
%figure
for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).CPr;
    y=CFcombiselect898(n).CD;
    z=CFcombiselect898(n).BestITD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
    %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
end;

