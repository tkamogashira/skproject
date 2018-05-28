% ConvBB
function Dif=BB(M,F)
ConvM((1:137),203)=M((1:137),203);
ConvM((1:10),(1:202))=M((1:10),(1:202));
for m=1:202
    for f=11:137
        ConvM(f,m)=M(f,m)-mean(M(((f-10):(f+10)),m));
    end;
end;  
D=[ConvM((15:137),(1:202)),ConvM((15:137),203)];
Dif=[F;D];
assignin('base','Dif',Dif);    
end



