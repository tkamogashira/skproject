function guineapignoise2(duration,ramp,interval,repeat)

fs=44100;
t=(0:(1/fs):(interval+duration)*repeat);
%td=(0:(1/fs):duration);
upidx=find(t<=ramp);
up=t(upidx)/(max(t(upidx)))*1;
down=ones(1,size(upidx,2))-up;
durationidx=find(t<=duration);plateau=ones(1,(size(durationidx,2)-size(up,2)-size(down,2)));
envelope=[up plateau down];
%s=sin(2*pi*f*t(durationidx)).*envelope;
s=randn(1,length(t(durationidx))).*envelope;
intervalidx=find((t>duration)&(t<=duration+interval));
inter=zeros(1,size(intervalidx,2));
ss=repmat([s inter],1,repeat);
ss=ss(1:size(t,2));
plot(t,ss)
hold on
sound(ss',fs)
%plot1=plot([0 0],[-1 1]);set(gca,'drawmode','fast');
%set(plot1,'erasemode','xor');
%for T=