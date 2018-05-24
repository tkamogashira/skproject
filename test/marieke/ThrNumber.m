NN=0;
for n=1:length(BBICselectWithCF)
    if BBICselectWithCF(n).ThrCF>0
        NN=NN+1;
        disp(NN)
    end;
end;
    