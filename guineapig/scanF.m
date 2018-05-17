
subplot(5,1,1)
t=(0:(1/44000):1);s=sin(2*pi*400*t);tt=(0:(1/28):1);st=sin(2*pi*400*tt)
plot(t,s,'b-',tt,st,'ro');ylim([-2 2]);title('scanF=28Hz');

subplot(5,1,2)
t=(0:(1/44000):1);s=sin(2*pi*400*t);tt=(0:(1/29):1);st=sin(2*pi*400*tt)
plot(t,s,'b-',tt,st,'ro');ylim([-2 2]);title('scanF=29Hz');

subplot(5,1,3)
t=(0:(1/44000):1);s=sin(2*pi*400*t);tt=(0:(1/30):1);st=sin(2*pi*400*tt)
plot(t,s,'b-',tt,st,'ro');ylim([-2 2]);title('scanF=30Hz');

subplot(5,1,4)
t=(0:(1/44000):1);s=sin(2*pi*400*t);tt=(0:(1/31):1);st=sin(2*pi*400*tt)
plot(t,s,'b-',tt,st,'ro');ylim([-2 2]);title('scanF=31Hz');

subplot(5,1,5)
t=(0:(1/44000):1);s=sin(2*pi*400*t);tt=(0:(1/32):1);st=sin(2*pi*400*tt)
plot(t,s,'b-',tt,st,'ro');ylim([-2 2]);title('scanF=32Hz');
