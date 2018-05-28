% M to 4HzPeakLabel3onlybar
function AmpOverMean1=M3to4HzPeakLabel3onlybar2(M1,M2,M3,V)
Limit=input('Input the Limit')
ChPlusData1=[M1;V];
ChPlusData2=[M2;V];
ChPlusData3=[M3;V];
AmpOverMean1((1:4),:)=V((1:4),:);
AmpOverMean2((1:4),:)=V((1:4),:);
AmpOverMean3((1:4),:)=V((1:4),:);
hold off;
for n=1:202
    if ChPlusData1(55,n)==max(ChPlusData1((42:69),n))
        if ChPlusData1(55,n)-mean(ChPlusData1((42:69),n))>Limit
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),(ChPlusData1(55,n)-mean(ChPlusData1((42:69),n))),'r'),hold on;
        else
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),0,'r'),hold on;
        end
        AmpOverMean1(5,n)=ChPlusData1(55,n)-mean(ChPlusData1((42:69),n));
    elseif ChPlusData1(56,n)==max(ChPlusData1((42:69),n))
        if ChPlusData1(56,n)-mean(ChPlusData1((42:69),n))>Limit
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),(ChPlusData1(56,n)-mean(ChPlusData1((42:69),n))),'r'),hold on;
        else
        stem3(ChPlusData1(412,n),ChPlusData1(413,n),0,'r'),hold on;    
        end
        AmpOverMean1(5,n)=ChPlusData1(56,n)-mean(ChPlusData1((42:69),n));
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
    if ChPlusData2(55,n)==max(ChPlusData2((42:69),n))
        if ChPlusData2(55,n)-mean(ChPlusData2((42:69),n))>Limit
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),(ChPlusData2(55,n)-mean(ChPlusData2((42:69),n))),'b'),hold on;
        else
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),0,'b'),hold on;
        end
        AmpOverMean2(5,n)=ChPlusData2(55,n)-mean(ChPlusData2((42:69),n));
    elseif ChPlusData2(56,n)==max(ChPlusData2((42:69),n))
        if ChPlusData2(56,n)-mean(ChPlusData2((42:69),n))>Limit
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),(ChPlusData2(56,n)-mean(ChPlusData2((42:69),n))),'b'),hold on;
        else
        stem3(ChPlusData2(412,n),ChPlusData2(413,n),0,'b'),hold on;    
        end
        AmpOverMean2(5,n)=ChPlusData2(56,n)-mean(ChPlusData2((42:69),n));
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
    if ChPlusData3(55,n)==max(ChPlusData3((42:69),n))
        stem3(ChPlusData3(412,n),ChPlusData3(413,n),(ChPlusData3(55,n)-mean(ChPlusData3((42:69),n))),'k'),hold on;
        AmpOverMean3(5,n)=ChPlusData3(55,n)-mean(ChPlusData3((42:69),n));
    elseif ChPlusData3(56,n)==max(ChPlusData3((42:69),n))
        stem3(ChPlusData3(412,n),ChPlusData3(413,n),(ChPlusData3(56,n)-mean(ChPlusData3((42:69),n))),'k'),hold on;
        AmpOverMean3(5,n)=ChPlusData3(56,n)-mean(ChPlusData3((42:69),n));
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