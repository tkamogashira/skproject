filename=[];seqid=[];depth=[];
for n=1:length(D1_Ac)
    filename=strvcat(filename,D1_Ac(n).ds1.filename);
    seqid=strvcat(seqid,D1_Ac(n).ds1.seqid);
    depth=strvcat(depth,D1_Ac(n).depth);
    %filename(n,1)=str2num(D1_Ac(n).ds1.filename);
    %filename(n,2)=str2num(D1_Ac(n).ds1.seqid);
    %filename(n,3)=str2num(D1_Ac(n).depth);
end;
list=[filename ' ' seqid ' ' depth];