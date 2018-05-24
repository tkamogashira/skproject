single=CFcombiselect8121(1);

for n=1:length(CFcombiselect8121)

    if CFcombiselect8121(n).SPL1(1)==70
        single=[single,CFcombiselect8121(n)];
    end;
end;

single=single(2:length(single));
assignin('base','CFcombiselect8121single70db',single);

    