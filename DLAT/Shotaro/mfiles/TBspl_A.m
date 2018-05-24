for k=[1 3:34 72:73]
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(D1CF(k).CF, max(D1CF(k).R), 'ro','MarkerFaceColor','r');grid on;hold on
    else
        plot(D1CF(k).CF, max(D1CF(k).R), 'ro');grid on;hold on
    end;
    clear a;clear n;
end

for k=35:48
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(1000, max(D1CF(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(1000, max(D1CF(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=49:52
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(250, max(D1CF(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(250, max(D1CF(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=54:62
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(500, max(D1CF(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(500, max(D1CF(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=63:69
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(750, max(D1CF(k).R), 'rd','MarkerFaceColor','g');grid on;hold on
    else
        plot(750, max(D1CF(k).R), 'rd');grid on;hold on
    end;
    clear a;clear n;
end

for k=[53 70:71 74]
    [a,n]=max(D1CF(k).R);
    if D1CF(k).RaySig(n)<=0.001
        plot(D1CF(k).CF, max(D1CF(k).R), 'co','MarkerFaceColor','c');grid on;hold on
    else
        plot(D1CF(k).CF, max(D1CF(k).R), 'co');grid on;hold on
    end;
    clear a;clear n;
end


