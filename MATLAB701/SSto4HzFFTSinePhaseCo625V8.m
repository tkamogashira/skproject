% SS to 4HzFFTSinePhaseCoV8 625points
function FreqAxis=SSto4HzFFTSinePhaseCo625V8(V1,V2,V3,V4,V5,V6,V7,V8)
V=[(V1)' (V2)' (V3)' (V4)' (V5)' (V6)' (V7)' (V8)'];
% FFT of SS in each column
FFT=fft(V((1:625),:));
A0=FFT(1,:);
FFT(1,:)=[];
RFFT=[FFT(1:(size(FFT,1)/2),:)];
Amp=abs(RFFT/(size(FFT,1)/2));
nyquist=1/2/0.0016;
FreqAxis=(1:size(RFFT,1))/(size(FFT,1)/2)*nyquist;
% DFT amplitude at 4Hz
DFT4(1,:)=Amp(4,:);
% SS wave and 4Hz sine wave
T=[-0.5:0.0016:(-0.5+(624*0.0016))];
for b=1:size(V,2)
    Y(:,b)=(A0(1,b)+real(RFFT(4,b))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4,b))*sin(2*pi*FreqAxis(4)*T))/(625/2);
end;
% Phase analysis by radian
T1=[-0.125:0.0016:(-0.125+(156*0.0016))];
for c=1:size(V,2)
    y(:,c)=(A0(1,c)+real(RFFT(4,c))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4,c))*sin(2*pi*FreqAxis(4)*T1))/(625/2);
    [Max(1,c),MaxPhaseI(1,c)]=max(y(:,c),[],1);
    MaxPhase(1,c)=((T1(MaxPhaseI(1,c)))/0.125)*pi;
    SineAmp(1,c)=Max(1,c);
    if MaxPhase(1,c)-(pi/2)<-pi
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2)+(2*pi);
    else
        ZeroPhase(1,c)=MaxPhase(1,c)-(pi/2);
    end;
end;
% Polar graph Zerophase vs SinAmp
subplot(2,1,1);
h=polar([-pi pi],[0 10]);delete(h);hold on;
polar(ZeroPhase(1,:),SineAmp(1,:),'b.'),hold on;
polar(MaxPhase(1,:),SineAmp(1,:),'r.'),hold on;
% Coherence
for e=1:size(V,2)
    [Co,F]=mscohere(V(:,e),Y(:,e),[],[],624,(1/0.0016));
    Co4(1,e)=Co(5);
end;
% Polar graph Zerophase vs Coherence
subplot(2,1,2);
h2=polar([-pi pi],[0 1]);delete(h2);hold on;
polar(ZeroPhase(1,:),Co4(1,:),'bx'),hold on;
polar(MaxPhase(1,:),Co4(1,:),'rx'),hold on;
% Summary of data
RESULTS=[DFT4(1,:);ZeroPhase(1,:);MaxPhase(1,:);SineAmp(1,:);Co4(1,:)];
assignin('base','RESULTS_4Hz',RESULTS);
end


