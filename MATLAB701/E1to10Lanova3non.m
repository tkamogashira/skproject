% E1to10Lanova3non
function H=E1to10Lanova3non(S1,S2,S3,S4,S5,S6,S7,S8,S9,M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c,1)=S1((15:137),c);
    Sn((1:123),c,2)=S2((15:137),c);
    Sn((1:123),c,3)=S3((15:137),c);
    Sn((1:123),c,4)=S4((15:137),c);
    Sn((1:123),c,5)=S5((15:137),c);
    Sn((1:123),c,6)=S6((15:137),c);
    Sn((1:123),c,7)=S7((15:137),c);
    Sn((1:123),c,8)=S8((15:137),c);
    Sn((1:123),c,9)=S9((15:137),c);
    Mn((1:123),c,1)=M1((15:137),c);
    Mn((1:123),c,2)=M2((15:137),c);
    Mn((1:123),c,3)=M3((15:137),c);
    Mn((1:123),c,4)=M4((15:137),c);
    Mn((1:123),c,5)=M5((15:137),c);
    Mn((1:123),c,6)=M6((15:137),c);
    Mn((1:123),c,7)=M7((15:137),c);
    Mn((1:123),c,8)=M8((15:137),c);
    Mn((1:123),c,9)=M9((15:137),c);
    Nn((1:123),c,1)=N1((15:137),c);
    Nn((1:123),c,2)=N2((15:137),c);
    Nn((1:123),c,3)=N3((15:137),c);
    Nn((1:123),c,4)=N4((15:137),c);
    Nn((1:123),c,5)=N5((15:137),c);
    Nn((1:123),c,6)=N6((15:137),c);
    Nn((1:123),c,7)=N7((15:137),c);
    Nn((1:123),c,8)=N8((15:137),c);
    Nn((1:123),c,9)=N9((15:137),c);
end;
for i=1:9
    Sn((1:123),203,i)=S1((15:137),203)/1000;
    Mn((1:123),203,i)=M1((15:137),203)/1000;
    Nn((1:123),203,i)=N1((15:137),203)/1000;
end;
% significant 4HzBB-dominant frequency on left 40 channels
L=find(V(2,(1:202))==1);
for f=1:123
    X=[Sn(f,L,1);Mn(f,L,1);Nn(f,L,1);Sn(f,L,2);Mn(f,L,2);Nn(f,L,2);Sn(f,L,3);Mn(f,L,3);Nn(f,L,3);Sn(f,L,4);Mn(f,L,4);Nn(f,L,4);Sn(f,L,5);Mn(f,L,5);Nn(f,L,5);Sn(f,L,6);Mn(f,L,6);Nn(f,L,6);Sn(f,L,7);Mn(f,L,7);Nn(f,L,7);Sn(f,L,8);Mn(f,L,8);Nn(f,L,8);Sn(f,L,9);Mn(f,L,9);Nn(f,L,9)];
    % preparing f-dependent datasheet for 3-way RM ANOVA
    % 1st column:(4Hz*40 6Hz*40 No*40)*9
    sheet((1:(size(L,2)*27)),1)=repmat([ones(size(L,2),1);(ones(size(L,2),1)*2);(ones(size(L,2),1)*3)],9,1);
    % 2nd column:(subject1*40)*3 ... (subject9*40)*3
    sheet((1:(size(L,2)*27)),2)=[ones((size(L,2)*3),1);(ones((size(L,2)*3),1)*2);(ones((size(L,2)*3),1)*3);(ones((size(L,2)*3),1)*4);(ones((size(L,2)*3),1)*5);(ones((size(L,2)*3),1)*6);(ones((size(L,2)*3),1)*7);(ones((size(L,2)*3),1)*8);(ones((size(L,2)*3),1)*9)];
    % 3rd column:(channel 1...40)*3*9
    sheet((1:(size(L,2)*27)),3)=repmat(((1:1:size(L,2))'),27,1);
    % 4th column:data
    sheet((1:(size(L,2)*27)),4)=reshape(X',[],1);
    % sheet(:,1):BBconditions, sheet(:,2):subjects, sheet(:,3):channels
    [pf,t,sf]=anovan(sheet(:,4),{sheet(:,1) sheet(:,2) sheet(:,3)},'alpha',0.01,'display','off','model',[1 0 0;0 1 0;0 0 1;1 1 0;1 0 1;0 1 1]);
    [cf,mf]=multcompare(sf,0.01,'off','bonferroni','anovan',1);
    if (pf(1,1)<0.01)&(mf(1,1)>mf(2,1))&(mf(1,1)>mf(3,1))&((cf(1,3)*cf(1,5))>0)&((cf(2,3)*cf(2,5))>0)
        H(f,1)=1;
    else
        H(f,1)=0;
    end;
    H(f,(2:7))=(pf)'
end;
assignin('base','H',H);
end
