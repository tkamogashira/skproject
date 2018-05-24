function sys3halt(Dev);  
% sys3halt - halt RPX processing chain  
%   sys3halt(Dev) halts the circuit that is currenrly running on TDT device Dev. 
%   Default device is sys3defaultdev.
%  
%   See also sys3run, sys3loadCircuit, sys3devicelist.  
  
if nargin<1, Dev=''; end  
  
error(sys3unloadedError(Dev));

stat = invoke(sys3dev(Dev), 'Halt');
  
if ~stat,  
    error(['Failing Halt for device ' Dev]);  
end

% bookkeeping
private_circuitInfo(Dev,'Running', 0); 



