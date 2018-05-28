% MNtoEachChEachF001_2_15
function SigChN=MNtoEachChEachF001_2_15(M,N,V,FA)
P((1:90),205)=(FA)';
for C=1:204
    for f=1:90
        if mean(M(C,f,(1:15)))-mean(N(C,f,(1:15)))<0
            P(f,C)=1;
        else
            [H,P(f,C),ci]=ttest2(M(C,f,(1:15)),N(C,f,(1:15)),0.01,0);
        end;
    end;
end;
for Fp=1:90
    SigChN(Fp)=sum(P(Fp,(1:204))<0.01);
end;
PlotP=[[P;[V zeros(4,1)]] [SigChN 0 0 0 0]'];
assignin('base','PlotP',PlotP);
[i,j]=find(PlotP((1:90),(1:204))<0.01);
X=[i j];
for k=1:size(X,1)
    if PlotP(92,X(k,2))>0
        plot3(PlotP(93,X(k,2)),PlotP(94,X(k,2)),PlotP(X(k,1),205),'bo'),hold on;
    else
        plot3(PlotP(93,X(k,2)),PlotP(94,X(k,2)),PlotP(X(k,1),205),'b.'),hold on;
    end;
end;
plot3(PlotP(93,find(PlotP(92,(1:204))>0)),PlotP(94,find(PlotP(92,(1:204))>0)),ones(nnz(PlotP(92,(1:204))>0)),'ko'),hold on;
plot3(PlotP(93,find(PlotP(92,(1:204))==0)),PlotP(94,find(PlotP(92,(1:204))==0)),ones(nnz(PlotP(92,(1:204))==0)),'k.'),grid,hold on;          
end
