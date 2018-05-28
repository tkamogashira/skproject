% E1to10Width2HzMaxSelect
function M1S=E1to10Width2HzMaxSelect(M1)
M1S((1:123),203)=M1((15:137),203);
for n=1:202
    for f=15:137
        if M1(f,n)==max(M1(((f-14):(f+14)),n))
            M1S((f-14),n)=M1(f,n);
        else
            M1S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp1(F,1)=mean(nonzeros([M1S(F,1),M1S(F,(3:177)),M1S(F,(179:202))]));
    SelectChN1(F,1)=nnz([M1S(F,1),M1S(F,(3:177)),M1S(F,(179:202))]);
end
assignin('base','M1S',[M1S,SelectAmp1,SelectChN1]);
end



