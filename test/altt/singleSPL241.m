single=CFcombiselect241(1);

for n=1:length(CFcombiselect241)
    
    group=CFcombiselect241(n);
    for k=1:length(CFcombiselect241)
        if CFcombiselect241(k).CF1==CFcombiselect241(n).CF1 & CFcombiselect241(k).CF2==CFcombiselect241(n).CF2
            group=[group,CFcombiselect241(k)];
        end;
    end;
    for m=1:length(group)
        group(m).spl=group(m).SPL1(1);
    end
    groupspl=structfield(group,'spl');Size=size(groupspl,1);
    if groupspl(1)==max(groupspl(2:Size))
        single=[single,CFcombiselect241(n)];
    end;
    clear group;
end;
single=single(2:length(single));
assignin('base','CFcombiselect241single',single);

    