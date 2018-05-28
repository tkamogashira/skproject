% M to 666HzPeakWavesStd4Label3
function ChM=Mto666HzPeakWavesStd4Label3(M,V)
ChPlusData=[M;V];
ChM(1,:)=V(1:202);
hold off;
for n=1:202
    if ChPlusData(91,n)>mean(ChPlusData((78:104),n))+std(ChPlusData((78:104),n))*2.33
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        ChM(2,n)=1;
    elseif ChPlusData(92,n)>mean(ChPlusData((78:104),n))+std(ChPlusData((78:104),n))*2.33 
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        ChM(2,n)=1;
    else  ChM(2,n)=0;   
    end
assignin('base','ChM',ChM);    
end


