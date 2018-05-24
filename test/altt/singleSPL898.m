single=CFcombiselect898(1);

for n=1:length(CFcombiselect898)
    
    group=CFcombiselect898(n);
    for k=1:length(CFcombiselect898)
        if CFcombiselect898(k).CF1==CFcombiselect898(n).CF1 & CFcombiselect898(k).CF2==CFcombiselect898(n).CF2
            group=[group,CFcombiselect898(k)];
        end;
    end;
    for m=1:length(group)
        group(m).spl=group(m).SPL1(1);
    end
    groupspl=structfield(group,'spl');Size=size(groupspl,1);
    if groupspl(1)==max(groupspl(2:Size))
        single=[single,CFcombiselect898(n)];
    end;
    clear group;
end;
single=single(2:length(single));
assignin('base','CFcombiselect898single',single);

    