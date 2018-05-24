%70db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==70
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_70db',single);
CFcombiselect_70db = [CFcombiselect241, CFcombiselect898, CFcombiselect8121_70db];

subplot(5,2,1);
for n=1:length(CFcombiselect_70db)
    if CFcombiselect_70db(n).pLinReg < 0.005 
    x=CFcombiselect_70db(n).IPCx;y=CFcombiselect_70db(n).IPCy;X=CFcombiselect_70db(n).ISRx;Y=CFcombiselect_70db(n).ISRy;
    if (CFcombiselect_70db(n).CP < -0.5)|(CFcombiselect_70db(n).CP >= 0.5)
        %CFcombiselect_70db(n).CPr=CFcombiselect_70db(n).CP-round(CFcombiselect_70db(n).CP);
        y=y+(CFcombiselect_70db(n).CPr-CFcombiselect_70db(n).CP);
    %else
        %CFcombiselect_70db(n).CPr=CFcombiselect_70db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_70db(n).BPr=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).BF;
    xb=CFcombiselect_70db(n).BF;yb=CFcombiselect_70db(n).BPr;
    %CFcombiselect_70db(n).CF1p=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).CF1;
    x1=CFcombiselect_70db(n).CF1;y1=CFcombiselect_70db(n).CF1p;
    %CFcombiselect_70db(n).CF2p=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).CF2;
    x2=CFcombiselect_70db(n).CF2;y2=CFcombiselect_70db(n).CF2p;
    
    plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*xk;
    %line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_70db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('70dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;
subplot(5,2,2)
for n=1:length(CFcombiselect_70db)
    if CFcombiselect_70db(n).pLinReg < 0.005 
    x=CFcombiselect_70db(n).IPCx;y=CFcombiselect_70db(n).IPCy;X=CFcombiselect_70db(n).ISRx;Y=CFcombiselect_70db(n).ISRy;
    if (CFcombiselect_70db(n).CP < -0.5)|(CFcombiselect_70db(n).CP >= 0.5)
        %CFcombiselect_70db(n).CPr=CFcombiselect_70db(n).CP-round(CFcombiselect_70db(n).CP);
        y=y+(CFcombiselect_70db(n).CPr-CFcombiselect_70db(n).CP);
    %else
        %CFcombiselect_70db(n).CPr=CFcombiselect_70db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_70db(n).BPr=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).BF;
    xb=CFcombiselect_70db(n).BF;yb=CFcombiselect_70db(n).BPr;
    %CFcombiselect_70db(n).CF1p=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).CF1;
    x1=CFcombiselect_70db(n).CF1;y1=CFcombiselect_70db(n).CF1p;
    %CFcombiselect_70db(n).CF2p=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*CFcombiselect_70db(n).CF2;
    x2=CFcombiselect_70db(n).CF2;y2=CFcombiselect_70db(n).CF2p;
    
    %plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_70db(n).CPr+(CFcombiselect_70db(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_70db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('70dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;


%60db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==60
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_60db',single);
CFcombiselect_60db = CFcombiselect8121_60db;

subplot(5,2,3);
for n=1:length(CFcombiselect_60db)
    if CFcombiselect_60db(n).pLinReg < 0.005 
    x=CFcombiselect_60db(n).IPCx;y=CFcombiselect_60db(n).IPCy;X=CFcombiselect_60db(n).ISRx;Y=CFcombiselect_60db(n).ISRy;
    if (CFcombiselect_60db(n).CP < -0.5)|(CFcombiselect_60db(n).CP >= 0.5)
        %CFcombiselect_60db(n).CPr=CFcombiselect_60db(n).CP-round(CFcombiselect_60db(n).CP);
        y=y+(CFcombiselect_60db(n).CPr-CFcombiselect_60db(n).CP);
    %else
        %CFcombiselect_60db(n).CPr=CFcombiselect_60db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_60db(n).BPr=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).BF;
    xb=CFcombiselect_60db(n).BF;yb=CFcombiselect_60db(n).BPr;
    %CFcombiselect_60db(n).CF1p=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).CF1;
    x1=CFcombiselect_60db(n).CF1;y1=CFcombiselect_60db(n).CF1p;
    %CFcombiselect_60db(n).CF2p=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).CF2;
    x2=CFcombiselect_60db(n).CF2;y2=CFcombiselect_60db(n).CF2p;
    
    plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*xk;
    %line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_60db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('60dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;
subplot(5,2,4)
for n=1:length(CFcombiselect_60db)
    if CFcombiselect_60db(n).pLinReg < 0.005 
    x=CFcombiselect_60db(n).IPCx;y=CFcombiselect_60db(n).IPCy;X=CFcombiselect_60db(n).ISRx;Y=CFcombiselect_60db(n).ISRy;
    if (CFcombiselect_60db(n).CP < -0.5)|(CFcombiselect_60db(n).CP >= 0.5)
        %CFcombiselect_60db(n).CPr=CFcombiselect_60db(n).CP-round(CFcombiselect_60db(n).CP);
        y=y+(CFcombiselect_60db(n).CPr-CFcombiselect_60db(n).CP);
    %else
        %CFcombiselect_60db(n).CPr=CFcombiselect_60db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_60db(n).BPr=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).BF;
    xb=CFcombiselect_60db(n).BF;yb=CFcombiselect_60db(n).BPr;
    %CFcombiselect_60db(n).CF1p=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).CF1;
    x1=CFcombiselect_60db(n).CF1;y1=CFcombiselect_60db(n).CF1p;
    %CFcombiselect_60db(n).CF2p=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*CFcombiselect_60db(n).CF2;
    x2=CFcombiselect_60db(n).CF2;y2=CFcombiselect_60db(n).CF2p;
    
    %plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_60db(n).CPr+(CFcombiselect_60db(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_60db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('60dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;


%50db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==50
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_50db',single);
CFcombiselect_50db = [CFcombiselect242, CFcombiselect8121_50db];

subplot(5,2,5);
for n=1:length(CFcombiselect_50db)
    if CFcombiselect_50db(n).pLinReg < 0.005 
    x=CFcombiselect_50db(n).IPCx;y=CFcombiselect_50db(n).IPCy;X=CFcombiselect_50db(n).ISRx;Y=CFcombiselect_50db(n).ISRy;
    if (CFcombiselect_50db(n).CP < -0.5)|(CFcombiselect_50db(n).CP >= 0.5)
        %CFcombiselect_50db(n).CPr=CFcombiselect_50db(n).CP-round(CFcombiselect_50db(n).CP);
        y=y+(CFcombiselect_50db(n).CPr-CFcombiselect_50db(n).CP);
    %else
        %CFcombiselect_50db(n).CPr=CFcombiselect_50db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_50db(n).BPr=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).BF;
    xb=CFcombiselect_50db(n).BF;yb=CFcombiselect_50db(n).BPr;
    %CFcombiselect_50db(n).CF1p=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).CF1;
    x1=CFcombiselect_50db(n).CF1;y1=CFcombiselect_50db(n).CF1p;
    %CFcombiselect_50db(n).CF2p=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).CF2;
    x2=CFcombiselect_50db(n).CF2;y2=CFcombiselect_50db(n).CF2p;
    
    plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*xk;
    %line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_50db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('50dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;
subplot(5,2,6)
for n=1:length(CFcombiselect_50db)
    if CFcombiselect_50db(n).pLinReg < 0.005 
    x=CFcombiselect_50db(n).IPCx;y=CFcombiselect_50db(n).IPCy;X=CFcombiselect_50db(n).ISRx;Y=CFcombiselect_50db(n).ISRy;
    if (CFcombiselect_50db(n).CP < -0.5)|(CFcombiselect_50db(n).CP >= 0.5)
        %CFcombiselect_50db(n).CPr=CFcombiselect_50db(n).CP-round(CFcombiselect_50db(n).CP);
        y=y+(CFcombiselect_50db(n).CPr-CFcombiselect_50db(n).CP);
    %else
        %CFcombiselect_50db(n).CPr=CFcombiselect_50db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_50db(n).BPr=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).BF;
    xb=CFcombiselect_50db(n).BF;yb=CFcombiselect_50db(n).BPr;
    %CFcombiselect_50db(n).CF1p=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).CF1;
    x1=CFcombiselect_50db(n).CF1;y1=CFcombiselect_50db(n).CF1p;
    %CFcombiselect_50db(n).CF2p=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*CFcombiselect_50db(n).CF2;
    x2=CFcombiselect_50db(n).CF2;y2=CFcombiselect_50db(n).CF2p;
    
    %plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_50db(n).CPr+(CFcombiselect_50db(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_50db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('50dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;


%40db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==40
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_40db',single);
CFcombiselect_40db = CFcombiselect8121_40db;

subplot(5,2,7);
for n=1:length(CFcombiselect_40db)
    if CFcombiselect_40db(n).pLinReg < 0.005 
    x=CFcombiselect_40db(n).IPCx;y=CFcombiselect_40db(n).IPCy;X=CFcombiselect_40db(n).ISRx;Y=CFcombiselect_40db(n).ISRy;
    if (CFcombiselect_40db(n).CP < -0.5)|(CFcombiselect_40db(n).CP >= 0.5)
        %CFcombiselect_40db(n).CPr=CFcombiselect_40db(n).CP-round(CFcombiselect_40db(n).CP);
        y=y+(CFcombiselect_40db(n).CPr-CFcombiselect_40db(n).CP);
    %else
        %CFcombiselect_40db(n).CPr=CFcombiselect_40db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_40db(n).BPr=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).BF;
    xb=CFcombiselect_40db(n).BF;yb=CFcombiselect_40db(n).BPr;
    %CFcombiselect_40db(n).CF1p=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).CF1;
    x1=CFcombiselect_40db(n).CF1;y1=CFcombiselect_40db(n).CF1p;
    %CFcombiselect_40db(n).CF2p=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).CF2;
    x2=CFcombiselect_40db(n).CF2;y2=CFcombiselect_40db(n).CF2p;
    
    plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*xk;
    %line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_40db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('40dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;
subplot(5,2,8)
for n=1:length(CFcombiselect_40db)
    if CFcombiselect_40db(n).pLinReg < 0.005 
    x=CFcombiselect_40db(n).IPCx;y=CFcombiselect_40db(n).IPCy;X=CFcombiselect_40db(n).ISRx;Y=CFcombiselect_40db(n).ISRy;
    if (CFcombiselect_40db(n).CP < -0.5)|(CFcombiselect_40db(n).CP >= 0.5)
        %CFcombiselect_40db(n).CPr=CFcombiselect_40db(n).CP-round(CFcombiselect_40db(n).CP);
        y=y+(CFcombiselect_40db(n).CPr-CFcombiselect_40db(n).CP);
    %else
        %CFcombiselect_40db(n).CPr=CFcombiselect_40db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_40db(n).BPr=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).BF;
    xb=CFcombiselect_40db(n).BF;yb=CFcombiselect_40db(n).BPr;
    %CFcombiselect_40db(n).CF1p=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).CF1;
    x1=CFcombiselect_40db(n).CF1;y1=CFcombiselect_40db(n).CF1p;
    %CFcombiselect_40db(n).CF2p=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*CFcombiselect_40db(n).CF2;
    x2=CFcombiselect_40db(n).CF2;y2=CFcombiselect_40db(n).CF2p;
    
    %plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_40db(n).CPr+(CFcombiselect_40db(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_40db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('40dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;


%30db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==30
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_30db',single);
CFcombiselect_30db = CFcombiselect8121_30db;

subplot(5,2,9);
for n=1:length(CFcombiselect_30db)
    if CFcombiselect_30db(n).pLinReg < 0.005 
    x=CFcombiselect_30db(n).IPCx;y=CFcombiselect_30db(n).IPCy;X=CFcombiselect_30db(n).ISRx;Y=CFcombiselect_30db(n).ISRy;
    if (CFcombiselect_30db(n).CP < -0.5)|(CFcombiselect_30db(n).CP >= 0.5)
        %CFcombiselect_30db(n).CPr=CFcombiselect_30db(n).CP-round(CFcombiselect_30db(n).CP);
        y=y+(CFcombiselect_30db(n).CPr-CFcombiselect_30db(n).CP);
    %else
        %CFcombiselect_30db(n).CPr=CFcombiselect_30db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_30db(n).BPr=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).BF;
    xb=CFcombiselect_30db(n).BF;yb=CFcombiselect_30db(n).BPr;
    %CFcombiselect_30db(n).CF1p=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).CF1;
    x1=CFcombiselect_30db(n).CF1;y1=CFcombiselect_30db(n).CF1p;
    %CFcombiselect_30db(n).CF2p=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).CF2;
    x2=CFcombiselect_30db(n).CF2;y2=CFcombiselect_30db(n).CF2p;
    
    plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*xk;
    %line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_30db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('30dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;
subplot(5,2,10)
for n=1:length(CFcombiselect_30db)
    if CFcombiselect_30db(n).pLinReg < 0.005 
    x=CFcombiselect_30db(n).IPCx;y=CFcombiselect_30db(n).IPCy;X=CFcombiselect_30db(n).ISRx;Y=CFcombiselect_30db(n).ISRy;
    if (CFcombiselect_30db(n).CP < -0.5)|(CFcombiselect_30db(n).CP >= 0.5)
        %CFcombiselect_30db(n).CPr=CFcombiselect_30db(n).CP-round(CFcombiselect_30db(n).CP);
        y=y+(CFcombiselect_30db(n).CPr-CFcombiselect_30db(n).CP);
    %else
        %CFcombiselect_30db(n).CPr=CFcombiselect_30db(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect_30db(n).BPr=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).BF;
    xb=CFcombiselect_30db(n).BF;yb=CFcombiselect_30db(n).BPr;
    %CFcombiselect_30db(n).CF1p=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).CF1;
    x1=CFcombiselect_30db(n).CF1;y1=CFcombiselect_30db(n).CF1p;
    %CFcombiselect_30db(n).CF2p=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*CFcombiselect_30db(n).CF2;
    x2=CFcombiselect_30db(n).CF2;y2=CFcombiselect_30db(n).CF2p;
    
    %plot(x,y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    %plot(x1,y1,'k<','MarkerSize',6);%CFc
    %plot(x2,y2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect_30db(n).CPr+(CFcombiselect_30db(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect_30db(n).BestITD)/1000+yb,'LineStyle',
    %'-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    end;
end;
axis([0 4000 -3 3]);
title('30dB');xlabel('Tone frequency (Hz)');ylabel('Interaural phase (cycles)');
hold off;



