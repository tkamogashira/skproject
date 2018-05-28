function sys3run(Dev);  
% SYS3RUN - start RPX processing chain  
%   SYS3RUN starts the RX6.   
%   SYS3RUN(Dev) starts the named device.  
%   Dev can be one of 'RX6', 'RP2'  
%  
%   See also SYS3HALT, SYS3TRIG, SYS3DEV, loadCOF.  
  
if nargin<1, Dev='RX6'; end  
  
stat = invoke(sys3dev(Dev), 'Run');  
  
if ~stat,  
    error(['Failing Run for device ' Dev]);  
end  
