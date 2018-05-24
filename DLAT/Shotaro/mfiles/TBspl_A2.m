
for k=[1 3:57 90 125:129]
    [a,n]=max(D1(k).R);
    if D1(k).RaySig(n)<=0.001
        plot(D1(k).CF, max(D1(k).R), 'ro','MarkerFaceColor','r');grid on;hold on
    else
        plot(D1(k).CF, max(D1(k).R), 'ro');grid on;hold on
    end;
    clear a;clear n;
end

for k=58:81
    [a,n]=max(D1(k).R);
    if D1(k).RaySig(n)<=0.001
        plot(1000, max(D1(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(1000, max(D1(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=82:89
    [a,n]=max(D1(k).R);
    if D1(k).RaySig(n)<=0.001
        plot(250, max(D1(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(250, max(D1(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=91:108
    [a,n]=max(D1(k).R);
    if D1(k).RaySig(n)<=0.001
        plot(500, max(D1(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(500, max(D1(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=109:124
    [a,n]=max(D1(k).R);
    if D1(k).RaySig(n)<=0.001
        plot(750, max(D1(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(750, max(D1(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end




