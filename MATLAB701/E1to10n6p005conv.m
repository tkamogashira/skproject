% E1to10n6p005Dplus
function EV=E1to10n6p005conv(M1,M2,M3,M4,M5,M6,N1,N2,N3,N4,N5,N6)
D1=M1-N1;
D2=M2-N2;
D3=M3-N3;
D4=M4-N4;
D5=M5-N5;
D6=M6-N6;
for n=1:202
    for f=1:137
        D(f,n)=mean([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n)]);
        [H(f,n),sig,ci]=ttest([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n)],0,0.05,0);
        if H(f,n)*D(f,n)>0
            E(f,n)=1;
        else
            E(f,n)=0;
        end
    end
end
EV((1:137),(1:202))=E((1:137),(1:202))
EV((1:137),203)=M1((1:137),203);
for s=1:137
    EV(s,204)=sum(E(s,(1:202)));
end
assignin('base','EV',EV);    
end



