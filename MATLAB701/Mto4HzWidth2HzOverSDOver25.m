% M to 4HzWidth2HzOverSDOver25
function ChMXY=Mto4HzWidth2HzOverSDOver25(M1,V1,C,M2,V2)
ChPlusData=[M1;V1];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V1(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))
        ChMXY(4,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));      
        text(ChMXY(1,n),ChMXY(2,n),num2str(ChMXY(4,n)))
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n)) 
        ChMXY(4,n)=ChPlusData(56,n)-mean(ChPlusData((42:69),n));
        text(ChMXY(1,n),ChMXY(2,n),num2str(ChMXY(4,n)))
    else  ChMXY(4,n)=0;
    end
assignin('base','ChMXY',ChMXY);    
end;
hold on;
ChMean=mean(abs(M2))
for n=1:203
    if ChMean(n)>2.5     
        plot(V2(2,n),V2(3,n),'ok'),hold on
    else
        plot(V2(2,n),V2(3,n),'xk'),hold on
    end
assignin('base','ChMean',ChMean);    
end