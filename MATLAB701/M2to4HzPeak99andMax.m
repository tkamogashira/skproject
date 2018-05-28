% M2 to 4HzPeak99andMax
function AmpOverMean1=M2to4HzPeak99andMax(M1,M2,V)
ChPlusData1=[M1;V];
ChPlusData2=[M2;V];
AmpOverMean1((1:4),:)=V((1:4),:);
hold off;
for n=1:202
    if ((ChPlusData1(55,n)>mean(ChPlusData2((42:69),n))+std(ChPlusData2((42:69),n))*2.33))&...
            (ChPlusData1(55,n)==max(ChPlusData1((42:69),n)))
        AmpOverMean1(5,n)=ChPlusData1(55,n);
    elseif ((ChPlusData1(56,n)>mean(ChPlusData2((42:69),n))+std(ChPlusData2((42:69),n))*2.33))&...
            (ChPlusData1(56,n)==max(ChPlusData1((42:69),n)))
        AmpOverMean1(5,n)=ChPlusData1(56,n);
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