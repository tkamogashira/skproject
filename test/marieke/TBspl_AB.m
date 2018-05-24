for k=[1 3:34 72:73]
    plot(D1CF(k).CF, max(D1CF(k).R), 'ro');grid on;hold on
end

for k=35:48 
    plot(1000, max(D1CF(k).R), 'r*');grid on;hold on
end

for k=49:52
    plot(250, max(D1CF(k).R), 'r*');grid on;hold on
end

for k=54:62
    plot(500, max(D1CF(k).R), 'r*');grid on;hold on
end

for k=63:69
    plot(750, max(D1CF(k).R), 'r*');grid on;hold on
end

for k=[53 70:71 74]
    plot(D1CF(k).CF, max(D1CF(k).R), 'co');grid on;hold on
end

for k=[75:94 107:108 121:122 156:157]
    plot(D1CF(k).CF, max(D1CF(k).R), 'bo');grid on;hold on
end

for k=95:97 
    plot(1000, max(D1CF(k).R), 'b*');grid on;hold on
end

for k=98
    plot(250, max(D1CF(k).R), 'b*');grid on;hold on
end

for k=99:106
    plot(500, max(D1CF(k).R), 'b*');grid on;hold on
end

for k=109:120
    plot(750, max(D1CF(k).R), 'b*');grid on;hold on
end
