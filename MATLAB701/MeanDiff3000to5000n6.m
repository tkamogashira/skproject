% MeanDiff3000to5000n6
function MeanDiff=MeanDiff3000to5000n6(M1,M2,M3,M4,M5,M6,N1,N2,N3,N4,N5,N6)
for n=1:202
    for f=42:69
        MeanDiff((f-41),n)=mean([M1(f,n),M2(f,n),M3(f,n),M4(f,n),M5(f,n),M6(f,n)])-mean([N1(f,n),N2(f,n),N3(f,n),N4(f,n),N5(f,n),N6(f,n)]);
    end
end
MeanDiff((1:28),203)=M1((42:69),203)
assignin('base','MeanDiff',MeanDiff);    
end



