% M to 4HzPeakAmpAllBars
function ChMXY=Mto4HzPeakAmpAllBars(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2.33
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2.33 
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
    else  
        if ChPlusData(55,n)-mean(ChPlusData((42:69),n))>0
            ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
        elseif ChPlusData(55,n)-mean(ChPlusData((42:69),n))<=0
            ChMXY(4,n)=0;
        end
    end
assignin('base','ChMXY',ChMXY);    
end;
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(4,:))


