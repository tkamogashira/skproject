clear all;
tdres = 10e-6;
cf = 500;
index = 1;
ifspike = 0; % No spikes, just sout
for spl = -10:10:60,
  sig = sin((1:5000)*tdres*2*pi*cf);
  sig(1:200) = sig(1:200).*(0:199)/199;
  sig(4801:5000) = sig(4801:5000).*(199:-1:0)/199;
  sig = spl2a(spl)*sig;
  sout(:,index) = an_arlo([tdres,cf,50,1,0,ifspike],sig');
  sout2(:,index) = an_arlo([tdres,cf,50,1,9,ifspike],sig');
  rate(index) = mean(sout(:,index));
  rate2(index) = mean(sout2(:,index));
  index = index+1;
end;
figure;
plot(-10:10:60,rate);
title('human');
figure;
plot(sout);
title('human');
figure;
plot(sout2);
title('species 9');
figure;
plot(-10:10:60,rate2);
title('species 9');
