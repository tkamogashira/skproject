% E1to10over95ChFigure666
function OVER95=E1to10over95ChFigure666(M6,n)
% M6:FFT; n:ColumnNumber 
LINE=(0:0.05:30);
BB6scale=(6.166:0.05:7.166);
MEAN=mean(M6((86:98),n),1);
OVER95=mean(M6((86:98),n),1)+std(M6((86:98),n),0,1)*1.64;
plot(M6(:,203)/1000,M6(:,n),'k',repmat(6.166,1,size(LINE,2)),LINE,'k',repmat(6.666,1,size(LINE,2)),LINE,'k',repmat(7.166,1,size(LINE,2)),LINE,'k',BB6scale,repmat(MEAN,1,size(BB6scale,2)),'b',BB6scale,repmat(OVER95,1,size(BB6scale,2)),'r'),grid on
end
