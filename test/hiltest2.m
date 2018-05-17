

nam='01_U-I-330.wav';
[orig1, Fs] = wavread(nam);


t=[0:length(orig1)-1]*1000/Fs;

hil=hilbert(orig1);

env=abs(hil);


fine=cos(angle(hil));

figure;
subplot(2,1,1)


plot(t,env);

subplot(2,1,2)

plot(t,fine);