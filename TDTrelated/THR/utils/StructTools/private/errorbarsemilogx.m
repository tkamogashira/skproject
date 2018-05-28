function Hdl = errorbarsemilogx(X, Y, ErrL, ErrH)
%function handle=errorbarloglog(x,y,errl,errh);
%
%plots error bars in 2D loglog-plot correctly, solving the problem with
%Matlab errorbar function.
%
%IN:
%x: x-axis data vector
%y: y-axis data vector
%errl: vector containing errors. If only 3 input arguments are given, this
%is half the height of the error bar. If four input arguments are given,
%this is the lower bound error vector
%errh: upper boud error vector (optional)
%
%OUT: axes handle
%
%Copyright Erik Benkler, Physikalisch-Technische Bundesanstalt
%Section 4.53: Microoptics Measuring Technologies
%D-38116 Braunschweig, GERMANY
%
%Version 0.1, October 21 2004, checked with Matlab R14 (7.0.0.19920)
%Adjusted by B. Van de Sande on 18-07-2005

if (nargin == 3), ErrH = Y + ErrL; ErrL = Y - ErrL; end

Hdl = gca; set(Hdl,'xscale','log', 'yscale','lin'); %make semilogx axes
line(X, Y); %plot the data first

Ax = log(xlim);%determine axis limits
%This sets the with of the errorbar heads to 2% of the x-axis width
%AS IT WILL APPEAR IN THE SEMILOGX-PLOT:
Xhw=[X-Ax(2)*X/50, X+1.2*Ax(2)*X/50];

for n = 1:length(X),
    line(X([n, n]), [ErrL(n), ErrH(n)]); %plot errorbars
    line(Xhw(n, :), [ErrL(n), ErrL(n)]); %plot lower errorbar heads
    line(Xhw(n, :), [ErrH(n), ErrH(n)]); %plot upper errorbar heads
end