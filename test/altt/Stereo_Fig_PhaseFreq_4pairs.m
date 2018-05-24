

for n=41:44
    x=CFcombiselect242(n).IPCx;y=CFcombiselect242(n).IPCy;X=CFcombiselect242(n).ISRx;Y=CFcombiselect242(n).ISRy;
    if (CFcombiselect242(n).CP < -0.5)|(CFcombiselect242(n).CP >= 0.5)
        %CFcombiselect242(n).CPr=CFcombiselect242(n).CP-round(CFcombiselect242(n).CP);
        y=y+(CFcombiselect242(n).CPr-CFcombiselect242(n).CP);
    %else
        %CFcombiselect242(n).CPr=CFcombiselect242(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect242(n).BPr=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).BF;
    xb=CFcombiselect242(n).BF;yb=CFcombiselect242(n).BPr;
    %CFcombiselect242(n).CF1p=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).CF1;
    x1=CFcombiselect242(n).CF1;y1=CFcombiselect242(n).CF1p;
    %CFcombiselect242(n).CF2p=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).CF2;
    x2=CFcombiselect242(n).CF2;y2=CFcombiselect242(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',6);%CFc
    plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect242(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
end;
hold off;





