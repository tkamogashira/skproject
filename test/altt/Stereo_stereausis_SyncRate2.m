CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];
n70=0;n60=0;n50=0;n40=0;n30=0;
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).ISRx;
    y=CFcombiselectALL(n).ISRy;
    level=CFcombiselectALL(n).SPL1(1);
    if level==70
        plot(x,y,'k');axis([0 4000 0 0.8]);hold on;n70=n70+1;
    end;
end;hold off;
figure
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).ISRx;
    y=CFcombiselectALL(n).ISRy;
    level=CFcombiselectALL(n).SPL1(1);
    if level==60
        plot(x,y,'k');axis([0 4000 0 0.8]);hold on;n60=n60+1;
    end;
end;hold off;
figure
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).ISRx;
    y=CFcombiselectALL(n).ISRy;
    level=CFcombiselectALL(n).SPL1(1);
    if level==50
        plot(x,y,'k');axis([0 4000 0 0.8]);hold on;n50=n50+1;
    end;
end;hold off;
figure
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).ISRx;
    y=CFcombiselectALL(n).ISRy;
    level=CFcombiselectALL(n).SPL1(1);
    if level==40
        plot(x,y,'k');axis([0 4000 0 0.8]);hold on;n40=n40+1;
    end;
end;hold off;
figure
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).ISRx;
    y=CFcombiselectALL(n).ISRy;
    level=CFcombiselectALL(n).SPL1(1);
    if level==30
        plot(x,y,'k');axis([0 4000 0 0.8]);hold on;n30=n30+1;
    end;
end;hold off;
[n70 n60 n50 n40 n30]
n70+n60+n50+n40+n30
length(CFcombiselectALL)