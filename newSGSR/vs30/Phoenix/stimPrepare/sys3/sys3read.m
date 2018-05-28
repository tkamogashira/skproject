function X = sys3read(Tag, Dev, N, Offset, Form);  
% SYS3READ - read data from RPx buffer  
%   SYS3READ(Tag, Dev, N, Offset) returns as a vector N samples from a buffer   
%   via tag  named Tag on device Dev. Offset is the zero-based  
%   position in the buffer where reading is started, it defaults to zero.  
%   This syntax of SYS3READ calls the TDT function ReadTagV.  
%   If N is a string 'foo' instead of number, then the number of samples is read
%   from a parTag named 'foo'. That is, N = sys3getpar('foo', Dev).
%   
%   SYS3READ(Tag, Dev, N, Offset, FormatString) is identical to the previous call except  
%   that it converts from a given nonstandard data format of the buffer. FormatString is   
%   one of 'F32', 'I32', 'I16', 'I8'. This syntax of SYS3WRITE calls the TDT function   
%   ReadTagVex, but the data are always returned in a simple vector of doubles (I do not  
%   understand TDT's documentation on this point).    
%  
%   Note: sys3read should only be used for reading from buffers; for simple   
%   parameter readings, use SYS3GETPAR.  
%  
%   See also SYS3WRITE, SYS3GETPAR.  
  
if nargin<4, Offset=0; end;  
if nargin<5, Form = ''; end;  
if ischar(N), % read from counter index
   N = sys3getpar(N, Dev);
end

if isequal(0,N), % return [] without risking errors
   X = [];
   return;
end

if isempty(Form),  
    X = invoke(sys3dev(Dev), 'ReadTagV', Tag, Offset, N);  
else,  
    X = invoke(sys3dev(Dev), 'ReadTagVEX', Tag, Offset, N, Form, 'F64', 1);  
end  
  
if ~isequal(N, numel(X)), error(['Error reading data from ' Dev]); end  

% convert to doubles
X = double(X);
  
  
