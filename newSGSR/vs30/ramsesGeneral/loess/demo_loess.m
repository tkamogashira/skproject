
xi = (0:199)/200;
x = (0:2:99)/100;
yi = sin(2*pi*xi) + 0.2*randn(size(xi));

plot(xi,yi,'x'); hold on;

y = loess(xi,yi,x,0.15,1);
plot (x,y,'r');
