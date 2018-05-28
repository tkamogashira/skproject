% M2 to ComparisonPlot
function N=M2toComparisonPlot(M1,M2,N)
plot(M1((42:69),203)/1000,M1((42:69),N),'b',M2((14:111),203)/1000,M2((14:111),N),'r:')
end