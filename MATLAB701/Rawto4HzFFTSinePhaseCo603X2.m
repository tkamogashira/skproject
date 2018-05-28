% Raw to 4HzFFTSinePhaseCo 603pointsX2
function RESULTS=Rawto4HzFFTSinePhaseCo603X2(X,M,ch)
% 40Hz low-pass filter
[b,a] = ellip(10,3,100,40/300);
X2=filtfilt(b,a,X(:,(1:204)));
% baseline through 1000ms
EachMean=mean(X2(:,(1:204)),1);
[p,q]=size(X2);
X3=X2(:,(1:204))-repmat(EachMean,p,1);
% Selecting raw data in selected channels
for m=1:size(M,2)
    Mdata((1:603),m)=X3((1:603),(ch(1,:)==M(1,m)));
end;
% FFT in each column
FFT=fft(Mdata((1:603),:));
A0=FFT(1,:);
FFT(1,:)=[];
RFFT=FFT((1:(size(FFT,1)/2)),:);
AA=size(FFT,1)/2;
Amp=abs(RFFT/(size(FFT,1)/2));
nyquist=1/2/(1/600);
FreqAxis=(1:size(RFFT,1))/(size(FFT,1)/2)*nyquist;
% DFT graph L/C/R
subplot(4,1,1);
for a=1:size(M,2)
    if M(2,a)==1
        semilogx(FreqAxis,Amp(:,a),'b-'),grid,hold on;
    elseif M(2,a)==2
        semilogx(FreqAxis,Amp(:,a),'r-'),grid,hold on;
    else
        semilogx(FreqAxis,Amp(:,a),'k-'),grid,hold on;
    end;
    axis([1 20 0 6]);
    DFT4(1,a)=Amp(4,a);
end;
grid;
% 4Hz sine waves L/C/R
T=[-0.5:(1/600):(-0.5+(602/600))];
subplot(4,1,2);
for b=1:size(M,2)
    Y(:,b)=(A0(1,b)+real(RFFT(4,b))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,b))*sin(2*pi*FreqAxis(4)*T))/(603/2);
    if M(2,b)==1
        plot(T,Y(:,b),'b-',T,Mdata(:,b),'b-'),grid,hold on;
    elseif M(2,b)==2
        plot(T,Y(:,b),'r-',T,Mdata(:,b),'r-'),grid,hold on;
    else
        plot(T,Y(:,b),'k-',T,Mdata(:,b),'k-'),grid,hold on;
    end;
    axis([-0.500 0.500 -10 10]);set(gca,'xtick',[-0.375 -0.125 0 0.125 0.375]);
end;
grid;
% Phase analysis by radian
T1=[-0.125:(1/600):(-0.125+(150/600))];
for c=1:size(M,2)
    y(:,c)=(A0(1,c)+real(RFFT(4,c))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,c))*sin(2*pi*FreqAxis(4)*T1))/(603/2);
    [Max(1,c),MaxPhaseIndex(1,c)]=max(y(:,c));
    MaxPhase(1,c)=((T1(MaxPhaseIndex(1,c)))/0.125)*pi;
    SineAmp(1,c)=Max(1,c);
    if MaxPhase(1,c)-(pi/2)<-pi
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2)+(2*pi);
    else
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2);
    end;
end;
% Circular graph L/C/R
subplot(4,1,3);
z=[-pi:0.001:pi];
for d=1:size(M,2)
    if M(2,d)==1
        plot(SineAmp(1,d)*cos(ZeroPhase(1,d)),SineAmp(1,d)*sin(ZeroPhase(1,d)),'b.'),hold on;
    elseif M(2,d)==2
        plot(SineAmp(1,d)*cos(ZeroPhase(1,d)),SineAmp(1,d)*sin(ZeroPhase(1,d)),'r.'),hold on;
    else
        plot(SineAmp(1,d)*cos(ZeroPhase(1,d)),SineAmp(1,d)*sin(ZeroPhase(1,d)),'k.'),hold on;
    end;
    plot(10*cos(z),10*sin(z),'k-'),grid,hold on;
    axis([-10 10 -10 10]);set(gca,'xtick',[-10 0 10]);set(gca,'ytick',[-10 0 10]);axis square;
end;
grid;
% Coherence
for e=1:size(M,2)
    [Co,F]=mscohere(Mdata(:,e),Y(:,e),[],[],602,600);
    Co4(1,e)=Co(5);
end;
% ZeroPhase vs Coherence graph L/C/R
subplot(4,1,4);
for f=1:size(M,2)
    if M(2,f)==1
        plot(ZeroPhase(1,f),Co4(1,f),'bx'),grid,hold on;
    elseif M(2,f)==2
        plot(ZeroPhase(1,f),Co4(1,f),'rx'),grid,hold on;
    else
        plot(ZeroPhase(1,f),Co4(1,f),'kx'),grid,hold on;
    end;
    axis([-pi pi 0 1]);set(gca,'xtick',[-pi -pi/2 0 pi/2 pi]);
end;
grid;
% Summary
RESULTS=[DFT4(1,:);ZeroPhase(1,:);MaxPhase(1,:);SineAmp(1,:);Co4(1,:);M];
assignin('base',[inputname(2) '_RESULTS'],RESULTS);
end



