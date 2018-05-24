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

subplot(5,2,1)
for n=1:length(CFcombiselect_70db)
    if CFcombiselect_70db(n).pLinReg < 0.005
    X=CFcombiselect_70db(n).IRx;Y=CFcombiselect_70db(n).IRmaxY;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 5]);
title('70dB');xlabel('Tone frequency (Hz)');ylabel('Maximal Interaural rate (spk/sec)');
hold off;

subplot(5,2,2)
for n=1:length(CFcombiselect_70db)
    if CFcombiselect_70db(n).pLinReg < 0.005
    X=CFcombiselect_70db(n).ISRx;Y=CFcombiselect_70db(n).ISRy;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 1]);
title('70dB');xlabel('Tone frequency (Hz)');ylabel('Interaural SyncRate (spl/sec)');
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

subplot(5,2,3)
for n=1:length(CFcombiselect_60db)
    if CFcombiselect_60db(n).pLinReg < 0.005
    X=CFcombiselect_60db(n).IRx;Y=CFcombiselect_60db(n).IRmaxY;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 5]);
title('60dB');xlabel('Tone frequency (Hz)');ylabel('Maximal interaural rate (spk/sec)');
hold off;

subplot(5,2,4)
for n=1:length(CFcombiselect_60db)
    if CFcombiselect_60db(n).pLinReg < 0.005
    X=CFcombiselect_60db(n).ISRx;Y=CFcombiselect_60db(n).ISRy;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 1]);
title('60dB');xlabel('Tone frequency (Hz)');ylabel('Interaural SyncRate (spk/sec)');
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

subplot(5,2,5)
for n=1:length(CFcombiselect_50db)
    if CFcombiselect_50db(n).pLinReg < 0.005
    X=CFcombiselect_50db(n).IRx;Y=CFcombiselect_50db(n).IRmaxY;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 5]);
title('50dB');xlabel('Tone frequency (Hz)');ylabel('Maximal interaural rate (spk/sec)');
hold off;

subplot(5,2,6)
for n=1:length(CFcombiselect_50db)
    if CFcombiselect_50db(n).pLinReg < 0.005
    X=CFcombiselect_50db(n).ISRx;Y=CFcombiselect_50db(n).ISRy;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 1]);
title('50dB');xlabel('Tone frequency (Hz)');ylabel('Interaural SyncRate (spk/sec)');
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

subplot(5,2,7)
for n=1:length(CFcombiselect_40db)
    if CFcombiselect_40db(n).pLinReg < 0.005
    X=CFcombiselect_40db(n).IRx;Y=CFcombiselect_40db(n).IRmaxY;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 5]);
title('40dB');xlabel('Tone frequency (Hz)');ylabel('Maximal interaural rate (spk/sec)');
hold off;

subplot(5,2,8)
for n=1:length(CFcombiselect_40db)
    if CFcombiselect_40db(n).pLinReg < 0.005
    X=CFcombiselect_40db(n).ISRx;Y=CFcombiselect_40db(n).ISRy;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 1]);
title('40dB');xlabel('Tone frequency (Hz)');ylabel('Interaural SyncRate (spk/sec)');
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

subplot(5,2,9)
for n=1:length(CFcombiselect_30db)
    if CFcombiselect_30db(n).pLinReg < 0.005
    X=CFcombiselect_30db(n).IRx;Y=CFcombiselect_30db(n).IRmaxY;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 5]);
title('30dB');xlabel('Tone frequency (Hz)');ylabel('Maximal interaural rate (spk/sec)');
hold off;

subplot(5,2,10)
for n=1:length(CFcombiselect_30db)
    if CFcombiselect_30db(n).pLinReg < 0.005
    X=CFcombiselect_30db(n).ISRx;Y=CFcombiselect_30db(n).ISRy;
    plot(X,Y,'-','LineWidth',0.5, 'Color',[0.7 0.7 0.7]);hold on;
    end;
end;
axis([0 4000 0 1]);
title('30dB');xlabel('Tone frequency (Hz)');ylabel('Interaural SyncRate (spk/sec)');
hold off;






