single=CFcombiselect242(1);

for n=1:length(CFcombiselect242)
    
    group=CFcombiselect242(n);
    for k=1:length(CFcombiselect242)
        if CFcombiselect242(k).CF1==CFcombiselect242(n).CF1 & CFcombiselect242(k).CF2==CFcombiselect242(n).CF2
            group=[group,CFcombiselect242(k)];
        end;
    end;
    for m=1:length(group)
        group(m).spl=group(m).SPL1(1);
    end
    groupspl=structfield(group,'spl');Size=size(groupspl,1);
    if groupspl(1)==max(groupspl(2:Size))
        single=[single,CFcombiselect242(n)];
    end;
    clear group;
end;
single=single(2:length(single));
assignin('base','CFcombiselect242single',single);

    