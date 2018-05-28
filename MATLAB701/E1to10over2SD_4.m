% E1to10over2SD_4
function H=E1to10over2SD_4(k,S,M,N,V)
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
H((1:k),(1:2))=zeros(k,2);
H(((124-k):123),(1:2))=zeros(k,2);
for f=(k+1):(123-k)
    % search for 4HzBB amplitude that is larger than M+2SD within 1Hz on the channel 
    I1=(Sn(f,L)-mean(Sn(((f-k):(f+k)),L),1)-std(Sn(((f-k):(f+k)),L),0,1)*2>0);
    % search for 4HzBB amplitude that is larger than 6.66HzBB amplitude on the channel
    I2=(Mn(f,L)-mean(Mn(((f-k):(f+k)),L),1)-std(Mn(((f-k):(f+k)),L),0,1)*2<=0);
    % search for 4HzBB amplitude that is larger than NoBB amplitude on the channel
    I3=(Nn(f,L)-mean(Nn(((f-k):(f+k)),L),1)-std(Nn(((f-k):(f+k)),L),0,1)*2<=0);
    % search for 6.66HzBB amplitude that is larger than M+2SD within 1Hz on the channel
    J1=(Mn(f,L)-mean(Mn(((f-k):(f+k)),L),1)-std(Mn(((f-k):(f+k)),L),0,1)*2>0);
    % search for 6.66HzBB amplitude that is larger than 6.66HzBB amplitude on the channel
    J2=(Sn(f,L)-mean(Sn(((f-k):(f+k)),L),1)-std(Sn(((f-k):(f+k)),L),0,1)*2<=0);
    % search for 6.66HzBB amplitude that is larger than NoBB amplitude on the channel
    J3=(Nn(f,L)-mean(Nn(((f-k):(f+k)),L),1)-std(Nn(((f-k):(f+k)),L),0,1)*2<=0);
    % number of channels that was selected by mixed limitations for 4HzBB
    H(f,1)=nnz(I1.*I2.*I3);
    % number of channels that was selected by mixed limitations for 6.66HzBB
    H(f,2)=nnz(J1.*J2.*J3);
end;
assignin('base','zH',H);
plot(S((15:137),203)/1000,H(:,1),'b',S((15:137),203)/1000,H(:,2),'r'),grid on
end
