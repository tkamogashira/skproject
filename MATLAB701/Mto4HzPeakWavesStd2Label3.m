% M to 4HzPeakWavesStd2Label3
function Vector=Mto4HzPeakWavesStd2Label3(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2.33
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Vector(n)=ChPlusData(410,n);
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2.33 
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Vector(n)=ChPlusData(410,n);
    else  Vector(n)=0;   
    end
end

