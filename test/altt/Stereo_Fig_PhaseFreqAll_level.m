CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];
n70=0;n60=0;n50=0;n40=0;n30=0;

%70dB
subplot(5,1,1);
for n=1:length(CFcombiselectALL)
    level=CFcombiselectALL(n).SPL1(1);
    if level==70
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    if (CFcombiselectALL(n).CP < -0.5)|(CFcombiselectALL(n).CP >= 0.5)
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP-round(CFcombiselectALL(n).CP);
        y=y+(CFcombiselectALL(n).CPr-CFcombiselectALL(n).CP);
    %else
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselectALL(n).BPr=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPr;
    %CFcombiselectALL(n).CF1p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1p;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',1, 'Color','r');hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselectALL(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
    n70=n70+1;end;
end;
hold off;

%60dB
subplot(5,1,2);
for n=1:length(CFcombiselectALL)
    level=CFcombiselectALL(n).SPL1(1);
    if level==60
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    if (CFcombiselectALL(n).CP < -0.5)|(CFcombiselectALL(n).CP >= 0.5)
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP-round(CFcombiselectALL(n).CP);
        y=y+(CFcombiselectALL(n).CPr-CFcombiselectALL(n).CP);
    %else
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselectALL(n).BPr=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPr;
    %CFcombiselectALL(n).CF1p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1p;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',1, 'Color','r');hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselectALL(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
    n60=n60+1;end;
end;
hold off;

%50dB
subplot(5,1,3);
for n=1:length(CFcombiselectALL)
    level=CFcombiselectALL(n).SPL1(1);
    if level==50
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    if (CFcombiselectALL(n).CP < -0.5)|(CFcombiselectALL(n).CP >= 0.5)
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP-round(CFcombiselectALL(n).CP);
        y=y+(CFcombiselectALL(n).CPr-CFcombiselectALL(n).CP);
    %else
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselectALL(n).BPr=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPr;
    %CFcombiselectALL(n).CF1p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1p;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',1, 'Color','r');hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselectALL(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
    n50=n50+1;end;
end;
hold off;

%40dB
subplot(5,1,4);
for n=1:length(CFcombiselectALL)
    level=CFcombiselectALL(n).SPL1(1);
    if level==40
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    if (CFcombiselectALL(n).CP < -0.5)|(CFcombiselectALL(n).CP >= 0.5)
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP-round(CFcombiselectALL(n).CP);
        y=y+(CFcombiselectALL(n).CPr-CFcombiselectALL(n).CP);
    %else
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselectALL(n).BPr=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPr;
    %CFcombiselectALL(n).CF1p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1p;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',1, 'Color','r');hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselectALL(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
    n40=n40+1;end;
end;
hold off;

%30dB
subplot(5,1,5);
for n=1:length(CFcombiselectALL)
    level=CFcombiselectALL(n).SPL1(1);
    if level==30
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    if (CFcombiselectALL(n).CP < -0.5)|(CFcombiselectALL(n).CP >= 0.5)
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP-round(CFcombiselectALL(n).CP);
        y=y+(CFcombiselectALL(n).CPr-CFcombiselectALL(n).CP);
    %else
        %CFcombiselectALL(n).CPr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselectALL(n).BPr=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPr;
    %CFcombiselectALL(n).CF1p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1p;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',1, 'Color','r');hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselectALL(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    axis([0 4000 -3 3]);
    n30=n30+1;end;
end;
hold off;

[n70 n60 n50 n40 n30]
n70+n60+n50+n40+n30
length(CFcombiselectALL)
