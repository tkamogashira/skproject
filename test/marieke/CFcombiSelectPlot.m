%CFcombiSelectPlot
function CFcombiSelectPlot(CFcombiSelect)

SIZE=size(CFcombiSelect);
for n=1:SIZE(2)
    x=CFcombiSelect(n).IPCx;y=CFcombiSelect(n).IPCy;
    X=CFcombiSelect(n).ISRx;Y=CFcombiSelect(n).ISRy;
    [YM,YMi]=max(Y);
    CFcombiSelect(n).BPr=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).BF;
    xb=CFcombiSelect(n).BF;yb=CFcombiSelect(n).BPr;
    CFcombiSelect(n).CF1p=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).CF1;
    x1=CFcombiSelect(n).CF1;y1=CFcombiSelect(n).CF1p;
    CFcombiSelect(n).CF2p=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).CF2;
    x2=CFcombiSelect(n).CF2;y2=CFcombiSelect(n).CF2p;
    if (CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*min(x) < -0.5)|(CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*min(x) >= 0.5)
        y=y-round(y);
        Y=Y-round(Y);
        yb=yb-round(yb);
        y1=y1-round(y1);
        y2=y2-round(y2);
    end;
    plot(x,y);hold on;
    plot(X(YMi),y(YMi),'ro');
    plot(xb,yb,'m*','MarkerSize',12);
    plot(x1,y1,'k<');plot(x2,y2,'g>');
    line(x,CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*x,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    line(x3,(x3-xb)*(CFcombiSelect(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
end;
end


    