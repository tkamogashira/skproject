% E1to10n5p005Dplus
function E=E1to10n5p005Dplus(M1,M2,M3,M4,M5,N1,N2,N3,N4,N5)
D1=M1-N1;
D2=M2-N2;
D3=M3-N3;
D4=M4-N4;
D5=M5-M5;
for n=1:202
    for f=15:137
        D((f-14),n)=mean([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n)]);
        [H((f-14),n),sig,ci]=ttest([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n)],0,0.05,0);
        if H((f-14),n)*D((f-14),n)>0
            E((f-14),n)=1;
        else
            E((f-14),n)=0;
        end
    end
end
E((1:123),203)=M1((15:137),203);
assignin('base','E',E);    
end



