function sys3trig(N, Dev);  
% sys3trig - send software trigger to RPX device  
%   sys3trig(N, Dev) sends soft trigger #N to device named Dev.
%   N must be an integer between 1 and 10; default is 1.
%   Dev defaults to sys3defaultDev.
%  
%   See also sys3run, sys3loadCircuit, sys3defaultDev.  
  
if nargin<1, N=1; end  
if nargin<2, Dev=''; end  
error(sys3unloadedError(Dev));

[actx, Dev] = sys3dev(Dev);


if (N<1) | (N>10),  
    error('Trigger number is out of range.');  
end  
  
stat = invoke(actx, 'SoftTrg', N);  
if ~stat,  
    error(['Failing software trigger for device ' Dev '.']);  
end  
