% M to 666HzAllChAmp
function ChMXY=Mto666HzAllChAmp(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(91,n)>=ChPlusData(92,n)
        ChMXY(4,n)=ChPlusData(91,n);
    else 
        ChMXY(4,n)=ChPlusData(92,n);
    end
end;
assignin('base','ChMXY',ChMXY);    
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(4,:))


