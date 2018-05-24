averageN=20;
a=1;
for n=1:9
    N=2^n
    p1=(a*(N/2)+(-a)*(N/2))/N;
    P=[1;p1];
    for m=2:averageN
        x=(P(2,m-1)+a*(-1)^(m-1))/N;
        P=[P [m;x]];
    end;
    display(P)
    f = ceil(100.*rand(100,1));
    plot(P(1,:),P(2,:),'color',[f(1)/100 f(2)/100 f(3)/100]);hold on;grid on;
    clear f;
end;

%plot([0 0],[a -a],'ro');hold off;

