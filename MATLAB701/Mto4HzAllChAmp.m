% M to 4HzAllChAmp
function ChMXY=Mto4HzAllChAmp(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>=ChPlusData(56,n)
        ChMXY(4,n)=ChPlusData(55,n);
    else 
        ChMXY(4,n)=ChPlusData(56,n);
    end
end;
assignin('base','ChMXY',ChMXY);    
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(4,:))


