S1=structfilter(CFcombiselect,'$BestITD$ >-0.01 & $BestITD$ <0.01');
S2=structfilter(CFcombiselect,'$BestITD$ >0.04 & $BestITD$ <0.06');
S3=structfilter(CFcombiselect,'$BestITD$ >0.09 & $BestITD$ <0.11');
S4=structfilter(CFcombiselect,'$BestITD$ >0.14 & $BestITD$ <0.16');
structplot(S1,'CPr','CD',S2,'CPr','CD',S3,'CPr','CD',S4,'CPr','CD')
