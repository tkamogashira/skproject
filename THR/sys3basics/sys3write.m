function sys3write(X, Tag, Dev, Offset, Form, Security);  
% sys3write - write data to RPx buffer or zero out buffer 
%   sys3write(X, Tag, Dev) writes vector X to a buffer via tag named Tag on device Dev.  
%   Dev defaults to sys3defaultDev. 
%  
%   sys3write(X, Tag, Dev, Offset) writes vector X to a buffer via a tag named Tag   
%   on device Dev. Offset is the starting address in the buffer; it defaults to 0.  
%   Dev defaults to the sys3 default device (see sys3setup).
%   This syntax of sys3write calls the TDT function WriteTagV.  
%   
%   sys3write(X, Tag, Dev, Offset, FormatString) does the same, but uses a non-standard  
%   data format: FormatString is one of 'F32', 'I32', 'I16', 'I8'. This syntax of sys3write   
%   calls the TDT function WriteTagVex. Default format is F32.
%   
%   sys3write(X, Tag, Dev, Offset, FormatString, 1) performs a security
%   check; the last 10% of array X is read back (see sys3read) and compared
%   to X. An error is thrown when there is an inconsistencey.
%   
%   sys3write(X, Tag, Dev, Offset, FormatString, N) also performs the 
%   security check, does not give up so fast: it only throws the error after 
%   N failed attempts to get the data across.
%   
%   sys3write('zero', Tag, Dev) fills the entire buffer with zeros.
%   (this syntax invokes TDT 'ZeroTag'). Slow!
%  
%   Note: sys3write should only be used for writing to buffers; for simple   
%   parameter settings, use SYS3SETPAR.  
%
%   Note 2: if X consists of a single sample, an error results, because of 
%   a bug in the TDT drivers which prevent writing single samples to data 
%   buffers. 
%  
%   See also sys3read, sys3setpar, sys3tagList, sys3defaultDev.  
  
if nargin<3, Dev=''; end;  
if nargin<4, Offset=0; end;  
if nargin<5, Form = ''; end;  
if nargin<6, Security=0; end; % default: no security 

NmaxChunk = 1e5; % max # samples transferred in a single actx call

% check whether Tag points to a data buffer ...
TagInfo = sys3partag(Dev, Tag);
if ~isequal('DataBuffer', TagInfo.DataType) && ~isequal('CoefficientBuffer', TagInfo.DataType),
    error(['ParTag ''' Tag ''' does not point to a DataBuffer or CoefficientBuffer, but to a parameter. ', ...
        'Use sys3setpar instead.' ]);
elseif Offset+numel(X) > TagInfo.TagSize, % ... and whether buffer is large enough..
    error(['Data size+offset exceed buffer size for buffer tagged ''' Tag  '''.']);
end
[actx, Dev] = sys3dev(Dev);

if isequal('zero', lower(X)), % see help
    stat = invoke(actx, 'ZeroTag', Tag);
    if ~stat, error(['Error zeroing buffer on ' Dev '.']); end
    return;
end

if ~isnumeric(X),
    error('X must be either a numeric array or the string ''zero''.');
end
if any(isnan(X)),
    error('X may not contain NaNs.');
end

Nsam = numel(X); 
if Nsam<2,
    error(['Arrays written to TDT buffers must have length 2 or more.']);
end
if Nsam>TagInfo.TagSize,
    Nsam
    error(['Number of requested samples exceeds size of Data Buffer tagged by ''' Tag '''.']);
end
Ntry = max(1,Security);

if ~isempty(Form), % expand it
    [Form, Mess] = keywordMatch(Form, {'F32', 'I32', 'I16', 'I8'}, 'format string');
    error(Mess);
end
if Security>0, % write  2 random numbers to the last 2 samples. This will cause the read-back test ...
    % to fail when data transfer corrupt, even following a succesful
    % sys3write call that wrote the same data. (2 samples are needed
    % because writing a single value causes the TDT fcn to fail)
    Temp_Offset = Nsam-2; % write the random samples at the end of th target range
    x = 1e3*rand(1,2);
    stat = local_WriteTag(actx, Tag, Temp_Offset, '', x, 1e6);
    if ~stat, error(['Error writing data to ' Dev '.']); end
end
% ===== the real data transfer =====
for itry=1:Ntry,
    %disp([num2str(Nsam) ' -> ' Tag]);
    if isempty(Form),
        X = X(:).'; % single row vector
        stat = local_WriteTag(actx, Tag, Offset, '', X, NmaxChunk);
    else,
        if size(X,2)<size(X,1), X = X.'; end; % assume more samples per channel than there are channels
        stat = local_WriteTag(actx, Tag, Offset, Form, X, NmaxChunk);
    end
    if ~stat, error(['Error writing data to ' Dev '.']); end
    % perform security check if requested
    if Security>0, 
        okay = local_check(X, Tag, Dev , Offset, Form);
    else, okay=1;
    end
    if okay, break; end
    warning(['Problems writing samples to ' Dev ' (Tag ' Tag ') ... retrying.'])
end
if ~okay, 
    error(['Error writing data to buffer tagged ''' Tag '''; ' num2str(Ntry) ' write attempts.']); 
end
  
  
%----------------------------
function okay = local_check(X, Tag, Dev , Offset, FormatString);
% check data transfer by reading back the last 10% of the samples. Most
% write errors produce "gaps" in the buffer, so checking the final part is
% quite a strict test.
Nsam = numel(X); 
NsamCheck = ceil(Nsam/10);
OffsetCheck = Nsam-NsamCheck;
Xorig = single(X(OffsetCheck+(1:NsamCheck)));
Xcheck = sys3read(Tag, NsamCheck, Dev, Offset+OffsetCheck, FormatString);
okay = isequal(Xorig, Xcheck);

function stat = local_WriteTag(actx, Tag, Offset, Form, X, NmaxChunk);
Nsam = numel(X); 
xoffset = 0:NmaxChunk:Nsam-1;
Nchunk = numel(xoffset);
for ichunk=1:Nchunk,
    i0 = xoffset(ichunk);
    i1 = min(i0+NmaxChunk, Nsam);
    if isempty(Form),
        stat = invoke(actx, 'WriteTagV', Tag, Offset+i0, X(1+i0:i1) );
    else,
        stat = invoke(actx, 'WriteTagVEX', Tag, Offset+i0, Form, X(1+i0:i1) );
    end
    if ~stat, return; end;
end






