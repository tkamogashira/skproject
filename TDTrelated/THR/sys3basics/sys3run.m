function sys3run(Dev);  
% sys3run - start RPX processing chain  
%   sys3run(Dev) starts the circuit on sys3 device Dev. 
%   Default device is sys3defaultDev.
%  
%   See also sys3halt, sys3trig, sys3loadCircuit, sys3circuitInfo.  
  
if nargin<1, Dev=''; end  

%whoiscalling

error(sys3unloadedError(Dev));

[actx, Dev] = sys3dev(Dev);
stat = invoke(actx, 'Run');  
  
if ~stat,  
    error(['Failing Run for device ' Dev '.']);  
end  

% bookkeeping
private_circuitInfo(Dev,'Running', 1); 


