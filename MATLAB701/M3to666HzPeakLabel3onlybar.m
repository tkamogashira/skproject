% M to 666HzPeakLabel3onlybar
function AmpOverMean1=M3to666HzPeakLabel3onlybar(M1,M2,M3,V)
ChPlusData1=[M1;V];
ChPlusData2=[M2;V];
ChPlusData3=[M3;V];
AmpOverMean1((1:4),:)=V((1:4),:);
AmpOverMean2((1:4),:)=V((1:4),:);
AmpOverMean3((1:4),:)=V((1:4),:);
hold off;
for n=1:202
    if ChPlusData1(91,n)==max(ChPlusData1((78:104),n))
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),(ChPlusData1(91,n)-mean(ChPlusData1((78:104),n))),'r'),hold on;
        AmpOverMean1(5,n)=ChPlusData1(91,n)-mean(ChPlusData1((78:104),n));
    elseif ChPlusData1(92,n)==max(ChPlusData1((78:104),n))
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),(ChPlusData1(92,n)-mean(ChPlusData1((78:104),n))),'r'),hold on;
        AmpOverMean1(5,n)=ChPlusData1(92,n)-mean(ChPlusData1((78:104),n));
    else
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),0,'k'),hold on;
        AmpOverMean1(5,n)=0;
    end
end;
for n=1:202
    if ChPlusData1(411,n)>0
        plot(ChPlusData1(412,n),ChPlusData1(413,n),'ko'),hold on;
    else
        plot(ChPlusData1(412,n),ChPlusData1(413,n),'k.'),hold on;    
    end
end;
for n=1:202
    if ChPlusData2(91,n)==max(ChPlusData2((78:104),n))
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),(ChPlusData2(91,n)-mean(ChPlusData2((78:104),n))),'b'),hold on;
        AmpOverMean2(5,n)=ChPlusData2(91,n)-mean(ChPlusData2((78:104),n));
    elseif ChPlusData2(92,n)==max(ChPlusData2((78:104),n))
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),(ChPlusData2(92,n)-mean(ChPlusData2((78:104),n))),'b'),hold on;
        AmpOverMean2(5,n)=ChPlusData2(92,n)-mean(ChPlusData2((78:104),n));
    else
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),0,'k'),hold on;
        AmpOverMean2(5,n)=0;
    end
end;
for n=1:202
    if ChPlusData2(411,n)>0
        plot(ChPlusData2(412,n),ChPlusData2(413,n),'ko'),hold on;
    else
        plot(ChPlusData2(412,n),ChPlusData2(413,n),'k.'),hold on;    
    end
end;
for n=1:202
    if ChPlusData3(91,n)==max(ChPlusData3((78:104),n))
        stem3(ChPlusData3(412,n),ChPlusData3(413,n),(ChPlusData3(91,n)-mean(ChPlusData3((78:104),n))),'k'),hold on;
        AmpOverMean3(5,n)=ChPlusData3(91,n)-mean(ChPlusData3((78:104),n));
    elseif ChPlusData3(92,n)==max(ChPlusData3((78:104),n))
        stem3(ChPlusData3(412,n),ChPlusData3(413,n),(ChPlusData3(92,n)-mean(ChPlusData3((78:104),n))),'k'),hold on;
        AmpOverMean3(5,n)=ChPlusData3(92,n)-mean(ChPlusData3((78:104),n));
    else
        stem3(ChPlusData3(412,n),ChPlusData3(413,n),0,'k'),hold on;
        AmpOverMean3(5,n)=0;
    end
end;
for n=1:202
    if ChPlusData3(411,n)>0
        plot(ChPlusData3(412,n),ChPlusData3(413,n),'ko'),hold on;
    else
        plot(ChPlusData3(412,n),ChPlusData3(413,n),'k.'),hold on;    
    end
end;
assignin('base','AmpOverMean1',(AmpOverMean1)');
assignin('base','AmpOverMean2',(AmpOverMean2)');
assignin('base','AmpOverMean3',(AmpOverMean3)');
end