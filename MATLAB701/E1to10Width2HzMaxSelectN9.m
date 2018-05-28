% E1to10Width2HzMaxSelectN9
function M1S=E1to10Width2HzMaxSelectN9(M1,M2,M3,M4,M5,M6,M7,M8,M9)
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
M2S((1:123),203)=M2((15:137),203);
for n=1:202
    for f=15:137
        if M2(f,n)==max(M2(((f-14):(f+14)),n))
            M2S((f-14),n)=M2(f,n);
        else
            M2S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp2(F,1)=mean(nonzeros([M2S(F,1),M2S(F,(3:177)),M2S(F,(179:202))]));
    SelectChN2(F,1)=nnz([M2S(F,1),M2S(F,(3:177)),M2S(F,(179:202))]);
end
M3S((1:123),203)=M3((15:137),203);
for n=1:202
    for f=15:137
        if M3(f,n)==max(M3(((f-14):(f+14)),n))
            M3S((f-14),n)=M3(f,n);
        else
            M3S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp3(F,1)=mean(nonzeros([M3S(F,1),M3S(F,(3:177)),M3S(F,(179:202))]));
    SelectChN3(F,1)=nnz([M3S(F,1),M3S(F,(3:177)),M3S(F,(179:202))]);
end
M4S((1:123),203)=M4((15:137),203);
for n=1:202
    for f=15:137
        if M4(f,n)==max(M4(((f-14):(f+14)),n))
            M4S((f-14),n)=M4(f,n);
        else
            M4S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp4(F,1)=mean(nonzeros([M4S(F,1),M4S(F,(3:177)),M4S(F,(179:202))]));
    SelectChN4(F,1)=nnz([M4S(F,1),M4S(F,(3:177)),M4S(F,(179:202))]);
end
M5S((1:123),203)=M5((15:137),203);
for n=1:202
    for f=15:137
        if M5(f,n)==max(M5(((f-14):(f+14)),n))
            M5S((f-14),n)=M5(f,n);
        else
            M5S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp5(F,1)=mean(nonzeros([M5S(F,1),M5S(F,(3:177)),M5S(F,(179:202))]));
    SelectChN5(F,1)=nnz([M5S(F,1),M5S(F,(3:177)),M5S(F,(179:202))]);
end
M6S((1:123),203)=M6((15:137),203);
for n=1:202
    for f=15:137
        if M6(f,n)==max(M6(((f-14):(f+14)),n))
            M6S((f-14),n)=M6(f,n);
        else
            M6S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp6(F,1)=mean(nonzeros([M6S(F,1),M6S(F,(3:177)),M6S(F,(179:202))]));
    SelectChN6(F,1)=nnz([M6S(F,1),M6S(F,(3:177)),M6S(F,(179:202))]);
end
M7S((1:123),203)=M7((15:137),203);
for n=1:202
    for f=15:137
        if M7(f,n)==max(M7(((f-14):(f+14)),n))
            M7S((f-14),n)=M7(f,n);
        else
            M7S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp7(F,1)=mean(nonzeros([M7S(F,1),M7S(F,(3:177)),M7S(F,(179:202))]));
    SelectChN7(F,1)=nnz([M7S(F,1),M7S(F,(3:177)),M7S(F,(179:202))]);
end
M8S((1:123),203)=M8((15:137),203);
for n=1:202
    for f=15:137
        if M8(f,n)==max(M8(((f-14):(f+14)),n))
            M8S((f-14),n)=M8(f,n);
        else
            M8S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp8(F,1)=mean(nonzeros([M8S(F,1),M8S(F,(3:177)),M8S(F,(179:202))]));
    SelectChN8(F,1)=nnz([M8S(F,1),M8S(F,(3:177)),M8S(F,(179:202))]);
end
M9S((1:123),203)=M9((15:137),203);
for n=1:202
    for f=15:137
        if M9(f,n)==max(M9(((f-14):(f+14)),n))
            M9S((f-14),n)=M9(f,n);
        else
            M9S((f-14),n)=0;
        end
    end
end
for F=1:123
    SelectAmp9(F,1)=mean(nonzeros([M9S(F,1),M9S(F,(3:177)),M9S(F,(179:202))]));
    SelectChN9(F,1)=nnz([M9S(F,1),M9S(F,(3:177)),M9S(F,(179:202))]);
end
assignin('base','SelectAmp1to9',[SelectAmp1,SelectAmp2,SelectAmp3,SelectAmp4,SelectAmp5,SelectAmp6,SelectAmp7,SelectAmp8,SelectAmp9]);
end



