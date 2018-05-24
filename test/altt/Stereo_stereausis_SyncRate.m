for n=1:length(CFcombiselect241)
    x=CFcombiselect241(n).ISRx;
    y=CFcombiselect241(n).ISRy;
    level=CFcombiselect241(n).SPL1(1);
    if level==70
        plot(x,y,'r');hold on;
    elseif level==60
        plot(x,y,'g');hold on;
    elseif level==50
        plot(x,y,'b');hold on;
    elseif level==40
        plot(x,y,'c');hold on;
    elseif level==30
        plot(x,y,'k');hold on;
    end;
end;hold off;
figure
for n=1:length(CFcombiselect242)
    x=CFcombiselect242(n).ISRx;
    y=CFcombiselect242(n).ISRy;
    level=CFcombiselect242(n).SPL1(1);
    if level==70
        plot(x,y,'r');hold on;
    elseif level==60
        plot(x,y,'g');hold on;
    elseif level==50
        plot(x,y,'b');hold on;
    elseif level==40
        plot(x,y,'c');hold on;
    elseif level==30
        plot(x,y,'k');hold on;
    end;
end;hold off;
figure
for n=1:length(CFcombiselect898)
    x=CFcombiselect898(n).ISRx;
    y=CFcombiselect898(n).ISRy;
    level=CFcombiselect898(n).SPL1(1);
    if level==70
        plot(x,y,'r');hold on;
    elseif level==60
        plot(x,y,'g');hold on;
    elseif level==50
        plot(x,y,'b');hold on;
    elseif level==40
        plot(x,y,'c');hold on;
    elseif level==30
        plot(x,y,'k');hold on;
    end;
end;hold off;
figure
for n=1:length(CFcombiselect8121)
    x=CFcombiselect8121(n).ISRx;
    y=CFcombiselect8121(n).ISRy;
    level=CFcombiselect8121(n).SPL1(1);
    if level==70
        plot(x,y,'r');hold on;
    elseif level==60
        plot(x,y,'g');hold on;
    elseif level==50
        plot(x,y,'b');hold on;
    elseif level==40
        plot(x,y,'c');hold on;
    elseif level==30
        plot(x,y,'k');hold on;
    end;
end;hold off;

