v=0:15;
y=[2.8 -0.77 -2.2 -3.1 -4.9 -3.2 4.83 -2.5 3.2 -3.6 -1.1 1.2 -3.2 3.3 -3.4 4.9];
s=sum(y)
%by matlab function
Y=fft(y)/(16/2);
Y(1)=Y(1)/2;
Y(9)=Y(9)/2;
[v' Y.']

fs=1000;
%by original calculation
F=[];XF=[];
for n=1:16
    f=(n-1)*fs/16;
    F=[F;f];
    xf=exp(-j*2*pi*(n-1)/16*v)*y'/16*2;
    XF=[XF;xf];
end;
XF(1)=XF(1)/2;
XF(9)=XF(9)/2;
[F XF]
%upper row:matlab
%lower row:original
subplot(2,2,1),plot(v,abs(Y));axis tight
subplot(2,2,2),plot(v,angle(Y));axis tight
subplot(2,2,3),plot(F,abs(XF));axis tight
subplot(2,2,4),plot(F,angle(XF));axis tight

%F0=0*fs/16;XF0=exp(-j*2*pi*0/16*v)*y';
%F1=1*fs/16;XF1=exp(-j*2*pi*1/16*v)*y';
%F2=2*fs/16;XF2=exp(-j*2*pi*2/16*v)*y';
figure;
t=(1/fs)*v;
COSI=zeros(1,16);
for n=1:8
    cosi=abs(XF(n))*cos(2*pi*F(n)*t+angle(XF(n)));
    subplot(3,4,n),plot(t,cosi);
    COSI=COSI+cosi;
end;

subplot(3,4,9),plot(t,y,'bo',t,COSI,'r');


