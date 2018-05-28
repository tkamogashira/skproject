% ConvBBminusNoBB
function Dif=BBminusNoBB(M,N,F)
ConvM((1:137),203)=M((1:137),203);
ConvM((1:10),(1:202))=M((1:10),(1:202));
for m=1:202
    for f=11:137
        ConvM(f,m)=M(f,m)-mean(M(((f-10):(f+10)),m));
    end
end  
ConvN((1:137),203)=N((1:137),203);
ConvN((1:10),(1:202))=N((1:10),(1:202));
for n=1:202
    for g=11:137
        ConvN(g,n)=N(g,n)-mean(N(((g-10):(g+10)),n));
    end
end
D=[(ConvM((15:137),(1:202))-ConvN((15:137),(1:202))),ConvM((15:137),203)];
Dif=[F;D];
assignin('base','Dif',Dif);    
end



