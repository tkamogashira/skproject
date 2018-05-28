function sys3trig(N, Dev);  
% SYS3TRIG - send software trigger to RPX device  
%   SYS3TRIG sends trigger #1 to the RP2_1.   
%   SYS3TRIG(N) sends trigger #N to the RP2_1; 1<=N<=10.  
%   SYS3TRIG(N, Dev) sends trigger #N to device named Dev.  
%   Dev can be one of 'RP2_1', 'RV8_1'  
%  
%   See also SYS3RUN, SYS3HALT, SYS3DEV, loadCOF.  
  
if nargin<1, N=1; end  
if nargin<2, Dev='RP2_1'; end  
  
if (N<1) | (N>10),  
    error('Trigger number is out of range.');  
end  
  
stat = invoke(sys3dev(Dev), 'SoftTrg', N);  
if ~stat,  
    error(['Failing software Trigger for device ' Dev]);  
end  
