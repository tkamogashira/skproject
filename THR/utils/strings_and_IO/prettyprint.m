function str = prettyprint(C, MinColwidth, MaxColwidth, MaxWidth, MinSepa);
% prettyprint - display cellstring as table
%   prettyprint(C) prettyprints cellstring C as a table.
%   
%   prettyprint(C, MinColwidth, MaxColwidth, MaxWidth, MinSepa)
%   applies user-specified value for:
%         minimum column width (default 8)
%         max column width (default 27)
%         max total width (default 81)
%         minimum separation between coumn (default 2)
%
%   str = prettyprint(C) returns the table in char string str.
%
%   See also cell2chararray.

if ~iscellstr(C),
   error('Argument C is not a cell array of strings. See ISCELLSTR.')
end

if nargin<2, MinColwidth = 8; end; % min column width
if nargin<3, MaxColwidth = 27; end; % min column width
if nargin<4, MaxWidth = 81; end; % max total width
if nargin<5, MinSepa = 2; end; % minimum # blanks between items

C= deblank(C(:));
N = length(C);

if N>0,
   Len = GenericCellFun(@length, C);
   Len = [Len{:}]; % vector of word lengths
   maxLen = max(Len); 
   
   % determine column width by clipping maxLen+MinSepa between ColWidth extremes
   ColWidth = min(MaxColwidth, max(MinColwidth, maxLen+MinSepa));
   Ncol = floor(MaxWidth/ColWidth);
   Width = Ncol*ColWidth;
end


str = '';
offset = 0; % current horizontal position 
for ii=1:N,
   c = C{ii};
   rspace = Width-offset; % available space on this line
   L = Len(ii); % length of current word
   if (L>rspace) & (offset>0), % oversized - start new line
      [str, offset, rspace] = localAppendBlank(str, offset, Width, Width);
   end
   ncol = ceil((L+1)/ColWidth); % # columns needed
   endpos = offset+ncol*ColWidth; % target position is end of some column
   str = [str c]; offset = offset+L; % write word
   [str, offset, rspace] = localAppendBlank(str, offset, endpos, Width);
end

if nargout<1,
   disp(' ')
   disp(str)
   disp(' ')
   clear str
end

%====================
function [str, offset, rspace] = localAppendBlank(str, offset, endpos, Width);
endpos = min(endpos, Width); % will not write past max Width
n = endpos-offset; % # added blanks
n = max(0,n); % cannot add negative # blanks
str = [str blanks(n)];
offset = offset + n;
needNWL = endpos>=Width;
if needNWL,
   str = [str char(10)];
   offset = 0;
end
rspace = Width-offset;



