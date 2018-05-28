% E1to10Width1HzMaxSelectN9Wv
function M1S=E1to10Width1HzMaxSelectN9Wv(M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9)
M1S((1:123),203)=M1((15:137),203);
for n=1:202
    for f=15:137
        if M1(f,n)==max(M1(((f-7):(f+7)),n))
            M1S((f-14),n)=M1(f,n);
        else
            M1S((f-14),n)=0;
        end
    end
end
M2S((1:123),203)=M2((15:137),203);
for n=1:202
    for f=15:137
        if M2(f,n)==max(M2(((f-7):(f+7)),n))
            M2S((f-14),n)=M2(f,n);
        else
            M2S((f-14),n)=0;
        end
    end
end
M3S((1:123),203)=M3((15:137),203);
for n=1:202
    for f=15:137
        if M3(f,n)==max(M3(((f-7):(f+7)),n))
            M3S((f-14),n)=M3(f,n);
        else
            M3S((f-14),n)=0;
        end
    end
end
M4S((1:123),203)=M4((15:137),203);
for n=1:202
    for f=15:137
        if M4(f,n)==max(M4(((f-7):(f+7)),n))
            M4S((f-14),n)=M4(f,n);
        else
            M4S((f-14),n)=0;
        end
    end
end
M5S((1:123),203)=M5((15:137),203);
for n=1:202
    for f=15:137
        if M5(f,n)==max(M5(((f-7):(f+7)),n))
            M5S((f-14),n)=M5(f,n);
        else
            M5S((f-14),n)=0;
        end
    end
end
M6S((1:123),203)=M6((15:137),203);
for n=1:202
    for f=15:137
        if M6(f,n)==max(M6(((f-7):(f+7)),n))
            M6S((f-14),n)=M6(f,n);
        else
            M6S((f-14),n)=0;
        end
    end
end
M7S((1:123),203)=M7((15:137),203);
for n=1:202
    for f=15:137
        if M7(f,n)==max(M7(((f-7):(f+7)),n))
            M7S((f-14),n)=M7(f,n);
        else
            M7S((f-14),n)=0;
        end
    end
end
M8S((1:123),203)=M8((15:137),203);
for n=1:202
    for f=15:137
        if M8(f,n)==max(M8(((f-7):(f+7)),n))
            M8S((f-14),n)=M8(f,n);
        else
            M8S((f-14),n)=0;
        end
    end
end
M9S((1:123),203)=M9((15:137),203);
for n=1:202
    for f=15:137
        if M9(f,n)==max(M9(((f-7):(f+7)),n))
            M9S((f-14),n)=M9(f,n);
        else
            M9S((f-14),n)=0;
        end
    end
end
N1S((1:123),203)=N1((15:137),203);
for n=1:202
    for f=15:137
        if N1(f,n)==max(N1(((f-7):(f+7)),n))
            N1S((f-14),n)=N1(f,n);
        else
            N1S((f-14),n)=0;
        end
    end
end
N2S((1:123),203)=N2((15:137),203);
for n=1:202
    for f=15:137
        if N2(f,n)==max(N2(((f-7):(f+7)),n))
            N2S((f-14),n)=N2(f,n);
        else
            N2S((f-14),n)=0;
        end
    end
end
N3S((1:123),203)=N3((15:137),203);
for n=1:202
    for f=15:137
        if N3(f,n)==max(N3(((f-7):(f+7)),n))
            N3S((f-14),n)=N3(f,n);
        else
            N3S((f-14),n)=0;
        end
    end
end
N4S((1:123),203)=N4((15:137),203);
for n=1:202
    for f=15:137
        if N4(f,n)==max(N4(((f-7):(f+7)),n))
            N4S((f-14),n)=N4(f,n);
        else
            N4S((f-14),n)=0;
        end
    end
end
N5S((1:123),203)=N5((15:137),203);
for n=1:202
    for f=15:137
        if N5(f,n)==max(N5(((f-7):(f+7)),n))
            N5S((f-14),n)=N5(f,n);
        else
            N5S((f-14),n)=0;
        end
    end
end
N6S((1:123),203)=N6((15:137),203);
for n=1:202
    for f=15:137
        if N6(f,n)==max(N6(((f-7):(f+7)),n))
            N6S((f-14),n)=N6(f,n);
        else
            N6S((f-14),n)=0;
        end
    end
