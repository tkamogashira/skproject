for k=1:585
    for n=1:length(Dthr186)
        if strcmp(Dthr186(n).ds.filename,sacxac615(k).ds1.filename)==1&...
                strncmp(Dthr186(n).ds.seqid,sacxac615(k).ds1.seqid,2)==1
            sacxac615(k).CF=Dthr186(n).thr.cf;
            sacxac615(k).THR=Dthr186(n).thr.minthr;
            sacxac615(k).thrfile=Dthr186(n).ds.filename;
            sacxac615(k).thrds=Dthr186(n).ds.seqid;
            sacxac615(k).depth=Dthr186(n).depth;
        end;
    end;
end;

%correction for G0819B

sacxac615(1).CF=Dthr186(1).thr.cf;sacxac615(1).THR=Dthr186(1).thr.minthr;sacxac615(1).thrds=Dthr186(1).ds.seqid;sacxac615(1).depth=Dthr186(1).depth;
sacxac615(2).CF=Dthr186(1).thr.cf;sacxac615(2).THR=Dthr186(1).thr.minthr;sacxac615(2).thrds=Dthr186(1).ds.seqid;sacxac615(2).depth=Dthr186(1).depth;
sacxac615(3).CF=Dthr186(1).thr.cf;sacxac615(3).THR=Dthr186(1).thr.minthr;sacxac615(3).thrds=Dthr186(1).ds.seqid;sacxac615(3).depth=Dthr186(1).depth;

sacxac615(4).CF=Dthr186(2).thr.cf;sacxac615(4).THR=Dthr186(2).thr.minthr;sacxac615(4).thrds=Dthr186(2).ds.seqid;sacxac615(4).depth=Dthr186(2).depth;
sacxac615(5).CF=Dthr186(2).thr.cf;sacxac615(5).THR=Dthr186(2).thr.minthr;sacxac615(5).thrds=Dthr186(2).ds.seqid;sacxac615(5).depth=Dthr186(2).depth;
sacxac615(6).CF=Dthr186(2).thr.cf;sacxac615(6).THR=Dthr186(2).thr.minthr;sacxac615(6).thrds=Dthr186(2).ds.seqid;sacxac615(6).depth=Dthr186(2).depth;

sacxac615(7).CF=Dthr186(3).thr.cf;sacxac615(7).THR=Dthr186(3).thr.minthr;sacxac615(7).thrds=Dthr186(3).ds.seqid;sacxac615(7).depth=Dthr186(3).depth;
sacxac615(8).CF=Dthr186(3).thr.cf;sacxac615(8).THR=Dthr186(3).thr.minthr;sacxac615(8).thrds=Dthr186(3).ds.seqid;sacxac615(8).depth=Dthr186(3).depth;
sacxac615(9).CF=Dthr186(3).thr.cf;sacxac615(9).THR=Dthr186(3).thr.minthr;sacxac615(9).thrds=Dthr186(3).ds.seqid;sacxac615(9).depth=Dthr186(3).depth;

sacxac615(10).CF=Dthr186(4).thr.cf;sacxac615(10).THR=Dthr186(4).thr.minthr;sacxac615(10).thrds=Dthr186(4).ds.seqid;sacxac615(10).depth=Dthr186(4).depth;
sacxac615(11).CF=Dthr186(4).thr.cf;sacxac615(11).THR=Dthr186(4).thr.minthr;sacxac615(11).thrds=Dthr186(4).ds.seqid;sacxac615(11).depth=Dthr186(4).depth;

%correction for G0894
sacxac615(444).CF=Dthr186(117).thr.cf;sacxac615(444).THR=Dthr186(117).thr.minthr;sacxac615(444).thrds=Dthr186(117).ds.seqid;sacxac615(444).depth=Dthr186(117).depth;
sacxac615(445).CF=Dthr186(117).thr.cf;sacxac615(445).THR=Dthr186(117).thr.minthr;sacxac615(445).thrds=Dthr186(117).ds.seqid;sacxac615(445).depth=Dthr186(117).depth;
sacxac615(446).CF=Dthr186(117).thr.cf;sacxac615(446).THR=Dthr186(117).thr.minthr;sacxac615(446).thrds=Dthr186(117).ds.seqid;sacxac615(446).depth=Dthr186(117).depth;

sacxac615(447).CF=Dthr186(118).thr.cf;sacxac615(447).THR=Dthr186(118).thr.minthr;sacxac615(447).thrds=Dthr186(118).ds.seqid;sacxac615(447).depth=Dthr186(118).depth;
sacxac615(448).CF=Dthr186(118).thr.cf;sacxac615(448).THR=Dthr186(118).thr.minthr;sacxac615(448).thrds=Dthr186(118).ds.seqid;sacxac615(448).depth=Dthr186(118).depth;

%New data since G0904
for k=586:615
    for n=1:length(Dthr36)
        if strcmp(Dthr36(n).ds.filename,sacxac615(k).ds1.filename)==1&...
                strncmp(Dthr36(n).ds.seqid,sacxac615(k).ds1.seqid,2)==1
            sacxac615(k).CF=Dthr36(n).thr.cf;
            sacxac615(k).THR=Dthr36(n).thr.minthr;
            sacxac615(k).thrfile=Dthr36(n).ds.filename;
            sacxac615(k).thrds=Dthr36(n).ds.seqid;
            sacxac615(k).depth=Dthr36(n).depth;
        end;
    end;
end;