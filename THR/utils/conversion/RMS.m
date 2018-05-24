function y=rms(x, zeromean);
% RMS - root mean square of an array.
%   RMS(X) is root mean square of abs(X).
%
%   RMS(X,1) is root mean square of abs(X-mean(X)), ie the mean-zero RMS.
%
%   See also RMSdB, STD.

if nargin<2, zeromean = 0; end;

if zeromean,
   y = (mean((abs(x-mean(x))).^2)).^0.5;
else
   y = (mean((abs(x)).^2)).^0.5;
end
