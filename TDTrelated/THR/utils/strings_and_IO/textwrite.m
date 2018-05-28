function Nb = textwrite(FN, txt, flag);
% textwrite - write text to text file
%   Nbyte = textwrite(FN, T) writes text T to file named FN.
%   Nbyte is the number of bytes successfully written.
%   
%   FN must be a full file name. If file FN already exists, the 
%   text will be appended. (see below for overwrite mode)
%
%   The text T can have one of the following text formats:
%
%       1xN char array: T is written "as is" to the text file, 
%                   including any newlines. A single newline is 
%                   appended to T if T does not end in one.
%       MxN char matrix: each row is a line. Trailing blanks of each
%                   line are removed and a newline is appended. 
%       cellstring: each element of T is a line. No trimming of trailing spaces.
%                   Use "textwrite(FN,deblank(T))" for trimming.
%
%   Independent of the format, an empty txt will not result in writing
%   anything to the file (not even a newline). Consequently, the file's
%   date will not be affected.
%   
%   Textwrite(FN, T, '-overwrite') overwrites any contents of an existing 
%   file FN instead of appending to it. Textwrite(FN, T, '-append') is the
%   same as Textwrite(FN, T).
%
% See also fprintf

% empty text: do nothing (see help text)
if nargin<3, flag= '-append'; end
switch lower(flag),
case '-append', openMode = 'at'; % append/text (see help fopen)
case '-overwrite', openMode = 'wt'; % write/text (see help fopen)
otherwise, error(['Invalid flag "' flag '".']);
end
   
if isempty(txt), return; end

NWL = char(10);

% convert different formats of text to single charstring  with newlines
if ischar(txt) & size(txt,1)==1, % single line of text
   % append newline if needed
   if ~isequal(NWL, txt(end)), txt = [txt NWL]; end
else, % cell str or char matrix
   if ischar(txt), % char matrix: first convert to cellstr
      txt = deblank(cellstr(txt)); % char matrix -> cell string; deblank each line
   end
   % at this point, txt has to be celstring. Check & complain if not.
   if ~iscellstr(txt); error('Input argument T must be char array, char matrix, or cellstring.'); end
   Nline = length(txt);
   % append newline to each element of the character string
   for iline=1:Nline, txt{iline} = [txt{iline} NWL]; end
   % concatenate into single string
   txt = [txt{:}];
end

% at this point the txt is a single string of characters with newlines. A simple fprintf will do the job.

% open file
[fid, mess] = fopen(FN, openMode); 
error(mess);
Nb = fprintf(fid, '%c', txt);
fclose(fid);













