% E1to10Lover99eachS_3
function H=E1to10Lover99eachS_3(S,M,N,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c)=S((15:137),c)/sum(S((15:137),c))*123;
    Mn((1:123),c)=M((15:137),c)/sum(M((15:137),c))*123;
    Nn((1:123),c)=N((15:137),c)/sum(N((15:137),c))*123;
end;
Sn((1:123),203)=S((15:137),203)/1000;
Mn((1:123),203)=M((15:137),203)/1000;
Nn((1:123),203)=N((15:137),203)/1000;
% selection of area
L=find(V(2,(1:202))<3);
H((1:7),(1:2))=zeros(7,2);
H((117:123),(1:2))=zeros(7,2);
for f=8:116
    % search for 4HzBB amplitude that is larger than M+2SD within 1Hz on the channel 
    I1=(Sn(f,L)-mean(Sn(((f-7):(f+7)),L),1)-std(Sn(((f-7):(f+7)),L),0,1)*2>0);
    % search for 4HzBB amplitude that is larger than 6.66HzBB amplitude on the channel
    I2=((Sn(f,L)-Mn(f,L))>0);
    % search for 4HzBB amplitude that is larger than NoBB amplitude on the channel
    I3=((Sn(f,L)-Nn(f,L))>0);
    % search for 6.66HzBB amplitude that is larger than M+2SD within 1Hz on the channel
    J1=(Mn(f,L)-mean(Mn(((f-7):(f+7)),L),1)-std(Mn(((f-7):(f+7)),L),0,1)*2>0);
    % search for 6.66HzBB amplitude that is larger than 6.66HzBB amplitude on the channel
    J2=((Mn(f,L)-Sn(f,L))>0);
    % search for 6.66HzBB amplitude that is larger than NoBB amplitude on the channel
    J3=((Mn(f,L)-Nn(f,L))>0);
    % number of channels that was selected by mixed limitations for 4HzBB
    H(f,1)=nnz(I1.*I2.*I3);
    % number of channels that was selected by mixed limitations for 6.66HzBB
    H(f,2)=nnz(J1.*J2.*J3);
end;
assignin('base','H',H);
plot(S((15:137),203)/1000,H(:,1),'bo',S((15:137),203)/1000,H(:,2),'ro'),grid on
end
