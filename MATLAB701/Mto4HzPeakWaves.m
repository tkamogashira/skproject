% M to 4HzPeakWaves
function FrScale=Mto4HzPeakWaves(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(56,n)==max(ChPlusData((42:69),n))
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
    end
end;
FrScale=ChPlusData(:,203)/1000

