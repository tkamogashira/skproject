% E3to5n6p001Dplus
function E=E3to5n6p001Dplus(M1,M2,M3,M4,M5,M6,N1,N2,N3,N4,N5,N6)
D1=M1-N1;
D2=M2-N2;
D3=M3-N3;
D4=M4-N4;
D5=M5-M5;
D6=M6-N6;
for n=1:202
    for f=42:69
        D((f-41),n)=mean([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n)]);
        [H((f-41),n),sig,ci]=ttest([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n)],0,0.01,0);
        if H((f-41),n)*D((f-41),n)>0
            E((f-41),n)=1;
        else
            E((f-41),n)=0;
        end
    end
end
E((1:28),203)=M1((42:69),203);
assignin('base','E',E);    
end



