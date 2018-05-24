CFcombiselect241posCD=structfilter(CFcombiselect241,'$CD$>0');
CFcombiselect241posCDrate=length(CFcombiselect241posCD)/length(CFcombiselect241)

CFcombiselect242posCD=structfilter(CFcombiselect242,'$CD$>0');
CFcombiselect242posCDrate=length(CFcombiselect242posCD)/length(CFcombiselect242)

CFcombiselect898posCD=structfilter(CFcombiselect898,'$CD$>0');
CFcombiselect898posCDrate=length(CFcombiselect898posCD)/length(CFcombiselect898)

CFcombiselect8121posCD=structfilter(CFcombiselect8121,'$CD$>0');
CFcombiselect8121posCDrate=length(CFcombiselect8121posCD)/length(CFcombiselect8121)

CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

CFcombiselectALLposCD=structfilter(CFcombiselectALL,'$CD$>0');
length(CFcombiselectALLposCD)
length(CFcombiselectALL)
CFcombiselectALLposCDrate=length(CFcombiselectALLposCD)/length(CFcombiselectALL)

for n=1:length(CFcombiselectALL)
    plot(CFcombiselectALL(n).SPL1(1),CFcombiselectALL(n).CD,'o');hold on
end;
hold off;

figure
for n=1:length(CFcombiselectALL)
    plot(CFcombiselectALL(n).BestITD,CFcombiselectALL(n).BF,'o');hold on
end;
hold off;


