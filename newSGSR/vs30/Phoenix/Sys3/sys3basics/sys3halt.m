function sys3halt(Dev);  
% SYS3HALT - halt Sys3 device processing chain  
%   SYS3HALT halts the Sys3 device . SYS3HALT(Dev) halts the named device.  
%   Dev can be one of 'RX6', 'RP2'  
%  
%   See also SYS3RUN, SYS3TRIG, SYS3DEV, loadCOF.  
  
if nargin<1, Dev='RX6'; end  
  
stat = invoke(sys3dev(Dev), 'Halt');  
  
if ~stat,  
    error(['Failing Halt for device ' Dev]);  
end  
