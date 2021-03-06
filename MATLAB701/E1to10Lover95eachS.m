% E1to10Lover95eachS
function H=E1to10Lover95eachS(S,M,N,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c)=S((15:137),c)/sum(S((15:137),c))*123;
    Mn((1:123),c)=M((15:137),c)/sum(M((15:137),c))*123;
    Nn((1:123),c)=N((15:137),c)/sum(N((15:137),c))*123;
end;
Sn((1:123),203)=S((15:137),203)/1000;
Mn((1:123),203)=M((15:137),203)/1000;
Nn((1:123),203)=N((15:137),203)/1000;
% significant 4HzBB-dominant frequency on left 40 channels
L=find(V(2,(1:202))==1);
for f=1:123
    I1=(Sn(f,L)>mean(Mn(f,L))+std(Mn(f,L))*1.64);
    I2=(Sn(f,L)>mean(Nn(f,L))+std(Nn(f,L))*1.64);
    J1=(Mn(f,L)>mean(Sn(f,L))+std(Sn(f,L))*1.64);
    J2=(Mn(f,L)>mean(Nn(f,L))+std(Nn(f,L))*1.64);
    H(f,1)=nnz(I1.*I2);
    H(f,2)=nnz(J1.*J2);
end;
assignin('base','H',H);
plot(S((15:137),203)/1000,H(:,1),'bo',S((15:137),203)/1000,H(:,2),'ro'),grid on
end
