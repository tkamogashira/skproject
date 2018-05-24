for k=1:length(D1)
    if (1<=k&k<=34)|...
            (k==53)|...
            (70<=k&k<=94)|...
            (107<=k&k<=108)|...
            (121<=k&k<=140)|...
            (155<=k&k<=238)|...
            (284<=k&k<=285)
        ds=dataset(D1(k).ds.filename, D1(k).ds.seqid);
        D1(k).CF=ds.Stimulus.Special.CarFreq;
        clear ds;
    else
        D1(k).CF=0;
    end;
end;
for k=1:length(D1)
    if D1(k).CF==0
        D11=structfilter(D1,'$CF$ > 0');
        for s=1:length(D11)
            if strcmp(D11(s).ds.filename,D1(k).ds.filename)==1&...
                    strncmp(D11(s).ds.seqid,D1(k).ds.seqid,2)==1
                D1(k).CF=D11(s).CF;
            end;
        end;
        clear D11;
    end;
end;
assignin('base','D1CF',D1);

                
        
    
    
    
    