% E1to10Allttest0001
function frequency=E1to10Allttest0001(S,M,N,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c)=S((15:137),c)/sum(S((15:137),c))*123;
    Mn((1:123),c)=M((15:137),c)/sum(M((15:137),c))*123;
    Nn((1:123),c)=N((15:137),c)/sum(N((15:137),c))*123;
end;    
Sn((1:123),203)=S((15:137),203)/1000;
Mn((1:123),203)=M((15:137),203)/1000;
Nn((1:123),203)=N((15:137),203)/1000;
% significant 4HzBB-dominant frequency on all channels 
for f=1:123
    if (mean(Sn(f,(1:202)))>mean(Mn(f,(1:202))))&(mean(Sn(f,(1:202)))>mean(Nn(f,(1:202))))
        H4(f,1)=ttest(Sn(f,(1:202)),Mn(f,(1:202)),0.001)*ttest(Sn(f,(1:202)),Nn(f,(1:202)),0.001);
    else
        H4(f,1)=0;
    end;
end;
% significant 6.66HzBB-dominant frequency on all channels 
for f=1:123
    if (mean(Mn(f,(1:202)))>mean(Sn(f,(1:202))))&(mean(Mn(f,(1:202)))>mean(Nn(f,(1:202))))
        H6(f,1)=ttest(Mn(f,(1:202)),Sn(f,(1:202)),0.001)*ttest(Mn(f,(1:202)),Nn(f,(1:202)),0.001);
    else
        H6(f,1)=0;
    end;
end;
plot(ones(size(Sn(find(H4(:,1)==1),203)),1),Sn(find(H4(:,1)==1),203),'bo'),hold on;
plot(ones(size(Sn(find(H6(:,1)==1),203)),1),Sn(find(H6(:,1)==1),203),'ro'),hold on;
end