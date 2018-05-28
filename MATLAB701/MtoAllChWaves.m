% M to AllChWaves
function Scale=MtoAllChWaves(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    plot(ChPlusData(:,203)/1000,ChPlusData(:,n)),hold on,axis([1 10 0 40]),grid on
end;
Scale=V

