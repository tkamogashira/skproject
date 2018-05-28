function argout = histStd(xData, yData)

argout = sqrt(sum(yData.*((xData - histMean(xData, yData)).^2))/sum(yData));