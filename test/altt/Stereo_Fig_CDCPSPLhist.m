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

subplot(5,2,1);
lin70=structfilter(CFcombiselect_70db, '$pLinReg$ < 0.005');
ns70=structfilter(CFcombiselect_70db, '$pLinReg$ >= 0.005');
[ln,lb]=hist([lin70(:).CD],(-1.5:0.1:1.5));
[nn,nb]=hist([ns70(:).CD]',(-1.5:0.1:1.5));
bar(lb',[ln' nn'],1,'stack');xlim([-1.5 1.5]);
subplot(5,2,2);
[ln,lb]=hist([lin70(:).CPr],(-0.5:0.1:0.5));
[nn,nb]=hist([ns70(:).CPr],(-0.5:0.1:0.5));
bar(lb',[ln' nn'],'r',1,'stack');xlim([-0.5 0.5]);

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




