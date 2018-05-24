
for n=1:length(CFcombiselect)
    x=CFcombiselect(n).CPr;
    y=CFcombiselect(n).CD;
    z=CFcombiselect(n).BestITD;
    %C=63*z/4+63/2+1;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    %alow=floor(C);ahigh=ceil(C);
    %CC=mean([aaa(alow,:);aaa(ahigh,:)],1);
    CC=aaa(index,:);
    
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',14);hold on;grid on;
    xlabel('CPr');ylabel('CD');
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
end;




