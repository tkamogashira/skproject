% E1to10TemporalChDiffN9
function SelectChN1=E1to10TemporalChDiffN9(M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9,V)
D1(:,(1:202))=M1(:,(1:202))-N1(:,(1:202));
D2(:,(1:202))=M2(:,(1:202))-N2(:,(1:202));
D3(:,(1:202))=M3(:,(1:202))-N3(:,(1:202));
D4(:,(1:202))=M4(:,(1:202))-N4(:,(1:202));
D5(:,(1:202))=M5(:,(1:202))-N5(:,(1:202));
D6(:,(1:202))=M6(:,(1:202))-N6(:,(1:202));
D7(:,(1:202))=M7(:,(1:202))-N7(:,(1:202));
D8(:,(1:202))=M8(:,(1:202))-N8(:,(1:202));
D9(:,(1:202))=M9(:,(1:202))-N9(:,(1:202));
D1S((1:123),203)=M1((15:137),203);
for n=1:202
    for f=15:137
        D1S((f-14),n)=D1(f,n);
    end
end
D2S((1:123),203)=M2((15:137),203);
for n=1:202
    for f=15:137
        D2S((f-14),n)=D2(f,n);
    end
end
D3S((1:123),203)=M3((15:137),203);
for n=1:202
    for f=15:137
        D3S((f-14),n)=D3(f,n);
    end
end
D4S((1:123),203)=M4((15:137),203);
for n=1:202
    for f=15:137
        D4S((f-14),n)=D4(f,n);
    end
end
D5S((1:123),203)=M5((15:137),203);
for n=1:202
    for f=15:137
        D5S((f-14),n)=D5(f,n);
    end
end
D6S((1:123),203)=M6((15:137),203);
for n=1:202
    for f=15:137
        D6S((f-14),n)=D6(f,n);
    end
end
D7S((1:123),203)=M7((15:137),203);
for n=1:202
    for f=15:137
        D7S((f-14),n)=D7(f,n);
    end
end
D8S((1:123),203)=M8((15:137),203);
for n=1:202
    for f=15:137
        D8S((f-14),n)=D8(f,n);
    end
end
D9S((1:123),203)=M9((15:137),203);
for n=1:202
    for f=15:137
        D9S((f-14),n)=D9(f,n);
    end
end
for F=1:123
    SelectAmp1(F,1)=mean([D1S(F,1),D1S(F,find(V(2,(3:139))>0)),D1S(F,find(V(2,(141:202))>0))]);
    SelectAmp2(F,1)=mean([D2S(F,1),D2S(F,find(V(2,(3:139))>0)),D2S(F,find(V(2,(141:202))>0))]);
    SelectAmp3(F,1)=mean([D3S(F,1),D3S(F,find(V(2,(3:139))>0)),D3S(F,find(V(2,(141:202))>0))]);
    SelectAmp4(F,1)=mean([D4S(F,1),D4S(F,find(V(2,(3:139))>0)),D4S(F,find(V(2,(141:202))>0))]);
    SelectAmp5(F,1)=mean([D5S(F,1),D5S(F,find(V(2,(3:139))>0)),D5S(F,find(V(2,(141:202))>0))]);
    SelectAmp6(F,1)=mean([D6S(F,1),D6S(F,find(V(2,(3:139))>0)),D6S(F,find(V(2,(141:202))>0))]);
    SelectAmp7(F,1)=mean([D7S(F,1),D7S(F,find(V(2,(3:139))>0)),D7S(F,find(V(2,(141:202))>0))]);
    SelectAmp8(F,1)=mean([D8S(F,1),D8S(F,find(V(2,(3:139))>0)),D8S(F,find(V(2,(141:202))>0))]);
    SelectAmp9(F,1)=mean([D9S(F,1),D9S(F,find(V(2,(3:139))>0)),D9S(F,find(V(2,(141:202))>0))]);
    SelectChN1(F,1)=nnz([D1S(F,1),D1S(F,find(V(2,(3:139))>0)),D1S(F,find(V(2,(141:202))>0))]);
end;
DiffAmp1to9=[SelectAmp1,SelectAmp2,SelectAmp3,SelectAmp4,SelectAmp5,SelectAmp6,SelectAmp7,SelectAmp8,SelectAmp9];
for fp=1:123
    [H,P(fp,1),ci]=ttest(DiffAmp1to9(fp,(1:9)),0,0.01,0);
end;
DiffAmp1to9plusP=[DiffAmp1to9,D1S((1:123),203)/1000,P];
assignin('base','DiffAmp1to9plusP',DiffAmp1to9plusP);
plot(DiffAmp1to9plusP((1:123),10),DiffAmp1to9plusP((1:123),11))
end



