SIZE=size(BBICselectWithCF);

for h=1:SIZE(2)
    plot(BBICselectWithCF(h).sigpX,BBICselectWithCF(h).sigpYr);hold on
    plot(BBICselectWithCF(h).lineX,BBICselectWithCF(h).lineYr,'k--');
end
