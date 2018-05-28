% x=[0 0 5 0];
% y=[-3 3 0 0];

s=(-10:0.1:10);

x1=s*1+j*s*1;
y1=x1.^(-1);

figure(1);
%plot(x,y,'r','LineWidth',2.5);hold on;
plot(x1,'c','LineWidth',2.5);hold on;
plot(y1,'r','LineWidth',2.5);hold on;
xmax=20;ymax=xmax;
%axis([-xmax,xmax,-ymax,ymax]);
axis square;grid on;

plot([-xmax,xmax],[0 0],'k');
plot([0,0],[-ymax,ymax],'k');

%flag1=[x1;y1;ones(1,length(x1))];%座標点の行列表示
flag1=[real(y1);imag(y1);ones(1,length(x1))];%座標点の行列表示

%平行移動
xshift=10;yshift=5;
A=[1 0 xshift;0 1 yshift;0 0 1];
flag2=A*flag1;
x2=flag2(1,:);
y2=flag2(2,:);
%plot(x,y,'m','Linewidth',2.5);
plot(y2,'m','Linewidth',2.5);

%回転
angle=pi/4;
B=[cos(angle), -sin(angle), 0;sin(angle), cos(angle), 0;0,0,1];
flag3=B*flag1;
x3=flag3(1,:);%%%%%%%%%%% ここを複素数になるようにする
y3=flag3(2,:);
%plot(x3,y3,'g','Linewidth',2.5);
plot(real(x3)/length(x3),imag(x3),'g','Linewidth',2.5);

%回転
angle=pi/8;
B=[cos(angle), -sin(angle), 0;sin(angle), cos(angle), 0;0,0,1];
flag4=B*flag3;
x4=flag4(1,:);
y4=flag4(2,:);
%plot(x,y,'g','Linewidth',2.5);
%%% plot(y4,'b','Linewidth',2.5);


% %y軸に関する反転
% C=[-1 0 0;0 1 0;0 0 1];
% flag=C*flag;
% x=flag(1,:);
% y=flag(2,:);
% %plot(x,y,'b','Linewidth',2.5);
% %plot(y,'b','Linewidth',2.5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s=-10;
% 
% x1=s*1+j*s*1;
% y1=x1.^(-1);
% 
% %figure(1);
% %plot(x,y,'r','LineWidth',2.5);hold on;
% plot(x1,'co','LineWidth',2.5);hold on;
% plot(y1,'ro','LineWidth',2.5);hold on;
% xmax=20;ymax=xmax;
% %axis([-xmax,xmax,-ymax,ymax]);
% axis square;grid on;
% 
% plot([-xmax,xmax],[0 0],'k');
% plot([0,0],[-ymax,ymax],'k');
% 
% flag1=[x1;y1;ones(1,length(x1))];%座標点の行列表示
% 
% %平行移動
% xshift=10;yshift=5;
% A=[1 0 xshift;0 1 yshift;0 0 1];
% flag2=A*flag1;
% x2=flag2(1,:);
% y2=flag2(2,:);
% %plot(x,y,'m','Linewidth',2.5);
% plot(y2,'mo','Linewidth',2.5);
% 
% %回転
% angle=pi/8;
% B=[cos(angle), -sin(angle), 0;sin(angle), cos(angle), 0;0,0,1];
% flag3=B*flag1;
% x3=flag3(1,:);
% y3=flag3(2,:);
% %plot(x,y,'g','Linewidth',2.5);
% plot(y3,'go','Linewidth',2.5);
% 
% %回転
% angle=pi/8;
% B=[cos(angle), -sin(angle), 0;sin(angle), cos(angle), 0;0,0,1];
% flag4=B*flag3;
% x4=flag4(1,:);
% y4=flag4(2,:);
% plot(y4,'bo','Linewidth',2.5);

