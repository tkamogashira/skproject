% M to 4HzLabel3fig2
function Ch=Mto4HzLabel3fig2(M,N,V,x)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'r',ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
end

