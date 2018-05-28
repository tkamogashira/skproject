Fs=44000;a=1;
fclist=[500 1000 2000 4000];
fmlist=[77 85 93 101];

N=2;ma=1;
figure;

nsig=Fs*4;%4•b
siglist=[];sigsum=zeros(1,nsig);
for k=1:4
    fc=fclist(1,k);fm=fmlist(1,k);
    
    perio=1/Fs;% s
    tim=(perio:perio:(perio*nsig));

    %%% sig=a * sin(2*pi*fc*tim) .* (  2*ma*(  (( 1+sin(2*pi*fm*tim) )/2).^N - 0.5*ones(1,nsig) ) +1*ones(1,nsig) );
    sig=a * sin(2*pi*fc*tim) .* (  2*ma*(  (( 1+sin(2*pi*fm*tim-pi/2) )/2).^N - 0.5*ones(1,nsig) ) +1*ones(1,nsig) );
    sighil=hilbert(sig);env=abs(sighil);
    %%% wavwrite(sig/100,Fs,['fc' num2str(fc) 'fm' num2str(fm) 'N' num2str(N)]);
    AmpSpec=abs(fft(sig)); %Amplitude spectrum
    %AmpSpec=AmpSpec(1:L)/L; %%%%%%
    AmpSpec_dB=20*log10(AmpSpec); %Spectrum in dB, for the positive frequency part
    L=nsig;
    %Freq=(1:L)/L*Fs/2;
    Freq=(1:L)/L*Fs;

    subplot(4,2,k*2-1)
    plot(tim,sig);hold on;plot(tim,env,'m');
    grid on;xlim([0 25/1000]);
    title(['Fm=' num2str(fm) 'Hz']);xlabel('Time (s)');

    subplot(4,2,k*2)
    plot(Freq/1000,AmpSpec_dB);grid on;
    %    xlim([0 Fs/2/1000]);
    xlim([0 5]);xlabel('Frequency (kHz)');ylabel('dB')    
    title(['Fc=' num2str(fc) 'Hz']);    
    
    siglist{1,k}=sig;
    sigsum=sigsum+sig;
end;
figure;

sig=sigsum/4;
wavwrite(sig/100,Fs,['masterN' num2str(N)]);

AmpSpec=abs(fft(sig)); %Amplitude spectrum
%AmpSpec=AmpSpec(1:L)/L; %%%%%%
AmpSpec_dB=20*log10(AmpSpec); %Spectrum in dB, for the positive frequency part
L=nsig;
%Freq=(1:L)/L*Fs/2;
Freq=(1:L)/L*Fs;

subplot(2,1,1)
plot(tim,sig);hold on;%plot(tim,env,'m');
grid on;xlim([0 200/1000]);
%title(['Fm=' num2str(fm) 'Hz']);
xlabel('Time (s)');

subplot(2,1,2)
plot(Freq/1000,AmpSpec_dB);grid on;
%    xlim([0 Fs/2/1000]);
xlim([0 5]);xlabel('Frequency (kHz)');ylabel('dB')    
%title(['Fc=' num2str(fc) 'Hz']);    

    
    