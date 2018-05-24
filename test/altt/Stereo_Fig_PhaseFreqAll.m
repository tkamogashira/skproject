%241
subplot(2,2,1);
for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).IPCx;y=CFcombiselect241(n).IPCy;X=CFcombiselect241(n).ISRx;Y=CFcombiselect241(n).ISRy;
    if (CFcombiselect241(n).CP < -0.5)|(CFcombiselect241(n).CP >= 0.5)
        %CFcombiselect241(n).CPr=CFcombiselect241(n).CP-round(CFcombiselect241(n).CP);
        y=y+(CFcombiselect241(n).CPr-CFcombiselect241(n).CP);
    %else
        %CFcombiselect241(n).CPr=CFcombiselect241(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect241(n).BPr=CFcombiselect241(n).CPr+(CFcombiselect241(n).CD/1000)*CFcombiselect241(n).BF;
    xb=CFcombiselect241(n).BF;yb=CFcombiselect241(n).BPr;
    %CFcombiselect241(n).CF1p=CFcombiselect241(n).CPr+(CFcombiselect241(n).CD/1000)*CFcombiselect241(n).CF1;
    x1=CFcombiselect241(n).CF1;y1=CFcombiselect241(n).CF1p;
    %CFcombiselect241(n).CF2p=CFcombiselect241(n).CPr+(CFcombiselect241(n).CD/1000)*CFcombiselect241(n).CF2;
    x2=CFcombiselect241(n).CF2;y2=CFcombiselect241(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',6);%CFc
    plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect241(n).CPr+(CFcombiselect241(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect241(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
end;
hold off;

%242
subplot(2,2,2);
for n=1:length(CFcombiselect242)
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

%898
subplot(2,2,3);
for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).IPCx;y=CFcombiselect898(n).IPCy;X=CFcombiselect898(n).ISRx;Y=CFcombiselect898(n).ISRy;
    if (CFcombiselect898(n).CP < -0.5)|(CFcombiselect898(n).CP >= 0.5)
        %CFcombiselect898(n).CPr=CFcombiselect898(n).CP-round(CFcombiselect898(n).CP);
        y=y+(CFcombiselect898(n).CPr-CFcombiselect898(n).CP);
    %else
        %CFcombiselect898(n).CPr=CFcombiselect898(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect898(n).BPr=CFcombiselect898(n).CPr+(CFcombiselect898(n).CD/1000)*CFcombiselect898(n).BF;
    xb=CFcombiselect898(n).BF;yb=CFcombiselect898(n).BPr;
    %CFcombiselect898(n).CF1p=CFcombiselect898(n).CPr+(CFcombiselect898(n).CD/1000)*CFcombiselect898(n).CF1;
    x1=CFcombiselect898(n).CF1;y1=CFcombiselect898(n).CF1p;
    %CFcombiselect898(n).CF2p=CFcombiselect898(n).CPr+(CFcombiselect898(n).CD/1000)*CFcombiselect898(n).CF2;
    x2=CFcombiselect898(n).CF2;y2=CFcombiselect898(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',6);%CFc
    plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect898(n).CPr+(CFcombiselect898(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect898(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
end;
hold off;

%8121
subplot(2,2,4);
for n=1:length(CFcombiselect8121)
    x=CFcombiselect8121(n).IPCx;y=CFcombiselect8121(n).IPCy;X=CFcombiselect8121(n).ISRx;Y=CFcombiselect8121(n).ISRy;
    if (CFcombiselect8121(n).CP < -0.5)|(CFcombiselect8121(n).CP >= 0.5)
        %CFcombiselect8121(n).CPr=CFcombiselect8121(n).CP-round(CFcombiselect8121(n).CP);
        y=y+(CFcombiselect8121(n).CPr-CFcombiselect8121(n).CP);
    %else
        %CFcombiselect8121(n).CPr=CFcombiselect8121(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect8121(n).BPr=CFcombiselect8121(n).CPr+(CFcombiselect8121(n).CD/1000)*CFcombiselect8121(n).BF;
    xb=CFcombiselect8121(n).BF;yb=CFcombiselect8121(n).BPr;
    %CFcombiselect8121(n).CF1p=CFcombiselect8121(n).CPr+(CFcombiselect8121(n).CD/1000)*CFcombiselect8121(n).CF1;
    x1=CFcombiselect8121(n).CF1;y1=CFcombiselect8121(n).CF1p;
    %CFcombiselect8121(n).CF2p=CFcombiselect8121(n).CPr+(CFcombiselect8121(n).CD/1000)*CFcombiselect8121(n).CF2;
    x2=CFcombiselect8121(n).CF2;y2=CFcombiselect8121(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',6);%CFc
    plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect8121(n).CPr+(CFcombiselect8121(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect8121(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
end;
hold off;



