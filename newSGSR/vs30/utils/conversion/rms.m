function y=rms(x, zeromean);

if nargin<2, zeromean = 0; end;

if zeromean,
   y = (mean((abs(x-mean(x))).^2))^0.5;
else
   y = (mean((abs(x)).^2))^0.5;
end
