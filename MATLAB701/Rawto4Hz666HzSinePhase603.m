% Raw to 4Hz666HzSinePhase 603points
function M1data=Rawto4Hz666HzSinePhase603(X,M1,ch)
for m1=1:size(M1,2)
    M1data((1:4),m1)=M1((1:4),m1);
    M1data((5:607),m1)=X((1:603),(ch(1,:)==M1(1,m1)));
end;
FFT=fft(M1data((5:607),:));
FFT(1,:)=[];
RFFT=[FFT((1:(size(FFT,1)/2)),:)];
nyquist=1/2/(1/600);
FreqAxis=(1:size(RFFT,1)/2)/(size(FFT,1)/2)*nyquist;
T=[-0.5:(1/600):(-0.5+(602/600))];
T1=[-0.125:(1/600):(-0.125+(75/600))];
for n=1:size(M1,2)
    Y1(:,n)=(real(RFFT(4,n))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,n))*sin(2*pi*FreqAxis(4)*T))/500;
    y1(:,n)=(real(RFFT(4,n))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,n))*sin(2*pi*FreqAxis(4)*T1))/500;
    [Max1(1,n),MaxPhaseI1(1,n)]=max(y1(:,n));
    plot(T,Y1(:,n),'r-'),grid,hold on;
    axis([-0.500 0.500 -10 10]);
    set(gca,'xtick',[-0.375 -0.125 0 0.125 0.375]);
end;
end
