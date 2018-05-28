% Raw to 4HzPolarPhaseCo 603points
function AA=Rawto4HzPolarPhaseCo603(X,M,ch)
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
RFFT=[FFT((1:(size(FFT,1)/2)),:)];
AA=size(FFT,1)/2;
Amp=abs(RFFT/(size(FFT,1)/2));
nyquist=1/2/(1/600);
FreqAxis=(1:size(RFFT,1))/(size(FFT,1)/2)*nyquist;
% DFT peaks at 4Hz
for a=1:size(M,2)
    DFT4(1,a)=Amp(4,a);
end;
% 4Hz sine wave
T=[-0.5:(1/600):(-0.5+(602/600))];
for b=1:size(M,2)
    Y(:,b)=(A0(1,b)+real(RFFT(4,b))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,b))*sin(2*pi*FreqAxis(4)*T))/(603/2);
end;
% Phase analysis by radian
T1=[-0.125:(1/600):(-0.125+(75/600))];
for c=1:size(M,2)
    y(:,c)=(A0(1,c)+real(RFFT(4,c))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,c))*sin(2*pi*FreqAxis(4)*T1))/(603/2);
    [Max(1,c),MaxPhaseIndex(1,c)]=max(y(:,c));
    if T1(MaxPhaseIndex(1,c))-(0.25/4)<-0.125
        ZeroPhase(1,c)=((T1(MaxPhaseIndex(1,c))-(0.25/4)+0.25)/0.125)*pi;
        MaxPhase(1,c)=((T1(MaxPhaseIndex(1,c)))/0.125)*pi;
        SineAmp(1,c)=Max(1,c);
    else
        ZeroPhase(1,c)=((T1(MaxPhaseIndex(1,c))-(0.25/4))/0.125)*pi;
        MaxPhase(1,c)=((T1(MaxPhaseIndex(1,c)))/0.125)*pi;
        SineAmp(1,c)=Max(1,c);
    end;
end;
% Polar ZeroPhase vs SineAmp L/C/R
subplot(2,1,1);
h=polar([-pi pi],[0 10]);delete(h);hold on;
for d=1:size(M,2)
    if M(2,d)==1
        polar(ZeroPhase(1,d),SineAmp(1,d),'b.'),hold on;
    elseif M(2,d)==2
        polar(ZeroPhase(1,d),SineAmp(1,d),'r.'),hold on;
    else
        polar(ZeroPhase(1,d),SineAmp(1,d),'k.'),hold on;
    end;
end;
% Coherence
for e=1:size(M,2)
    [Co,F]=mscohere(Mdata(:,e),Y(:,e),[],[],602,600);
    Co4(1,e)=Co(5);
end;
% Polar ZeroPhase vs Coherence graph L/C/R
subplot(2,1,2);
h2=polar([-pi pi],[0 1]);delete(h2);hold on;
for f=1:size(M,2)
    if M(2,f)==1
        polar(ZeroPhase(1,f),Co4(1,f),'bx'),hold on;
    elseif M(2,f)==2
        polar(ZeroPhase(1,f),Co4(1,f),'rx'),hold on;
    else
        polar(ZeroPhase(1,f),Co4(1,f),'kx'),hold on;
    end;
end;
% Summary
RESULTS=[DFT4(1,:);ZeroPhase(1,:);MaxPhase(1,:);SineAmp(1,:);Co4(1,:)];
assignin('base',[inputname(2) '_RESULTS'],RESULTS);
end



