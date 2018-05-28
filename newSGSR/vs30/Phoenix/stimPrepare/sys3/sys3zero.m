function sys3zero(Tag, Dev);  
%  SYS3ZERO - set parameter or buffer values to zero
%     SYS3ZERO(Tag, Dev) sets parameter connected to named
%     Tag to zero in current circiot of device Dev. Dev defaults to 'RP2_1'.  
%  
%     See also SYS3SETPAR, SYS3WRITE.  
  
if nargin<2, Dev = 'RP2_1'; end  
  
  
stat = invoke(sys3dev(Dev), 'ZeroTag', Tag);
if ~stat,  
    error(['Error while zeroing out parameter on ' Dev]);  
end  
  
  
