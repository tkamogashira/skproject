%ymmt306to204

%ChanName has 1*315 cell
ChanName306=[];
for n=1:306
    ch=[str2num(ChanName{n}(5:8));str2num(ChanName{n}(8))];
    ChanName306=[ChanName306 ch];
    clear ch;
end;

[val,ind]=find(ChanName306(2,:)>1);
ave_0001_204from306=[ave_0001(:,ind) ave_0001(:,316)];

%The obtained 204 chs data has the same order as channels204XYarea.







