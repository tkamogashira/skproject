function sys3write(X, Tag, Dev, Offset, Form);  
% SYS3WRITE - write data to RPx buffer  
%   SYS3WRITE(X, Tag, Dev) writes vector X to a buffer via tag named Tag on device Dev.  
%   Dev defaults to 'RX6'.   
%  
%   SYS3WRITE(X, Tag, Dev, Offset) writes vector X to a buffer via a tag named Tag   
%   on device Dev. Offset is the starting address in the buffer; it defaults to 0.  
%   Dev defaults to 'RX6'. This syntax of SYS3WRITE calls the TDT function WriteTagV.  
%   
%   SYS3WRITE(X, Tag, Dev, Offset, FormatString) does the same, but uses a non-standard  
%   data format: FormatString is one of 'F32', 'I32', 'I16', 'I8'. This syntax of SYS3WRITE   
%   calls the TDT function WriteTagVex.  
%   
%  
%   Note: sys3write should only be used for writing to buffers; for simple   
%   parameter settings, use SYS3SETPAR.  
%  
%   See also SYS3READ, SYS3SETPAR, SYS3ZERO.
  
if nargin<3, Dev='RX6'; end;  
if nargin<4, Offset=0; end;  
if nargin<5, Form = ''; end;  
  
if isempty(Form),  
    X = X(:).'; % single row vector  
    stat = invoke(sys3dev(Dev), 'WriteTagV', Tag, Offset, X);  
else,  
    if size(X,2)<size(X,1), X = X.'; end; % assume more samples per channel than there are channels  
    stat = invoke(sys3dev(Dev), 'WriteTagVEX', Tag, Offset, Form, X);  
end  
  
if ~stat, error(['Error writing data to ' Dev]); end  
  
  
  
