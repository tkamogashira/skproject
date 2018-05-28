% M to 4HzAmpOver3fT
function ChMXY=Mto4HzAmpOver3fT(M,V)
ChMean=mean(abs(M))
for n=1:203
    if ChMean(n)>3     
        plot(V(2,n),V(3,n),'ok'),hold on
        text(V(2,n),V(3,n),num2str(V(1,n)))
    else
        plot(V(2,n),V(3,n),'xk'),hold on
    end
assignin('base','ChMean',ChMean);    
end
    
