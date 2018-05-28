% M to 4HzPeakAmpBars2SDWidth2Hz
function ChMXY=Mto4HzPeakAmpBars2SDWidth2Hz(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2 
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
    else  ChMXY(4,n)=0;   
    end
assignin('base','ChMXY',ChMXY);    
end;
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(4,:))


