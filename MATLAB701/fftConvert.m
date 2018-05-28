% fftConvert
function fftConv=fftConvert(M)
fftConv((1:137),203)=M((1:137),203);
fftConv((1:10),(1:202))=M((1:10),(1:202));
for n=1:202
    for f=11:137
        fftConv(f,n)=M(f,n)-mean(M(((f-10):(f+10)),n));
    end
end
assignin('base','fftConv',fftConv);    
end



