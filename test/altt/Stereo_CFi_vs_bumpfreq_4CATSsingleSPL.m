single=CFcombiselect4CATS_bump(1);
for n=1:length(CFcombiselect4CATS_bump)
    if CFcombiselect4CATS_bump(n).SPL1(1)==70
        single=[single,CFcombiselect4CATS_bump(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect4CATS_bump70db',single);
structplot(CFcombiselect4CATS_bump70db,'bumpfreq','BF');axis([0 4000 0 4000]);hold on;x=(1:1:4000);y=x;plot(x,y,'k');
hold off;

single=CFcombiselect4CATS_bump(1);
for n=1:length(CFcombiselect4CATS_bump)
    if CFcombiselect4CATS_bump(n).SPL1(1)==60
        single=[single,CFcombiselect4CATS_bump(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect4CATS_bump60db',single);
structplot(CFcombiselect4CATS_bump60db,'bumpfreq','BF');axis([0 4000 0 4000]);hold on;x=(1:1:4000);y=x;plot(x,y,'k');
hold off;

single=CFcombiselect4CATS_bump(1);
for n=1:length(CFcombiselect4CATS_bump)
    if CFcombiselect4CATS_bump(n).SPL1(1)==50
        single=[single,CFcombiselect4CATS_bump(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect4CATS_bump50db',single);
structplot(CFcombiselect4CATS_bump50db,'bumpfreq','BF');axis([0 4000 0 4000]);hold on;x=(1:1:4000);y=x;plot(x,y,'k');
hold off;

single=CFcombiselect4CATS_bump(1);
for n=1:length(CFcombiselect4CATS_bump)
    if CFcombiselect4CATS_bump(n).SPL1(1)==40
        single=[single,CFcombiselect4CATS_bump(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect4CATS_bump40db',single);
structplot(CFcombiselect4CATS_bump40db,'bumpfreq','BF');axis([0 4000 0 4000]);hold on;x=(1:1:4000);y=x;plot(x,y,'k');
hold off;

single=CFcombiselect4CATS_bump(1);
for n=1:length(CFcombiselect4CATS_bump)
    if CFcombiselect4CATS_bump(n).SPL1(1)==30
        single=[single,CFcombiselect4CATS_bump(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect4CATS_bump30db',single);
structplot(CFcombiselect4CATS_bump30db,'bumpfreq','BF');axis([0 4000 0 4000]);hold on;x=(1:1:4000);y=x;plot(x,y,'k');
hold off;


