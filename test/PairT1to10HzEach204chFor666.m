% V to PairT1to10HzEach204chFor666
function P=PairT1to10HzEach204chFor666(M,N,V)
MD=M';
ND=N';
for n=1:30
    FFTM=fft(MD(((6000*n+1):(6000*(n+1))),:));
    RFFTM=[FFTM(2:(length(FFTM)/2))];
    AmpM=abs(RFFTM/(length(FFTM)/2));
    AmpM1to10((n:(n+89)),:)=AmpM((10:99),:)./(repmat(mean(AmpM((10:99),:)),90,1));
    FreqAxis=(1:length(RFFTM))/(length(FFTM)/2)*(600.615/2);
    FreqAxis1to10=FreqAxis((10:99),1);
    FFTN=fft(ND(((6000*n+1):(6000*(n+1))),:));
    RFFTN=[FFTN(2:(length(FFTN)/2))];
    AmpN=abs(RFFTN/(length(FFTN)/2));
    AmpN1to10((n:(n+89)),:)=AmpN((10:99),:)./(repmat(mean(AmpN((10:99),:)),90,1));
end;
AmpD1to10=AmpM1to10-AmpN1to10;
for c=1:204
    for f=1:90
        if mean(AmpD1to10((f:90:(f+90*29)),c))<0
            P(f,c)=1;
        else
            [H,P(f,c),ci]=ttest(AmpD1to10((f:90:(f+90*29)),c),0,0.01,0);
        end;
    end;
end;
PlotP=[[P;V] [FreqAxis1to10;0;0;0]];
assignin('base','PlotP',PlotP);
[i,j]=find(PlotP((1:90),(1:204))<0.01);
plot3(PlotP(126,j),PlotP(127,j),PlotP(i,203),'b.'),hold on;
plot3(PlotP(92,(1:204)),PlotP(93,(1:204)),ones(1,204),'k.'),hold on;
end
