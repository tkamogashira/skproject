function X = sys3getpar(Tag, Dev);  
%  SYS3GETPAR - get parameter value of RPx component  
%     SYS3GETPAR(Tag, Dev) returns a parameter on device Dev via tag  
%     named Tag. Dev defaults to 'RP2_1'.  
%  
%     Note: SYS3GETPAR should not be used for reading RPx buffers; use SYS3READ  
%     to do that.  
%  
%     See also SYS3SETPAR, SYS3READ.  
  
if nargin<2, Dev = 'RP2_1'; end  
  
d = sys3dev(Dev);  
  
% there is no decent error checking for GetTagVal; use GetTagSize to test existence and connection of Tag  
N = invoke(d, 'GetTagSize', Tag);   
if ~isequal(1,N),  
    error(['Error retrieving parameter value on ' Dev]);  
end  
  
X = double(invoke(d, 'GetTagVal', Tag)); % getTagVal returns useless singles  
  
  
