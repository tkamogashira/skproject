% E1to10over95ChFigure
function OVER95=E1to10over95ChFigure(M4,n)
% M4:FFT; n:ColumnNumber 
LINE=(0:0.05:30);
BB4scale=(3.5:0.05:4.5);
MEAN=mean(M4((49:63),n),1);
OVER95=mean(M4((49:63),n),1)+std(M4((49:63),n),0,1)*1.64;
plot(M4(:,203)/1000,M4(:,n),'k',repmat(3.5,1,size(LINE,2)),LINE,'k',repmat(4.5,1,size(LINE,2)),LINE,'k',BB4scale,repmat(MEAN,1,size(BB4scale,2)),'b',BB4scale,repmat(OVER95,1,size(BB4scale,2)),'r'),grid on
end
