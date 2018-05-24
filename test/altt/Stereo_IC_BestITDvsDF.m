for n=1:length(BBICselectWithCF)
    plot(BBICselectWithCF(n).DomF,BBICselectWithCF(n).BestITD,'bo','MarkerSize',12);hold on;
end;
f=(250:1:2000);
plot(f,f.^(-1)*500,'k');hold on;
plot(f,f.^(-1)*(-500),'k');hold off;grid on