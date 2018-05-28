% M to 4HzPeakWavesLabel2
function Ch=Mto4HzPeakWavesLabel2(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(56,n)==max(ChPlusData((42:69),n))
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    end
end

