function struct2CD
SIZE=size(CFcombiselect);
startN=1;
for n=1:(SIZE(2)-1)
    if strcmp(CFcombiselect(n).Fiber2,CFcombiselect(n+1).Fiber2)==0
        CF2group=CFcombiselect(startN:n);
        startN=n+1;
        x=[CF2group(:).CF2]-[CF2group(:).CF1];y=[CF2group(:).CD];
        p=polyfit(x,y,1);
        z=polyval(p,x);
        structplot(CF2group,'$CF2$-$CF1$','$CD$','markers', {'o'}, 'Colors',{'k'});hold on
        plot(x,z,'r');
    end;
end
        
    