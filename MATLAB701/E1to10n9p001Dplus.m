% E1to10n9p001Dplus
function E=E1to10n9p001Dplus(M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9)
D1=M1-N1;
D2=M2-N2;
D3=M3-N3;
D4=M4-N4;
D5=M5-N5;
D6=M6-N6;
D7=M7-N7;
D8=M8-N8;
D9=M9-N9;
for n=1:202
    for f=15:137
        D((f-14),n)=mean([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n),D7(f,n),D8(f,n),D9(f,n)]);
        [H((f-14),n),sig,ci]=ttest([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n),D7(f,n),D8(f,n),D9(f,n)],0,0.01,0);
        if H((f-14),n)*D((f-14),n)>0
            E((f-14),n)=1;
        else
            E((f-14),n)=0;
        end
    end
end
EV((1:123),203)=M1((15:137),203);
EV((1:123),(1:202))=E((1:123),(1:202));
for s=1:123
    EV(s,204)=sum(E(s,(1:202)));
end
assignin('base','EV',EV);   
end



