    
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).IPCx;y=CFcombiselect4CATS(n).IPCy;X=CFcombiselect4CATS(n).ISRx;Y=CFcombiselect4CATS(n).ISRy;
    if (CFcombiselect4CATS(n).CP < -0.5)|(CFcombiselect4CATS(n).CP >= 0.5)
        %CFcombiselect(n).CPr=CFcombiselect(n).CP-round(CFcombiselect(n).CP);
        y=y+(CFcombiselect4CATS(n).CPr-CFcombiselect4CATS(n).CP);
    %else
        %CFcombiselect(n).CPr=CFcombiselect(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect(n).BPr=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).BF;
    xb=CFcombiselect4CATS(n).BF;yb=CFcombiselect4CATS(n).BPr;
    %CFcombiselect(n).CF1p=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).CF1;
    x1=CFcombiselect4CATS(n).CF1;y1=CFcombiselect4CATS(n).CF1p;
    %CFcombiselect(n).CF2p=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).CF2;
    x2=CFcombiselect4CATS(n).CF2;y2=CFcombiselect4CATS(n).CF2p;
        
        
    plot(x,y);hold on;
    plot(X(YMi),y(YMi),'ro');
    plot(xb,yb,'m*','MarkerSize',12);
    plot(x1,y1,'k<');plot(x2,y2,'g>');
    xk=(0:10:max(x));
    yk=CFcombiselect4CATS(n).CPr+(CFcombiselect4CATS(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    line(x3,(x3-xb)*(CFcombiselect4CATS(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
end;

%syncrate graph
figure
for n=1:length(CFcombiselect4CATS)
    plot(CFcombiselect4CATS(n).ISRx,CFcombiselect4CATS(n).ISRy);hold on
end

%from stereausis2
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).BF;
    y=CFcombiselect4CATS(n).BestITD;
    z=CFcombiselect4CATS(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    
    plot3(x,y,CFcombiselect4CATS(n).CPr,'ko','MarkerFaceColor',CC,'MarkerSize',10);hold on;grid on;

    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

%from CDCPagain3
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).CPr;
    y=CFcombiselect4CATS(n).CD;
    z=CFcombiselect4CATS(n).BestITD;
    zmin=-7;zmax=7;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel('CPr');ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-2;-1;0;1;2]);
end;

%from stereausis
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).BF;
    y=CFcombiselect4CATS(n).BestITD;
    z=CFcombiselect4CATS(n).CD;
    zmin=-2;zmax=2;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
    xlabel('BF');ylabel('BestITD');axis([0 3500 -2 2]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[-1.5;-0.75;0;0.75;1.5]);
end;

%from stereausis3
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).CPr;
    y=CFcombiselect4CATS(n).CD;
    z=CFcombiselect4CATS(n).DeltaCF;
    zmin=0;zmax=0.4;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(DeltaCF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.1;0.2;0.3;0.4]);
end;


%from stereausis4
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).CPr;
    y=CFcombiselect4CATS(n).CD;
    z=CFcombiselect4CATS(n).MeanCF;
    zmin=0;zmax=4000;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(MeanCF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;1000;2000;3000;4000]);
end;

%from stereausis5
figure
for n=1:length(CFcombiselect4CATS)
    x=CFcombiselect4CATS(n).CPr;
    y=CFcombiselect4CATS(n).CD;
    z=CFcombiselect4CATS(n).BF;
    zmin=0;zmax=4000;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',12);hold on;grid on;
    xlabel(strvcat('CPr','(BF on Colorbar)'));ylabel('CD');axis([-0.5 0.5 -1.5 1.5]);
    colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;1000;2000;3000;4000]);
end;



%from stereausis6
figure
for n=1:length(CFcombiselect4CATS)
    x1=CFcombiselect4CATS(n).CF1;
    x2=CFcombiselect4CATS(n).CF2;
    y=CFcombiselect4CATS(n).BF;
    plot(x1,y,'bo','MarkerSize',9);hold on;grid on;
    plot(x2,y,'ro','MarkerSize',9);hold on;grid on;
    xlabel('CF1(contra) in blue & CF2(ipsi) in red');ylabel('BF');
end;

    