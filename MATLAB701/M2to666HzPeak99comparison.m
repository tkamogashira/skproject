% M to 666HzPeak99comparison
function AmpOverMean1=M2to666HzPeak99comparison(M1,M2,V)
ChPlusData1=[M1;V];
ChPlusData2=[M2;V];
AmpOverMean1((1:4),:)=V((1:4),:);
hold off;
for n=1:202
    if ChPlusData1(91,n)>mean(ChPlusData2((78:104),n))+std(ChPlusData2((78:104),n))*2.33
        AmpOverMean1(5,n)=ChPlusData1(91,n);
    elseif ChPlusData1(92,n)>mean(ChPlusData2((78:104),n))+std(ChPlusData2((78:104),n))*2.33
        AmpOverMean1(5,n)=ChPlusData1(92,n);
    else
        AmpOverMean1(5,n)=0;
    end
end;
for n=1:202
    if AmpOverMean1(5,n)>0
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),AmpOverMean1(5,n),'b'),hold on;
end;
for n=1:202
    if ChPlusData1(411,n)>0
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),0,'ko'),hold on;
    else
        plot(ChPlusData1(412,n),ChPlusData1(413,n),'k.'),hold on;
    end
end;
assignin('base','AmpOverMean1',(AmpOverMean1)');
end