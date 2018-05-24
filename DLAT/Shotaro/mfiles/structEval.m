for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).CPr;
    y=CFcombiselectALL(n).CD;
    z=CFcombiselectALL(n).BestITD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',6);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
    title('BestITD on Colorbar');
    
end;
hold off


for n=1:length(CFcombiselectALL)
    CFcombiselectALL(n).Fiber1filename=CFcombiselectALL(n).Fiber1(1:5);
    zz=length(CFcombiselectALL(n).Fiber1);
    CFcombiselectALL(n).Fiber1seqid=CFcombiselectALL(n).Fiber1(7:zz);
    CFcombiselectALL(n).Fiber2filename=CFcombiselectALL(n).Fiber2(1:5);
    zzz=length(CFcombiselectALL(n).Fiber2);
    CFcombiselectALL(n).Fiber2seqid=CFcombiselectALL(n).Fiber2(7:zzz);
end;

structplot(CFcombiselectALL,'CPr','CD','execevalfnc','evalFS2(dataset($Fiber1filename$,$Fiber1seqid$),dataset($Fiber2filename$,$Fiber2seqid$))')
xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);grid on;
