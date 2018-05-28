% E1to10over99N9
function H=E1to10over99N9(S1,S2,S3,S4,S5,S6,S7,S8,S9,M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c,1)=S1((15:137),c)/sum(S1((15:137),c))*123;
    Sn((1:123),c,2)=S2((15:137),c)/sum(S2((15:137),c))*123;
    Sn((1:123),c,3)=S3((15:137),c)/sum(S3((15:137),c))*123;
    Sn((1:123),c,4)=S4((15:137),c)/sum(S4((15:137),c))*123;
    Sn((1:123),c,5)=S5((15:137),c)/sum(S5((15:137),c))*123;
    Sn((1:123),c,6)=S6((15:137),c)/sum(S6((15:137),c))*123;
    Sn((1:123),c,7)=S7((15:137),c)/sum(S7((15:137),c))*123;
    Sn((1:123),c,8)=S8((15:137),c)/sum(S8((15:137),c))*123;
    Sn((1:123),c,9)=S9((15:137),c)/sum(S9((15:137),c))*123;
    Mn((1:123),c,1)=M1((15:137),c)/sum(M1((15:137),c))*123;
    Mn((1:123),c,2)=M2((15:137),c)/sum(M2((15:137),c))*123;
    Mn((1:123),c,3)=M3((15:137),c)/sum(M3((15:137),c))*123;
    Mn((1:123),c,4)=M4((15:137),c)/sum(M4((15:137),c))*123;
    Mn((1:123),c,5)=M5((15:137),c)/sum(M5((15:137),c))*123;
    Mn((1:123),c,6)=M6((15:137),c)/sum(M6((15:137),c))*123;
    Mn((1:123),c,7)=M7((15:137),c)/sum(M7((15:137),c))*123;
    Mn((1:123),c,8)=M8((15:137),c)/sum(M8((15:137),c))*123;
    Mn((1:123),c,9)=M9((15:137),c)/sum(M9((15:137),c))*123;
    Nn((1:123),c,1)=N1((15:137),c)/sum(N1((15:137),c))*123;
    Nn((1:123),c,2)=N2((15:137),c)/sum(N2((15:137),c))*123;
    Nn((1:123),c,3)=N3((15:137),c)/sum(N3((15:137),c))*123;
    Nn((1:123),c,4)=N4((15:137),c)/sum(N4((15:137),c))*123;
    Nn((1:123),c,5)=N5((15:137),c)/sum(N5((15:137),c))*123;
    Nn((1:123),c,6)=N6((15:137),c)/sum(N6((15:137),c))*123;
    Nn((1:123),c,7)=N7((15:137),c)/sum(N7((15:137),c))*123;
    Nn((1:123),c,8)=N8((15:137),c)/sum(N8((15:137),c))*123;
    Nn((1:123),c,9)=N9((15:137),c)/sum(N9((15:137),c))*123;
end;
for i=1:9
    Sn((1:123),203,i)=S1((15:137),203)/1000;
    Mn((1:123),203,i)=M1((15:137),203)/1000;
    Nn((1:123),203,i)=N1((15:137),203)/1000;
