% M to 4HzAmpOver25fT
function ChMXY=Mto4HzAmpOver25fT(M,V)
ChMean=mean(abs(M))
for n=1:203
    if ChMean(n)>2.5     
        plot(V(2,n),V(3,n),'ok'),hold on
        text(V(2,n),V(3,n),num2str(V(1,n)))
    else
        plot(V(2,n),V(3,n),'xk'),hold on
    end
assignin('base','ChMean',ChMean);    
end
    
