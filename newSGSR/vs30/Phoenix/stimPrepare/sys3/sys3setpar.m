function sys3setpar(X, Tag, Dev);  
%  SYS3SETPAR - set parameter of RPx component  
%     SYS3SETPAR(X, Tag, Dev) accesses a parameter on device Dev via tag  
%     named Tag and sets its value to X. Dev defaults to 'RP2_1'.  
%  
%     Note: SYS3SETPAR should not be used for filling RPx buffers; use SYS3WRITE  
%     to do that.  
%  
%     See also SYS3GETPAR, SYS3WRITE, SYS3ZERO.  
  
if nargin<3, Dev = 'RP2_1'; end  
  
if ~isequal(1, numel(X)),  
    error('Parameter values must be scalars.');  
end  
  
stat = invoke(sys3dev(Dev), 'SetTagVal', Tag, X);  
if ~stat,  
    error(['Error while setting parameter on ' Dev]);  
end  
  
  
