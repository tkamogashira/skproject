% M2 to ComparisonPlot666
function N=M2toComparisonPlot666(M1,M2,N)
plot(M1((78:104),203)/1000,M1((78:104),N),'b',M2((14:111),203)/1000,M2((14:111),N),'r:')
end