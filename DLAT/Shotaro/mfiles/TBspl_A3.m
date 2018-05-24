D1=structsort(D,'$Evalisi$');
for s=1:length(D1)
    [a,n]=max(D1(s).R);
    D1(s).maxR=a;
    D1(s).maxRRaySig=D1(s).RaySig(n);
    clear a;clear n;
    D1(s).StimFreq=D1(s).BinFreq(1);
end;
D1_A=D1([1 3:57 58:81 82:89 90 91:108 109:124 125:129]);
D1_As=structfilter(D1_A,'$maxRRaySig$ <=0.001');
D1_An=structfilter(D1_A,'$maxRRaySig$ >0.001');
structplot(D1_As,'StimFreq','maxR',D1_An,'StimFreq','maxR')







