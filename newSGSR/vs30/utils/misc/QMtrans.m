function [T,Y] = QMtrans(tmax, F1, F2, DF, k, disb);
% QMtrans - 2 nonlin coupled oscillators

% initialize local DY
DY_QMtrans(nan,nan, 2*pi*F1, 2*pi*F2, 2*pi*DF, k);

w1 = 1-disb;
w2 = sqrt(1-w1^2);

eee = exp(2*pi*i*rand(2,1));
a0 = eee.*[w1; w2];
eee = exp(2*pi*i*rand(2,1));
b0 = eee.*[w2; w1];

Y0 = [a0;b0]

tspan = [0 tmax];
[T,Y]= ode45('DY_QMtrans', tspan,Y0);








