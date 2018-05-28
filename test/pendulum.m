 g=9.8;L=0.7;r=0.05;t=0;dt=0.1;x=0;y=0;z=0;
 clf;hold on
 the0=40*pi/180;guz0=0;the=the0;guz=guz0;
 [bx,by,bz]=sphere;
 bx=r*bx;by=r*by;bz=r*bz;
 axis square
 while t<10.0
     x=L*sin(the);z=-L*cos(the);
     cx=bx+x;cy=by+y;cz=bz+z;
     colormap([1 0 0;1 0.2 0;1 0.5 0;1 0.6 0;1 0.8 0;1 1.0 0]);
     surfl(cx,cy,cz);
     shading flat;
     q=[0:0.005:1];yq=zeros(1,length(q));
     plot3(x*q,yq,z*q,'r')
     axis([-1 1 -1 1 -1 1]);
     title('Movement of pendulum')
     xlabel('x (m)'),zlabel('z (m)')
     view(0,0);
     guz=guz-g/L*sin(the)*dt;
     the=the+guz*dt;
     pause(1);
     t=t+dt;
 end
 hold off  