close all;clear all
figure(1);tic;
set(1,'doublebuffer','on');
for x=0:0.1:2*pi;
plot (cos(x),sin(x),'o');axis([-1.2 1.2 -1.2 1.2]);
drawnow;
end;
toc