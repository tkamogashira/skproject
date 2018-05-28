FreqStr='1000 0';
SPLStr='80';
ITDStr='0';
FixEnvStr='0';
ILDStr='0';
DurationStr='0 20 0 5';
%DurationStr='0 1000 0 0';
%Fs=44100;
Fs=1000*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;

nsig=floor(Fs*20/1000);%20ÇçÇì
clickdur=0.1;%ms
intervalcoi=10;
sig=zeros(1,nsig);
for k=0:19
sig(1+k*floor(Fs*clickdur/1000)*intervalcoi:floor(Fs*clickdur/1000)+k*floor(Fs*clickdur/1000)*intervalcoi)=ones(1, floor(Fs*clickdur/1000) );
end;

sig(1)=0;

%%%sighil=hilbert(sig);env=abs(sighil);

perio=(1/Fs)*1000;% ms
tim=(perio:perio:(perio*nsig));
AmpSpec=abs(fft(sig)); %Amplitude spectrum
%AmpSpec=AmpSpec(1:L)/L; %%%%%%
AmpSpec_dB=20*log10(AmpSpec); %Spectrum in dB, for the positive frequency part
L=nsig;
%Freq=(1:L)/L*Fs/2;
Freq=(1:L)/L*Fs;
wavwrite(sig/10,Fs,'Dur02msClick');

subplot(2,3,1)
plot(tim,sig,'b.-');grid on;
xlabel('Time (ms)');title('Duration=0.2ms');

subplot(2,3,2)
plot(tim,sig,'b.-');grid on;
xlim([-0.5 2.5]);
xlabel('Time (ms)');

subplot(2,3,3)
semilogx(Freq/1000,AmpSpec_dB);grid on;
xlim([0 Fs/2/1000]);
xlabel('Frequency (kHz)');ylabel('dB')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsig=floor(Fs*20/1000);%20ÇçÇì
clickdur=0.1;%ms
intervalcoi=10;
sig=zeros(1,nsig);
for k=0:19
sig(1+k*floor(Fs*clickdur/1000)*intervalcoi:floor(Fs*clickdur/1000)+k*floor(Fs*clickdur/1000)*intervalcoi)=ones(1, floor(Fs*clickdur/1000) );
end;

intervalcoi2=8;
for k=0:20
sig(1+k*floor(Fs*clickdur/1000)*intervalcoi2+(20)...
    :floor(Fs*clickdur/1000)+k*floor(Fs*clickdur/1000)*intervalcoi2+(20))...
    =ones(1, floor(Fs*clickdur/1000) );
end;

sig(1)=0;

%%%sighil=hilbert(sig);env=abs(sighil);

perio=(1/Fs)*1000;% ms
tim=(perio:perio:(perio*nsig));
AmpSpec=abs(fft(sig)); %Amplitude spectrum
%AmpSpec=AmpSpec(1:L)/L; %%%%%%
AmpSpec_dB=20*log10(AmpSpec); %Spectrum in dB, for the positive frequency part
L=nsig;
%Freq=(1:L)/L*Fs/2;
Freq=(1:L)/L*Fs;
wavwrite(sig/10,Fs,'Dur02msClick');

subplot(2,3,4)
plot(tim,sig,'b.-');grid on;
xlabel('Time (ms)');title('Duration=0.2ms');

subplot(2,3,5)
plot(tim,sig,'b.-');grid on;
xlim([-0.5 2.5]);
xlabel('Time (ms)');

subplot(2,3,6)
semilogx(Freq/1000,AmpSpec_dB);grid on;
xlim([0 Fs/2/1000]);
xlabel('Frequency (kHz)');ylabel('dB')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%