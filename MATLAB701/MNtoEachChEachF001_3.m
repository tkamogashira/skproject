% MNtoEachChEachF001_3
function SigChN=MNtoEachChEachF001_3(M,N,V,FA)
P((1:9),205)=(FA([1 11 21 31 41 51 61 71 81]))';
for C=1:204
    for g=2:9
        if mean(mean(M(C,((10*(g-1)-4):(10*(g-1)+5)),(1:30)),2))-mean(mean(N(C,((10*(g-1)-4):(10*(g-1)+5)),(1:30)),2))<0
            P(g,C)=1;P(1,C)=1;
        else
            [H,P(g,C),ci]=ttest2(mean(M(C,((10*(g-1)-4):(10*(g-1)+5)),(1:30)),2),mean(N(C,((10*(g-1)-4):(10*(g-1)+5)),(1:30)),2),0.01,0);
            P(1,C)=1;
        end;
    end;
end;
for Fp=1:9
    SigChN(Fp)=sum(P(Fp,(1:204))<0.01);
end;
PlotP=[[P;[V zeros(4,1)]] [SigChN 0 0 0 0]'];
assignin('base','PlotP',PlotP);
[i,j]=find(PlotP((1:9),(1:204))<0.01);
X=[i j];
for k=1:size(X,1)
    if PlotP(11,X(k,2))>0
        plot3(PlotP(12,X(k,2)),PlotP(12,X(k,2)),PlotP(X(k,1),205),'bo'),hold on;
    else
        plot3(PlotP(12,X(k,2)),PlotP(12,X(k,2)),PlotP(X(k,1),205),'b.'),hold on;
    end;
end;
plot3(PlotP(12,find(PlotP(11,(1:204))>0)),PlotP(13,find(PlotP(11,(1:204))>0)),ones(nnz(PlotP(11,(1:204))>0)),'ko'),hold on;
plot3(PlotP(12,find(PlotP(11,(1:204))==0)),PlotP(13,find(PlotP(11,(1:204))==0)),ones(nnz(PlotP(11,(1:204))==0)),'k.'),grid,hold on;          
end
