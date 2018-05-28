% Pvalue3000to5000n6_2
function Pvalue=Pvalue3000to5000n6_2(M1,M2,M3,M4,M5,M6,N1,N2,N3,N4,N5,N6)
D1=M1-N1;
D2=M2-N2;
D3=M3-N3;
D4=M4-N4;
D5=M5-M5;
D6=M6-N6;
for n=1:202
    for f=42:69
        [h,Pvalue((f-41),n),ci]=ttest([D1(f,n),D2(f,n),D3(f,n),D4(f,n),D5(f,n),D6(f,n)],0,0.01,1);
    end
end
Pvalue((1:28),203)=M1((42:69),203)
assignin('base','Pvalue',Pvalue);    
end