end;
% area selection
L=find(V(2,(1:202))>-1);
for f=1:123
    p1=(Sn(f,L,1)>mean(Mn(f,L,1))+std(Mn(f,L,1))*2.33);q1=(Sn(f,L,1)>mean(Nn(f,L,1))+std(Nn(f,L,1))*2.33);
    p2=(Sn(f,L,2)>mean(Mn(f,L,2))+std(Mn(f,L,2))*2.33);q2=(Sn(f,L,2)>mean(Nn(f,L,2))+std(Nn(f,L,2))*2.33);
    p3=(Sn(f,L,3)>mean(Mn(f,L,3))+std(Mn(f,L,3))*2.33);q3=(Sn(f,L,3)>mean(Nn(f,L,3))+std(Nn(f,L,3))*2.33);
    p4=(Sn(f,L,4)>mean(Mn(f,L,4))+std(Mn(f,L,4))*2.33);q4=(Sn(f,L,4)>mean(Nn(f,L,4))+std(Nn(f,L,4))*2.33);
    p5=(Sn(f,L,5)>mean(Mn(f,L,5))+std(Mn(f,L,5))*2.33);q5=(Sn(f,L,5)>mean(Nn(f,L,5))+std(Nn(f,L,5))*2.33);
    p6=(Sn(f,L,6)>mean(Mn(f,L,6))+std(Mn(f,L,6))*2.33);q6=(Sn(f,L,6)>mean(Nn(f,L,6))+std(Nn(f,L,6))*2.33);
    p7=(Sn(f,L,7)>mean(Mn(f,L,7))+std(Mn(f,L,7))*2.33);q7=(Sn(f,L,7)>mean(Nn(f,L,7))+std(Nn(f,L,7))*2.33);
    p8=(Sn(f,L,8)>mean(Mn(f,L,8))+std(Mn(f,L,8))*2.33);q8=(Sn(f,L,8)>mean(Nn(f,L,8))+std(Nn(f,L,8))*2.33);
    p9=(Sn(f,L,9)>mean(Mn(f,L,9))+std(Mn(f,L,9))*2.33);q9=(Sn(f,L,9)>mean(Nn(f,L,9))+std(Nn(f,L,9))*2.33);
    r1=(Mn(f,L,1)>mean(Sn(f,L,1))+std(Sn(f,L,1))*2.33);s1=(Mn(f,L,1)>mean(Nn(f,L,1))+std(Nn(f,L,1))*2.33);
    r2=(Mn(f,L,2)>mean(Sn(f,L,2))+std(Sn(f,L,2))*2.33);s2=(Mn(f,L,2)>mean(Nn(f,L,2))+std(Nn(f,L,2))*2.33);
    r3=(Mn(f,L,3)>mean(Sn(f,L,3))+std(Sn(f,L,3))*2.33);s3=(Mn(f,L,3)>mean(Nn(f,L,3))+std(Nn(f,L,3))*2.33);
    r4=(Mn(f,L,4)>mean(Sn(f,L,4))+std(Sn(f,L,4))*2.33);s4=(Mn(f,L,4)>mean(Nn(f,L,4))+std(Nn(f,L,4))*2.33);
    r5=(Mn(f,L,5)>mean(Sn(f,L,5))+std(Sn(f,L,5))*2.33);s5=(Mn(f,L,5)>mean(Nn(f,L,5))+std(Nn(f,L,5))*2.33);
    r6=(Mn(f,L,6)>mean(Sn(f,L,6))+std(Sn(f,L,6))*2.33);s6=(Mn(f,L,6)>mean(Nn(f,L,6))+std(Nn(f,L,6))*2.33);
    r7=(Mn(f,L,7)>mean(Sn(f,L,7))+std(Sn(f,L,7))*2.33);s7=(Mn(f,L,7)>mean(Nn(f,L,7))+std(Nn(f,L,7))*2.33);
    r8=(Mn(f,L,8)>mean(Sn(f,L,8))+std(Sn(f,L,8))*2.33);s8=(Mn(f,L,8)>mean(Nn(f,L,8))+std(Nn(f,L,8))*2.33);
    r9=(Mn(f,L,9)>mean(Sn(f,L,9))+std(Sn(f,L,9))*2.33);s9=(Mn(f,L,9)>mean(Nn(f,L,9))+std(Nn(f,L,9))*2.33);
    H(f,1)=mean([nnz(p1.*q1) nnz(p2.*q2) nnz(p3.*q3) nnz(p4.*q4) nnz(p5.*q5) nnz(p6.*q6) nnz(p7.*q7) nnz(p8.*q8) nnz(p9.*q9)]);
    H(f,2)=mean([nnz(r1.*s1) nnz(r2.*s2) nnz(r3.*s3) nnz(r4.*s4) nnz(r5.*s5) nnz(r6.*s6) nnz(r7.*s7) nnz(r8.*s8) nnz(r9.*s9)]);
end;
assignin('base','H',H);
plot(S1((15:137),203)/1000,H(:,1),'bo',S1((15:137),203)/1000,H(:,2),'ro'),grid on
end
