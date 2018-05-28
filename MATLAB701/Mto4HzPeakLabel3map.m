% M to 4HzPeakLabel3map
function Ch=Mto4HzPeakLabel3map(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(55,n)==max(ChPlusData((42:69),n))
        text(ChPlusData(412,n),ChPlusData(413,n),num2str(ChPlusData(410,n))),hold on;
    elseif ChPlusData(56,n)==max(ChPlusData((42:69),n)) 
        text(ChPlusData(412,n),ChPlusData(413,n),num2str(ChPlusData(410,n))),hold on;
    end
end;
for n=1:202
    if ChPlusData(411,n)>0
        plot(ChPlusData(412,n),ChPlusData(413,n),'ko'),hold on;
    else
        plot(ChPlusData(412,n),ChPlusData(413,n),'k.'),hold on;    
    end
end;
end


