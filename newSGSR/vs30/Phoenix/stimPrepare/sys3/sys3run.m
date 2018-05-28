function sys3run(Dev);  
% SYS3RUN - start RPX processing chain  
%   SYS3RUN starts the RP2_1.   
%   SYS3RUN(Dev) starts the named device.  
%   Dev can be one of 'RP2_1', 'RV8_1'  
%  
%   See also SYS3HALT, SYS3TRIG, SYS3DEV, loadCOF.  
  
if nargin<1, Dev='RP2_1'; end  
  
stat = invoke(sys3dev(Dev), 'Run');  
  
if ~stat,  
    error(['Failing Run for device ' Dev]);  
end  
