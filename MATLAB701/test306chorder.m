%ymmt306to204

%ChanName has 1*315 cell
ChanName306=[];
for n=1:306
    ch=[str2num(ChanName{n}(5:8));str2num(ChanName{n}(8))];
    ChanName306=[ChanName306 ch];
    clear ch;
end;

[val,ind]=find(ChanName306(2,:)>1);
ChanName204from306=ChanName306(:,ind);

def=channels204XYarea(1,:)-ChanName204from306(1,:)

testresult=[channels204XYarea(1,:);ChanName204from306(1,:);def];
