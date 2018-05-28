% M to 4HzPeakWidth1HzOver2SDBarsC
function ChMXY=Mto4HzPeakWidth1HzOver2SDBarsC(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((49:62),n))+std(ChPlusData((49:62),n))*2
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((49:62),n));      
        plot(ChMXY(1,n),ChMXY(2,n),'or'),hold on
        text(ChMXY(1,n),ChMXY(2,n),num2str(ChMXY(3,n)))
    elseif ChPlusData(56,n)>mean(ChPlusData((49:62),n))+std(ChPlusData((49:62),n))*2 
        ChMXY(4,n)=ChPlusData(56,n)-mean(ChPlusData((49:62),n));
        plot(ChMXY(1,n),ChMXY(2,n),'or'),hold on
        text(ChMXY(1,n),ChMXY(2,n),num2str(ChMXY(3,n)))
    else  ChMXY(4,n)=0;
        plot(ChMXY(1,n),ChMXY(2,n),'ob'),hold on
    end
assignin('base','ChMXY',ChMXY);    
end
