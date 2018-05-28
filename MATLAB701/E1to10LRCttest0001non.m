% E1to10LRCttest0001non
function frequency=E1to10LRCttest0001non(S,M,N,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c)=S((15:137),c);
    Mn((1:123),c)=M((15:137),c);
    Nn((1:123),c)=N((15:137),c);
end;    
Sn((1:123),203)=S((15:137),203)/1000;
Mn((1:123),203)=M((15:137),203)/1000;
Nn((1:123),203)=N((15:137),203)/1000;
% significant 4HzBB-dominant frequency on left 40 channels 
for f=1:123
    if (mean(Sn(f,find(V(2,(1:202))==1)))>mean(Mn(f,find(V(2,(1:202))==1))))&(mean(Sn(f,find(V(2,(1:202))==1)))>mean(Nn(f,find(V(2,(1:202))==1))))
        H4L(f,1)=ttest(Sn(f,find(V(2,(1:202))==1)),Mn(f,find(V(2,(1:202))==1)),0.001)*ttest(Sn(f,find(V(2,(1:202))==1)),Nn(f,find(V(2,(1:202))==1)),0.001);
    else
        H4L(f,1)=0;
    end;
end;
% significant 4HzBB-dominant frequency on right 40 channels
for f=1:123
    if (mean(Sn(f,find(V(2,(1:202))==2)))>mean(Mn(f,find(V(2,(1:202))==2))))&(mean(Sn(f,find(V(2,(1:202))==2)))>mean(Nn(f,find(V(2,(1:202))==2))))
        H4R(f,1)=ttest(Sn(f,find(V(2,(1:202))==2)),Mn(f,find(V(2,(1:202))==2)),0.001)*ttest(Sn(f,find(V(2,(1:202))==2)),Nn(f,find(V(2,(1:202))==2)),0.001);
    else
        H4R(f,1)=0;
    end;
end;
% significant 4HzBB-dominant frequency on central 40 channels
for f=1:123
    if (mean(Sn(f,find(V(2,(1:202))==0)))>mean(Mn(f,find(V(2,(1:202))==0))))&(mean(Sn(f,find(V(2,(1:202))==0)))>mean(Nn(f,find(V(2,(1:202))==0))))
        H4C(f,1)=ttest(Sn(f,find(V(2,(1:202))==0)),Mn(f,find(V(2,(1:202))==0)),0.001)*ttest(Sn(f,find(V(2,(1:202))==0)),Nn(f,find(V(2,(1:202))==0)),0.001);
    else
        H4C(f,1)=0;
    end;
end;
% significant 6.66HzBB-dominant frequency on left 40 channels 
for f=1:123
    if (mean(Mn(f,find(V(2,(1:202))==1)))>mean(Sn(f,find(V(2,(1:202))==1))))&(mean(Mn(f,find(V(2,(1:202))==1)))>mean(Nn(f,find(V(2,(1:202))==1))))
        H6L(f,1)=ttest(Mn(f,find(V(2,(1:202))==1)),Sn(f,find(V(2,(1:202))==1)),0.001)*ttest(Mn(f,find(V(2,(1:202))==1)),Nn(f,find(V(2,(1:202))==1)),0.001);
    else
        H6L(f,1)=0;
    end;
end;
% significant 6.66HzBB-dominant frequency on right 40 channels
for f=1:123
    if (mean(Mn(f,find(V(2,(1:202))==2)))>mean(Sn(f,find(V(2,(1:202))==2))))&(mean(Mn(f,find(V(2,(1:202))==2)))>mean(Nn(f,find(V(2,(1:202))==2))))
        H6R(f,1)=ttest(Mn(f,find(V(2,(1:202))==2)),Sn(f,find(V(2,(1:202))==2)),0.001)*ttest(Mn(f,find(V(2,(1:202))==2)),Nn(f,find(V(2,(1:202))==2)),0.001);
    else
        H6R(f,1)=0;
    end;
end;
% significant 6.66HzBB-dominant frequency on central 40 channels
for f=1:123
    if (mean(Mn(f,find(V(2,(1:202))==0)))>mean(Sn(f,find(V(2,(1:202))==0))))&(mean(Mn(f,find(V(2,(1:202))==0)))>mean(Nn(f,find(V(2,(1:202))==0))))
        H6C(f,1)=ttest(Mn(f,find(V(2,(1:202))==0)),Sn(f,find(V(2,(1:202))==0)),0.001)*ttest(Mn(f,find(V(2,(1:202))==0)),Nn(f,find(V(2,(1:202))==0)),0.001);
    else
        H6C(f,1)=0;
    end;
end;
plot(ones(size(Sn(find(H4L(:,1)==1),203)),1),Sn(find(H4L(:,1)==1),203),'bo'),hold on;
plot(ones(size(Sn(find(H4R(:,1)==1),203)),1)*3,Sn(find(H4R(:,1)==1),203),'bo'),hold on;
plot(ones(size(Sn(find(H4C(:,1)==1),203)),1)*2,Sn(find(H4C(:,1)==1),203),'bo'),hold on;
plot(ones(size(Sn(find(H6L(:,1)==1),203)),1),Sn(find(H6L(:,1)==1),203),'ro'),hold on;
plot(ones(size(Sn(find(H6R(:,1)==1),203)),1)*3,Sn(find(H6R(:,1)==1),203),'ro'),hold on;
plot(ones(size(Sn(find(H6C(:,1)==1),203)),1)*2,Sn(find(H6C(:,1)==1),203),'ro'),hold on;axis([0 4 1 10]),grid on
end