% M to 666HzPeakLabel3barDiff
function AmpOverMean1=M3to666HzPeakLabel3barDiff(M1,M2,V)
ChPlusData1=[M1;V];
ChPlusData2=[M2;V];
AmpOverMean1((1:4),:)=V((1:4),:);
AmpOverMean2((1:4),:)=V((1:4),:);
AmpDifference((1:4),:)=V((1:4),:);
hold off;
for n=1:202
    if ChPlusData1(91,n)==max(ChPlusData1((78:104),n))
        AmpOverMean1(5,n)=ChPlusData1(91,n)-mean(ChPlusData1((78:104),n));
    elseif ChPlusData1(92,n)==max(ChPlusData1((78:104),n))
        AmpOverMean1(5,n)=ChPlusData1(92,n)-mean(ChPlusData1((78:104),n));
    else
        AmpOverMean1(5,n)=0;
    end
end;
for n=1:202
    if ChPlusData2(91,n)==max(ChPlusData2((78:104),n))
        AmpOverMean2(5,n)=ChPlusData2(91,n)-mean(ChPlusData2((78:104),n));
    elseif ChPlusData2(92,n)==max(ChPlusData2((78:104),n))
        AmpOverMean2(5,n)=ChPlusData2(92,n)-mean(ChPlusData2((78:104),n));
    else
        AmpOverMean2(5,n)=0;
    end
end;
AmpDifference(5,:)=AmpOverMean1(5,:)-AmpOverMean2(5,:);
for n=1:202
    if AmpDifference(5,n)>0
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),AmpDifference(5,n),'b'),hold on;
    elseif AmpDifference(5,n)<0
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),AmpDifference(5,n),'r'),hold on;
    end;
for n=1:202
    if ChPlusData1(411,n)>0
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),0,'ko'),hold on;
    else
        plot(ChPlusData2(412,n),ChPlusData2(413,n),'k.'),hold on;
    end
end;
assignin('base','AmpOverMean1',(AmpOverMean1)');
assignin('base','AmpOverMean2',(AmpOverMean2)');
assignin('base','AmpDifference',(AmpDifference)');
end