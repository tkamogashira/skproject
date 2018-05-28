% M to 4HzPeakAmpMinusMeanStd95
function ChM=Mto4HzPeakAmpMinusMeanStd95(M,V)
ChPlusData=[M;V];
ChM(1,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*1.64
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        ChM(2,n)=ChPlusData(55,n)-mean(ChPlusData((42:69),n));
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*1.64 
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        ChM(2,n)=ChPlusData(56,n)-mean(ChPlusData((42:69),n));
    else  ChM(2,n)=0;   
    end
assignin('base','ChM',ChM);    
end


