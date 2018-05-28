% M to 4HzLabel3fig
function Ch=Mto4HzLabel3fig(M,N,V,x)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
subplot(2,1,1)
semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'r'),hold on,axis([1 10 0 40]),grid on
subplot(2,1,2)
semilogx(ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
end

