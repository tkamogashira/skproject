% SS to 4HzSinePhase 625points +Coherence 8type
function FreqAxis=SSto4HzSinePhase625Co8type(M)
for r=1:size(M,2)
    FFT=fft(M(:,r));
    A0=FFT(1);
    FFT(1)=[];
    RFFT=[FFT(1:(length(FFT)/2))];
    Amp=abs(RFFT/(length(FFT)/2));
    nyquist=1/2/0.0016;
    FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
% DFT graph
    DFT4(1,r)=Amp(4);
% SS wave and 4Hz sine wave
    T=[-0.5:0.0016:(-0.5+(624*0.0016))];
    Y=(A0+real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/(625/2);
% Phase analysis
    T1=[-0.125:0.0016:(-0.125+(156*0.0016))];
    y=(A0+real(RFFT(4))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T1))/(625/2);
    [Max,MaxPhaseI]=max(y);
    if ((T1(MaxPhaseI))/0.25)-0.25<-0.5
        ZeroPhase(1,r)=((T1(MaxPhaseI))/0.25)+0.75;
        MaxPhase(1,r)=(T1(MaxPhaseI))/0.25;
        SineAmp(1,r)=Max;
    else
        ZeroPhase(1,r)=((T1(MaxPhaseI))/0.25)-0.25;
        MaxPhase(1,r)=(T1(MaxPhaseI))/0.25;
        SineAmp(1,r)=Max;
    end;
% Coherence
    [Co,F]=mscohere(M(:,r),Y,[],[],624,(1/0.0016));
    Co4(1,r)=Co(5);
end;
% Summary of data
ZeroMaxAmpSpCo=[ZeroPhase;MaxPhase;SineAmp;DFT4;Co4];
assignin('base','ZeroMaxAmpSpCo',ZeroMaxAmpSpCo); 
end