end
N7S((1:123),203)=N7((15:137),203);
for n=1:202
    for f=15:137
        if N7(f,n)==max(N7(((f-7):(f+7)),n))
            N7S((f-14),n)=N7(f,n);
        else
            N7S((f-14),n)=0;
        end
    end
end
N8S((1:123),203)=N8((15:137),203);
for n=1:202
    for f=15:137
        if N8(f,n)==max(N8(((f-7):(f+7)),n))
            N8S((f-14),n)=N8(f,n);
        else
            N8S((f-14),n)=0;
        end
    end
end
N9S((1:123),203)=N9((15:137),203);
for n=1:202
    for f=15:137
        if N9(f,n)==max(N9(((f-7):(f+7)),n))
            N9S((f-14),n)=N9(f,n);
        else
            N9S((f-14),n)=0;
        end
    end
end
for F=1:123
    if sum(nonzeros([M1S(F,1),M1S(F,(3:139)),M1S(F,(141:177)),M1S(F,(179:202))]))==0
        SelectAmpM1(F,1)=NaN;
    else
        SelectAmpM1(F,1)=sum(nonzeros([M1S(F,1),M1S(F,(3:139)),M1S(F,(141:177)),M1S(F,(179:202))]));
    end;
    if sum(nonzeros([M2S(F,1),M2S(F,(3:139)),M2S(F,(141:177)),M2S(F,(179:202))]))==0
        SelectAmpM2(F,1)=NaN;
    else
        SelectAmpM2(F,1)=sum(nonzeros([M2S(F,1),M2S(F,(3:139)),M2S(F,(141:177)),M2S(F,(179:202))]));
    end;
    if sum(nonzeros([M3S(F,1),M3S(F,(3:139)),M3S(F,(141:177)),M3S(F,(179:202))]))==0
        SelectAmpM3(F,1)=NaN;
    else
        SelectAmpM3(F,1)=sum(nonzeros([M3S(F,1),M3S(F,(3:139)),M3S(F,(141:177)),M3S(F,(179:202))]));
    end;
    if sum(nonzeros([M4S(F,1),M4S(F,(3:139)),M4S(F,(141:177)),M4S(F,(179:202))]))==0
        SelectAmpM4(F,1)=NaN;
    else
        SelectAmpM4(F,1)=sum(nonzeros([M4S(F,1),M4S(F,(3:139)),M4S(F,(141:177)),M4S(F,(179:202))]));
    end;
    if sum(nonzeros([M5S(F,1),M5S(F,(3:139)),M5S(F,(141:177)),M5S(F,(179:202))]))==0
        SelectAmpM5(F,1)=NaN;
    else
        SelectAmpM5(F,1)=sum(nonzeros([M5S(F,1),M5S(F,(3:139)),M5S(F,(141:177)),M5S(F,(179:202))]));
    end;
    if sum(nonzeros([M6S(F,1),M6S(F,(3:139)),M6S(F,(141:177)),M6S(F,(179:202))]))==0
        SelectAmpM6(F,1)=NaN;
    else
        SelectAmpM6(F,1)=sum(nonzeros([M6S(F,1),M6S(F,(3:139)),M6S(F,(141:177)),M6S(F,(179:202))]));
    end;
    if sum(nonzeros([M7S(F,1),M7S(F,(3:139)),M7S(F,(141:177)),M7S(F,(179:202))]))==0
        SelectAmpM7(F,1)=NaN;
    else
        SelectAmpM7(F,1)=sum(nonzeros([M7S(F,1),M7S(F,(3:139)),M7S(F,(141:177)),M7S(F,(179:202))]));
    end;
    if sum(nonzeros([M8S(F,1),M8S(F,(3:139)),M8S(F,(141:177)),M8S(F,(179:202))]))==0
        SelectAmpM8(F,1)=NaN;
    else
        SelectAmpM8(F,1)=sum(nonzeros([M8S(F,1),M8S(F,(3:139)),M8S(F,(141:177)),M8S(F,(179:202))]));
    end;
    if sum(nonzeros([M9S(F,1),M9S(F,(3:139)),M9S(F,(141:177)),M9S(F,(179:202))]))==0
        SelectAmpM9(F,1)=NaN;
    else
        SelectAmpM9(F,1)=sum(nonzeros([M9S(F,1),M9S(F,(3:139)),M9S(F,(141:177)),M9S(F,(179:202))]));
    end;
    if sum(nonzeros([N1S(F,1),N1S(F,(3:139)),N1S(F,(141:177)),N1S(F,(179:202))]))==0
        SelectAmpN1(F,1)=NaN;
    else
        SelectAmpN1(F,1)=sum(nonzeros([N1S(F,1),N1S(F,(3:139)),N1S(F,(141:177)),N1S(F,(179:202))]));
    end;
    if sum(nonzeros([N2S(F,1),N2S(F,(3:139)),N2S(F,(141:177)),N2S(F,(179:202))]))==0
        SelectAmpN2(F,1)=NaN;
    else
        SelectAmpN2(F,1)=sum(nonzeros([N2S(F,1),N2S(F,(3:139)),N2S(F,(141:177)),N2S(F,(179:202))]));
    end;
    if sum(nonzeros([N3S(F,1),N3S(F,(3:139)),N3S(F,(141:177)),N3S(F,(179:202))]))==0
        SelectAmpN3(F,1)=NaN;
    else
        SelectAmpN3(F,1)=sum(nonzeros([N3S(F,1),N3S(F,(3:139)),N3S(F,(141:177)),N3S(F,(179:202))]));
    end;
    if sum(nonzeros([N4S(F,1),N4S(F,(3:139)),N4S(F,(141:177)),N4S(F,(179:202))]))==0
        SelectAmpN4(F,1)=NaN;
    else
        SelectAmpN4(F,1)=sum(nonzeros([N4S(F,1),N4S(F,(3:139)),N4S(F,(141:177)),N4S(F,(179:202))]));
    end;
    if sum(nonzeros([N5S(F,1),N5S(F,(3:139)),N5S(F,(141:177)),N5S(F,(179:202))]))==0
        SelectAmpN5(F,1)=NaN;
    else
        SelectAmpN5(F,1)=sum(nonzeros([N5S(F,1),N5S(F,(3:139)),N5S(F,(141:177)),N5S(F,(179:202))]));
    end;
    if sum(nonzeros([N6S(F,1),N6S(F,(3:139)),N6S(F,(141:177)),N6S(F,(179:202))]))==0
        SelectAmpN6(F,1)=NaN;
    else
        SelectAmpN6(F,1)=sum(nonzeros([N6S(F,1),N6S(F,(3:139)),N6S(F,(141:177)),N6S(F,(179:202))]));
    end;
    if sum(nonzeros([N7S(F,1),N7S(F,(3:139)),N7S(F,(141:177)),N7S(F,(179:202))]))==0
        SelectAmpN7(F,1)=NaN;
    else
        SelectAmpN7(F,1)=sum(nonzeros([N7S(F,1),N7S(F,(3:139)),N7S(F,(141:177)),N7S(F,(179:202))]));
    end;
    if sum(nonzeros([N8S(F,1),N8S(F,(3:139)),N8S(F,(141:177)),N8S(F,(179:202))]))==0
        SelectAmpN8(F,1)=NaN;
    else
        SelectAmpN8(F,1)=sum(nonzeros([N8S(F,1),N8S(F,(3:139)),N8S(F,(141:177)),N8S(F,(179:202))]));
    end;
    if sum(nonzeros([N9S(F,1),N9S(F,(3:139)),N9S(F,(141:177)),N9S(F,(179:202))]))==0
        SelectAmpN9(F,1)=NaN;
    else
        SelectAmpN9(F,1)=sum(nonzeros([N9S(F,1),N9S(F,(3:139)),N9S(F,(141:177)),N9S(F,(179:202))]));
    end;
    SelectChM1(F,1)=nnz([M1S(F,1),M1S(F,(3:139)),M1S(F,(141:177)),M1S(F,(179:202))]);
    SelectChM2(F,1)=nnz([M2S(F,1),M2S(F,(3:139)),M2S(F,(141:177)),M2S(F,(179:202))]);
    SelectChM3(F,1)=nnz([M3S(F,1),M3S(F,(3:139)),M3S(F,(141:177)),M3S(F,(179:202))]);
    SelectChM4(F,1)=nnz([M4S(F,1),M4S(F,(3:139)),M4S(F,(141:177)),M4S(F,(179:202))]);
    SelectChM5(F,1)=nnz([M5S(F,1),M5S(F,(3:139)),M5S(F,(141:177)),M5S(F,(179:202))]);
    SelectChM6(F,1)=nnz([M6S(F,1),M6S(F,(3:139)),M6S(F,(141:177)),M6S(F,(179:202))]);
    SelectChM7(F,1)=nnz([M7S(F,1),M7S(F,(3:139)),M7S(F,(141:177)),M7S(F,(179:202))]);
    SelectChM8(F,1)=nnz([M8S(F,1),M8S(F,(3:139)),M8S(F,(141:177)),M8S(F,(179:202))]);
    SelectChM9(F,1)=nnz([M9S(F,1),M9S(F,(3:139)),M9S(F,(141:177)),M9S(F,(179:202))]);
    SelectChN1(F,1)=nnz([N1S(F,1),N1S(F,(3:139)),N1S(F,(141:177)),N1S(F,(179:202))]);
    SelectChN2(F,1)=nnz([N2S(F,1),N2S(F,(3:139)),N2S(F,(141:177)),N2S(F,(179:202))]);
    SelectChN3(F,1)=nnz([N3S(F,1),N3S(F,(3:139)),N3S(F,(141:177)),N3S(F,(179:202))]);
    SelectChN4(F,1)=nnz([N4S(F,1),N4S(F,(3:139)),N4S(F,(141:177)),N4S(F,(179:202))]);
    SelectChN5(F,1)=nnz([N5S(F,1),N5S(F,(3:139)),N5S(F,(141:177)),N5S(F,(179:202))]);
    SelectChN6(F,1)=nnz([N6S(F,1),N6S(F,(3:139)),N6S(F,(141:177)),N6S(F,(179:202))]);
    SelectChN7(F,1)=nnz([N7S(F,1),N7S(F,(3:139)),N7S(F,(141:177)),N7S(F,(179:202))]);
    SelectChN8(F,1)=nnz([N8S(F,1),N8S(F,(3:139)),N8S(F,(141:177)),N8S(F,(179:202))]);
    SelectChN9(F,1)=nnz([N9S(F,1),N9S(F,(3:139)),N9S(F,(141:177)),N9S(F,(179:202))]);    
