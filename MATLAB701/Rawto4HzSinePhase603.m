% Raw to 4HzSinePhase 603points
function Mdata=Rawto4HzSinePhase603(X,M,ch)
[b,a] = ellip(10,3,100,40/300);
X2=filtfilt(b,a,X(:,(1:204)));
EachMean=mean(X2(:,(1:204)),1);
[p,q]=size(X2);
X3=X2(:,(1:204))-repmat(EachMean,p,1);
for m=1:size(M,2)
    Mdata((1:603),m)=X3((1:603),(ch(1,:)==M(1,m)));
end;
FFT=fft(Mdata((1:603),:));
FFT(1,:)=[];
RFFT=[FFT((1:(size(FFT,1)/2)),:)];
nyquist=1/2/(1/600);
FreqAxis=(1:size(RFFT,1)/2)/(size(FFT,1)/2)*nyquist;
T=[-0.5:(1/600):(-0.5+(602/600))];
T1=[-0.125:(1/600):(-0.125+(75/600))];
for n=1:size(M,2)
    Y(:,n)=(real(RFFT(4,n))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,n))*sin(2*pi*FreqAxis(4)*T))/500;
    y(:,n)=(real(RFFT(4,n))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,n))*sin(2*pi*FreqAxis(4)*T1))/500;
    [Max(1,n),MaxPhaseI(1,n)]=max(y(:,n));
    if M(2,n)==1
        plot(T,Mdata(:,n),'b-',T,Y(:,n),'b-'),grid,hold on;
    elseif M(2,n)==2
        plot(T,Mdata(:,n),'r-',T,Y(:,n),'r-'),grid,hold on;
    else
        plot(T,Mdata(:,n),'k-',T,Y(:,n),'k-'),grid,hold on;
    end;
    axis([-0.500 0.500 -10 10]);
    set(gca,'xtick',[-0.375 -0.125 0 0.125 0.375]);
end;
end
