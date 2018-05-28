% M to 4HzPeakWidth2HzOverSDBarsN
function ChMXY=Mto4HzPeakWidth2HzOverSDBarsN(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
        stem3(ChMXY(1,n),ChMXY(2,n),ChMXY(4,n)),hold on
        text(ChMXY(1,n),ChMXY(2,n),ChMXY(4,n),num2str(ChMXY(3,n)))
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n)) 
        ChMXY(4,n)=ChPlusData(56,n)-mean(ChPlusData((42:69),n));
        stem3(ChMXY(1,n),ChMXY(2,n),ChMXY(4,n)),hold on
        text(ChMXY(1,n),ChMXY(2,n),ChMXY(4,n),num2str(ChMXY(3,n)))
    else  ChMXY(4,n)=0;
        stem3(ChMXY(1,n),ChMXY(2,n),ChMXY(4,n)),hold on
    end
assignin('base','ChMXY',ChMXY);    
end


