% M to 666HzAllMeanWidth2Hz
function ChMXY=Mto666HzAllMeanWidth2Hz(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
        ChMXY(4,n)=mean(ChPlusData((79:105),n));
end;
assignin('base','ChMXY',ChMXY);    
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(4,:))


