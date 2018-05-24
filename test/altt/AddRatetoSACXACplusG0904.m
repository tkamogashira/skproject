for n=1:length(sacxac615)
    ds=dataset(sacxac615(n).ds1.filename,sacxac615(n).ds1.seqid);
    sacxac615(n).indepval=(ds.indepval)';
    sacxac615(n).rate=getrate(ds,find((ds.indepval)'~=0),50,1000);
end