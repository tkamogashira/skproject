for n=1:length(sacxac585)
    ds=dataset(sacxac585(n).ds1.filename,sacxac585(n).ds1.seqid);
    sacxac585(n).indepval=(ds.indepval)';
    sacxac585(n).rate=getrate(ds,find((ds.indepval)'~=0),50,1000);
end