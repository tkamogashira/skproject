% E1to10Lanova3eachSnon
function H=E1to10Lanova3eachSnon(S,M,N,V)
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
L=find(V(2,(1:202))==1);
for f=1:123
    X=[(Sn(f,L))' (Mn(f,L))' (Nn(f,L))'];
    [pf,t,sf]=anova2(X,1,'off');
    [cf,mf]=multcompare(sf,0.01,'off','bonferroni','column');
    if (pf(1,1)<0.01)&(mf(1,1)>mf(2,1))&(mf(1,1)>mf(3,1))&(cf(1,3)*cf(1,5)>0)&(cf(2,3)*cf(2,5)>0)
        H(f,1)=1;
    else
        H(f,1)=0;
    end;
    H(f,(2:4))=(mf(:,1))';
end;
assignin('base','H',H);
plot(S((15:137),203)/1000,H)
end
