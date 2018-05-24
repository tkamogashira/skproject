function X = sys3read(Tag, N, Dev, Offset, Form);  
% sys3read - read data from circuit buffer  
%   sys3read(Tag, N, Dev) returns as a vector N samples from a buffer   
%   via tag  named Tag on device Dev. Dev defaults to sys3defaultDev.
%
%   sys3read(Tag, N, Dev, Offset) starts reading from zero-based Offset,
%   defaulting to 0.
%   (The above syntax of sys3read calls the TDT function ReadTagV.)
%
%   If N is a string 'foo' instead of number, then the number of samples N
%   is determined from the circuit itself, by reading N from a parTag named 
%   'foo'. That is, N = sys3getpar('foo', Dev).
%
%   If N is negative, the entire buffer is returned; the buffer length is
%   determined by the querying the TagSize property of the Tag (see 
%   sys3partag).
%   
%   sys3read(Tag, N, Dev, Offset, FormatString) is identical to the previous call except  
%   that it converts from a given nonstandard data format of the buffer. FormatString is   
%   one of 'F32', 'I32', 'I16', 'I8'. This syntax of sys3write calls the TDT function   
%   ReadTagVex, but the data are always returned in a simple vector of doubles (I do not  
%   understand TDT's documentation on this point).    
%  
%   Note: sys3read should only be used for reading from buffers; for simple   
%   parameter readings, use sys3getpar.  
%  
%   See also sys3write, sys3getpar, sys3partag.  
persistent Read_Stats; 
if isempty(Read_Stats), 
    Read_Stats = emptystruct('N', 'Dur', 'Time', 'Tag'); 
end

if nargin<3, Dev = ''; end;  
if nargin<4, Offset=0; end;  
if nargin<5, Form = ''; end;  
% ====diagnostics calls
if isequal('Read_Stats', Tag) && isequal('get', N),
    X = Read_Stats;
    return;
elseif isequal('Read_Stats', Tag) && isequal('clear', N),
    Read_Stats = [];
    return;
end
% ===regular calls
if ischar(N), % read from counter index
   N = sys3getpar(N, Dev);
end
% check whether Tag points to a data buffer
TagInfo = sys3partag(Dev, Tag);
if ~isequal('DataBuffer', TagInfo.DataType) && ~isequal('CoefficientBuffer', TagInfo.DataType),
    error(['ParTag ''' Tag ''' does not point to a DataBuffer or CoefficientBuffer, but to a parameter. ', ...
        'Use sys3getpar instead.' ]);
end
[actx, Dev] = sys3dev(Dev);

if isequal(0,N), % return [] without risking to crash
   X = [];
   return;
end

if N<0, % entire buffer
    N = TagInfo.TagSize;
end

if N>TagInfo.TagSize,
    error(['Number of requested samples exceeds size of Data Buffer tagged by ''' Tag '''.']);
end

tic;
if isempty(Form),
    X = invoke(actx, 'ReadTagV', Tag, Offset, N);  
else,  
    [F, Mess] = keywordMatch(Form, {'F32', 'I32', 'I16', 'I8'}, 'format string');
    error(Mess);
    X = invoke(actx, 'ReadTagVEX', Tag, Offset, N, F, 'F64', 1);  
end  
Dur = toc;
Time = now;
Read_Stats(end+1) = collectInStruct(N, Dur, Time, Tag);
if numel(Read_Stats)>1e4,
    Read_Stats = Read_Stats(5e3:end);
end

if ~isequal(N, numel(X)), error(['Error reading data from ' Dev '.']); end  

% convert to doubles
X = double(X);
  
  
