for n=1:length(D)
    rapcmd(['df ' D(n).ds1.filename]);
    rapcmd('SYNC MAN');
    rapcmd(['id ' D(n).ds1.seqid]);
    rapcmd('ou pst');
    rapcmd('PAUSE');
    %rapcmd('pr all');
    %rapcmd('clo all');
end;