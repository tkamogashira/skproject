function s = sys3status(Dev);  
% SYS3STATUS - get status of sys3 device  
%   Sys3status(dev) returns the status of the sys3 device  
%   as a bit mask. Dev is ione of 'RP2_1', 'RV8_1', 'PA5'.  
%   Default device is RP2_1.  
%   Meaning of the bits of the bit mask:  
%   bit   0              1               2                   3  
%     Connection   Circuit Loaded   Circuit Running   Battery Status  
%   See TDT documentation: ActiveX | GetStatus  
  
if nargin<1, Dev='RP2_1'; end;  
s = invoke(sys3dev(Dev),'getstatus');  
  
