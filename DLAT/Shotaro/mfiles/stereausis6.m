for n=1:length(CFcombiselect)
    x1=CFcombiselect(n).CF1;
    x2=CFcombiselect(n).CF2;
    y=CFcombiselect(n).BF;
    plot(x1,y,'bo','MarkerSize',9);hold on;grid on;
    plot(x2,y,'ro','MarkerSize',9);hold on;grid on;
    xlabel('CF1(contra) in blue & CF2(ipsi) in red');ylabel('BF');
end;

for n=1:length(CFcombiselect241)
    x1=CFcombiselect(n).CF1;
    x2=CFcombiselect(n).CF2;
    y=CFcombiselect(n).BF;
    plot(x1,y,'bo','MarkerSize',9);hold on;grid on;
    plot(x2,y,'ro','MarkerSize',9);hold on;grid on;
    xlabel('CF1(contra) in blue & CF2(ipsi) in red');ylabel('BF');
end;

for n=1:length(CFcombiselect898)
    x1=CFcombiselect(n).CF1;
    x2=CFcombiselect(n).CF2;
    y=CFcombiselect(n).BF;
    plot(x1,y,'bo','MarkerSize',9);hold on;grid on;
    plot(x2,y,'ro','MarkerSize',9);hold on;grid on;
    xlabel('CF1(contra) in blue & CF2(ipsi) in red');ylabel('BF');
end;


