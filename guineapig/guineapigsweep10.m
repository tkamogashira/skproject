function guineapigsweep10(f,duration,ramp,interval)

repeat=10;


fs=44100;
t=(0:(1/fs):(interval+duration)*repeat);
upidx=find(t<=ramp);
up=t(upidx)/(max(t(upidx)))*1;
down=ones(1,size(upidx,2))-up;
durationidx=find(t<=duration);plateau=ones(1,(size(durationidx,2)-size(up,2)-size(down,2)));
envelope=[up plateau down];
%s=sin(2*pi*f*t(durationidx)).*envelope;

s1=sin(2*pi*f(1)*t(durationidx)).*envelope;
s2=sin(2*pi*f(2)*t(durationidx)).*envelope;
s3=sin(2*pi*f(3)*t(durationidx)).*envelope;
s4=sin(2*pi*f(4)*t(durationidx)).*envelope;
s5=sin(2*pi*f(5)*t(durationidx)).*envelope;
s6=sin(2*pi*f(6)*t(durationidx)).*envelope;
s7=sin(2*pi*f(7)*t(durationidx)).*envelope;
s8=sin(2*pi*f(8)*t(durationidx)).*envelope;
s9=sin(2*pi*f(9)*t(durationidx)).*envelope;
s10=sin(2*pi*f(10)*t(durationidx)).*envelope;


intervalidx=find((t>duration)&(t<=duration+interval));
inter=zeros(1,size(intervalidx,2));

%ss=repmat([s inter],1,repeat);
ss=[s1 inter s2 inter s3 inter s4 inter s5 inter s6 inter s7 inter s8 inter s9 inter s10 inter];

ss=ss(1:size(t,2));
plot(t,ss)
hold on
sound(ss',fs)
%plot1=plot([0 0],[-1 1]);set(gca,'drawmode','fast');
%set(plot1,'erasemode','xor');
%for T=