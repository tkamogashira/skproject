function X = sys3doubleBufRead(itrig, DataTag, IndexTag, N, Dev, Form, SizeTag);  
% sys3doubleBufRead - read data from circuit buffer using double-buffering
%   sys3doubleBufRead(itrig, DataTag, IndexTag, N, Dev) sends software 
%   trigger itrig to the circuit running on device Dev, and proceeds to 
%   read data from a Buffer component in the circuit. A column array X 
%   containing N samples is read from the buffer. The buffer component 
%   must have two tags pointing to it: DataTag points to the DATA entry; 
%   IndexTag points to the Index entry of the buffer. Once the trigger is
%   given, the circuit must fill the buffer in a cyclic way, i.e. it starts
%   from the 1st sample when the buffer is full. itrig==0 skips the
%   triggering. itrig<0 also skips the triggering and moreover allows
%   interruption during the sys3wait call.
%  
%   sys3doubleBufRead(itrig, DataTag, IndexTag, N, Dev, Form) reads
%   data in format indicated by char string Form. See sys3read for details.
%  
%   sys3doubleBufRead(itrig, DataTag, IndexTag, N, Dev, Form, SizeTag)
%   takes the buffer size via SizeTag, rather than via DataTag. Useful
%   when dynamic buffer sizes are used.
%
%   Note. The double buffering works as follows.
%   Let S be the Buffer size. Sys3doubleBufRead waits until the Buffer
%   is half full, i.e., until Index (the value read from IndexTag) has 
%   reached S/2. Once the buffer is half full, the first half is read.
%   Sys3doubleBufRead then waits until the Buffer is full (Index jumps 
%   back to value <S/2) and reads the second half, etc, untill N points
%   have been read. Note that it is may be crucial to start the circuit by 
%   a trigger; the slow loading of the mfile may well cause it to miss the 
%   first few halves.
%
%   See also sys3write, sys3getpar, sys3partag.  


if nargin<5, Dev = ''; end;  
if nargin<6 || isempty(Form), Form = 'F32'; end;  
if ischar(N), % read from counter index
   N = sys3getpar(N, Dev);
end

% X = sys3doubleBufRead(itrig, DataTag, IndexTag, N, Dev, Form);  

error(sys3unloadedError(Dev));

% check Tags
if ~isequal('DataBuffer', sys3partag(Dev, DataTag, 'DataType')),
    error(['ParTag ''' DataTag ''' does not point to a data buffer.']);
end
% get buflen and compute half lengths
if nargin < 7
    BufLen = sys3partag(Dev, DataTag, 'TagSize');
else
    BufLen = sys3getpar(SizeTag, Dev);
end

M1 = round(BufLen/2); % length of first half of buffer
M2 = BufLen-M1; % length of second half of buffer

if ~isequal('Integer', sys3partag(Dev, IndexTag, 'DataType')),
    error(['ParTag ''' IndexTag ''' does not point to an integer-valued parameter.']);
end
% allocate memory for X
X = zeros(1,N); 

% make sure circuit runs & kick it
if ~sys3status(Dev,'Running'),
    sys3run(Dev);
end
if itrig>0, 
    sys3trig(itrig); 
end

BufDur = BufLen/sys3Fsam(Dev); % buffer dur in ms
TimeOut = max(10, 1e3*BufDur); % s
%-------now the fun starts-----
Offset = 0;
while Offset<N,
    if itrig<0, drawnow; end % allow interrupts to interfere
    % wait for first half to be filled & read it out
    if sys3getpar(IndexTag, Dev)>M1, warning('Too slow1; increase buffer size.'); end
    sys3waitfor(IndexTag,'>', min(M1,N), Dev, TimeOut);
    X(Offset+[1:M1]) = sys3read(DataTag, M1, Dev, 0, Form);
    Offset = Offset + M1;
    if Offset>=N, break; end
    if itrig<0, drawnow; end % allow interrupts to interfere
    % wait for second half to be filled & read it out
    if sys3getpar(IndexTag, Dev)<min(M1,N), warning('Too slow2; increase buffer size.'); end
    sys3waitfor(IndexTag,'<', M1, Dev, TimeOut);
    X(Offset+[1:M2]) = sys3read(DataTag, M2, Dev, M1, Form);
    Offset = Offset + M2;
end
X = X(1:N);
X = X(:); % col array








