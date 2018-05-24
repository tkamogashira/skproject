single=CFcombiselect8121(1);

for n=1:length(CFcombiselect8121)
    
    group=CFcombiselect8121(n);
    for k=1:length(CFcombiselect8121)
        if CFcombiselect8121(k).CF1==CFcombiselect8121(n).CF1 & CFcombiselect8121(k).CF2==CFcombiselect8121(n).CF2
            group=[group,CFcombiselect8121(k)];
        end;
    end;
    for m=1:length(group)
        group(m).spl=group(m).SPL1(1);
    end
    groupspl=structfield(group,'spl');Size=size(groupspl,1);
    if groupspl(1)==max(groupspl(2:Size))
        single=[single,CFcombiselect8121(n)];
    end;
    clear group;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121single',single);

    