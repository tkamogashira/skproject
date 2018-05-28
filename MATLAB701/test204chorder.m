
ChanNamexx=[];
for n=1:204
    ch=str2num(ChanNamex{n}(5:8));
    ChanNamexx=[ChanNamexx ch];
    clear ch;
end;

def=channels204XYarea(1,:)-ChanNamexx

testresult=[channels204XYarea(1,:);ChanNamexx;def];
