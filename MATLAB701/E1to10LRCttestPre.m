% E1to10LRCttestPre
function frequency=E1to10LRCttestPre(S,M,N,V)
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
for f=1:123
    if (mean(Sn(f,find(V(2,(1:202))==1)))>mean(Mn(f,find(V(2,(1:202))==1))))&(mean(Sn(f,find(V(2,(1:202))==1)))>mean(Nn(f,find(V(2,(1:202))==1))))
        H4L(f,1)=ttest(Sn(f,find(V(2,(1:202))==1)),Mn(f,find(V(2,(1:202))==1)),0.01)*ttest(Sn(f,find(V(2,(1:202))==1)),Nn(f,find(V(2,(1:202))==1)),0.01);
    else
        H4L(f,1)=0;
    end;
end;
plot(ones(size(Sn(find(H4L(:,1)==1),203)),1),Sn(find(H4L(:,1)==1),203),'bo')
end