end;
SelectAmpM1to9=[SelectAmpM1,SelectAmpM2,SelectAmpM3,SelectAmpM4,SelectAmpM5,SelectAmpM6,SelectAmpM7,SelectAmpM8,SelectAmpM9];
SelectAmpN1to9=[SelectAmpN1,SelectAmpN2,SelectAmpN3,SelectAmpN4,SelectAmpN5,SelectAmpN6,SelectAmpN7,SelectAmpN8,SelectAmpN9];
SelectChM1to9=[SelectChM1,SelectChM2,SelectChM3,SelectChM4,SelectChM5,SelectChM6,SelectChM7,SelectChM8,SelectChM9];
SelectChN1to9=[SelectChN1,SelectChN2,SelectChN3,SelectChN4,SelectChN5,SelectChN6,SelectChN7,SelectChN8,SelectChN9];
for fp=1:123
    if median(SelectAmpM1to9(fp,:))<median(SelectAmpN1to9(fp,:))
        P(fp,1)=1;
    elseif (nnz(SelectChM1to9(fp,:))<6)|(nnz(SelectChN1to9(fp,:))<6)
        P(fp,1)=1;
    else
        P(fp,1)=signrank(SelectAmpM1to9(fp,:),SelectAmpN1to9(fp,:),0.05);
    end;
end;
SelectChM1to9plusP=[SelectChM1to9,M1S((1:123),203)/1000,P];
SelectChN1to9plusP=[SelectChN1to9,N1S((1:123),203)/1000,P];
SelectAmpM1to9plusP=[SelectAmpM1to9,M1S((1:123),203)/1000,P];
SelectAmpN1to9plusP=[SelectAmpN1to9,N1S((1:123),203)/1000,P];
assignin('base','SelectChM1to9plusP',SelectChM1to9plusP);
assignin('base','SelectChN1to9plusP',SelectChN1to9plusP);
assignin('base','SelectAmpM1to9plusP',SelectAmpM1to9plusP);
assignin('base','SelectAmpN1to9plusP',SelectAmpN1to9plusP);
plot(SelectChM1to9plusP((1:123),10),SelectChM1to9plusP((1:123),11))
end