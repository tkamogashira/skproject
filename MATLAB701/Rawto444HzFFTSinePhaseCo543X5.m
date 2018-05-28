% Raw to 444HzFFTSinePhaseCo 543pointsX 5zones
function RESULTS=Rawto444HzFFTSinePhaseCo543X5(X,L,ch)
%X:averaged data during 4BB ex)O2l240r24444attend
%L:fft data by channels202XY ex)O2l240r24444attend_fft_SelectChs95newC
%ch:channels204XY5

% 40Hz low-pass filter
[b,a] = ellip(10,3,100,40/300);
X2=filtfilt(b,a,X(:,(1:204)));
% baseline through 900ms
EachMean=mean(X2(:,(1:204)),1);
[p,q]=size(X2);
X3=X2(:,(1:204))-repmat(EachMean,p,1);
%all channels:M0, positive channels:M
M0((1:5),:)=L((1:5),:);
idx=find(M0(5,:)>0);M=M0((1:4),idx);
% Deviding M into 5 zones
for k=1:size(M,2)
    M(5,k)=ch(4,find(ch(1,:)==M(1,k)));
end;
% Selecting raw data in selected channels
for m=1:size(M,2)
    Mdata((1:543),m)=X3((1:543),(ch(1,:)==M(1,m)));
end;
% FFT in each column (sampling rate is 600Hz)
FFT=fft(Mdata((1:543),:));
A0=FFT(1,:);
FFT(1,:)=[];
RFFT=FFT((1:(size(FFT,1)/2)),:);
AA=size(FFT,1)/2;
Amp=abs(RFFT/(size(FFT,1)/2));
nyquist=1/2/(1/600);
FreqAxis=(1:size(RFFT,1))/(size(FFT,1)/2)*nyquist
% DFT graph 5zones
for a=1:size(M,2)
    DFT4(1,a)=Amp(4,a);
end;
% 444Hz sine waves 5zones
T=[-0.45:(1/600):(-0.45+(542/600))];
for b=1:size(M,2)
    Y(:,b)=(A0(1,b)+real(RFFT(4,b))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,b))*sin(2*pi*FreqAxis(4)*T))/(543/2);
end;

bb4=[Y (T)'];
assignin('base',[inputname(2) '_bb4'],bb4);%New

% Phase analysis by radian
T1=[-0.1125:(1/600):(-0.1125+(135/600))];
for c=1:size(M,2)
    y(:,c)=(A0(1,c)+real(RFFT(4,c))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,c))*sin(2*pi*FreqAxis(4)*T1))/(543/2);
    [Max(1,c),MaxPhaseIndex(1,c)]=max(y(:,c));
    MaxPhase(1,c)=((T1(MaxPhaseIndex(1,c)))/0.1125)*pi;
    SineAmp(1,c)=Max(1,c);
    if MaxPhase(1,c)-(pi/2)<-pi
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2)+(2*pi);
    else
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2);
    end;
end;

bb1=[y (T1)'];
assignin('base',[inputname(2) '_bb1'],bb1);%New

% Circular graph 5zones
% Coherence
for e=1:size(M,2)
    [Co,F]=mscohere(Mdata(:,e),Y(:,e),[],[],542,600);
    Co4(1,e)=Co(5);
end;
% MaxPhase vs SineAmp graph 5zones
for f=1:size(M,2)
    if M(5,f)==1
        plot(MaxPhase(1,f),SineAmp(1,f),'bx'),grid,hold on;
    elseif M(5,f)==2
        plot(MaxPhase(1,f),SineAmp(1,f),'rx'),grid,hold on;
    elseif M(5,f)==3
        plot(MaxPhase(1,f),SineAmp(1,f),'cx'),grid,hold on;
    elseif M(5,f)==4
        plot(MaxPhase(1,f),SineAmp(1,f),'mx'),grid,hold on;        
    else
        plot(MaxPhase(1,f),SineAmp(1,f),'kx'),grid,hold on;
    end;
    axis([-pi pi 0 10]);set(gca,'xtick',[-pi -pi/2 0 pi/2 pi]);
end;
grid;
% Summary
summary=[DFT4(1,:);ZeroPhase(1,:);MaxPhase(1,:);SineAmp(1,:);Co4(1,:);M];
assignin('base',[inputname(2) '_summary'],summary);
% averaged data during 4BB only for selected channels 
last=size(X,2);
waves4=[Mdata X(1:543,last)];
assignin('base',[inputname(2) '_waves4'],waves4);
end



