function sys3halt(Dev);  
% SYS3HALT - halt RPX processing chain  
%   SYS3HALT halts the RP2_1. SYS3HALT(Dev) halts the named device.  
%   Dev can be one of 'RP2_1', 'RV8_1'  
%  
%   See also SYS3RUN, SYS3TRIG, SYS3DEV, loadCOF.  
  
if nargin<1, Dev='RP2_1'; end  
  
stat = invoke(sys3dev(Dev), 'Halt');  
  
if ~stat,  
    error(['Failing Halt for device ' Dev]);  
end  
