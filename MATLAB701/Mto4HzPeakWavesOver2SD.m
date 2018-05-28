% M to 4HzPeakWavesHighLabel3
function Ch=Mto4HzPeakWavesHighLabel3(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(55,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r',ChPlusData(55,203)/1000,mean(ChPlusData((42:69),n)),'bx'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    elseif ChPlusData(56,n)>mean(ChPlusData((42:69),n))+std(ChPlusData((42:69),n))*2 
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r',ChPlusData(55,203)/1000,mean(ChPlusData((42:69),n)),'bx'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    end
end

