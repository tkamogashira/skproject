function s = AlignStr(s, Pos, cflag);
% ALIGNSTR - horizontal alignment of strings 
%    ALIGNSTR(S,POS) is a string derived from string S in the
%    following way.
%    The first character of S is removed from S and the second
%    occurence of this same character is located. Let us call this
%    positition M. Then this second occurence is also removed
%    from the S.
%    Next, POS-M spaces are prepended to the string.
%    
%    EXAMPLE
%    The following commands:
%    
%    disp(Alignstr('*today*: sunday', 10));
%    disp(Alignstr('*tomorrow*: monday', 10));
%
%    together produce the output
%
%          today: sunday
%       tomorrow: monday
%
%    Note that the asterisks in the input string are removed in the
%    return string. They only serve as temporary flags.
%    
%    If no second occurence of the flag char is found in S, AlignStr 
%    behaves as if the second flag char is appended to S.
%    If POS is smaller than the position of the second flag char,
%    then S is truncated from the left in order to realize alignment.
%    Negative values for POS are allowed; they wil always result in truncation.
%
%    ALIGNSTR(S,POS,CFLAG) works without an extra, prepended; instead CFLAG
%    is a character in S that is aligned to position POS. If it is absent in S, 
%    ALIGNSTR behaves as if C is appended to S.
%
%    For string matrices, ALIGNSTR works in a row-by-row manner.
%
%    See also STRVCAT, STRJUST.
error(nargchk(2,3,nargin));
if ~ischar(s), error('First argument must be string.'); end;
error(CRNmess(Pos, nan,'position'));
if isempty(s), return; end;
if nargin<3, cflag=''; 
else,
   if (~ischar(cflag) | length(cflag)>1), 
      error('CFLAG argument must be single character or ''''.'); 
   end;
end;

nLine = size(s,1);
if nLine>1, % recursive call
   tmp = '';
   for ii=1:nLine,
      tmp = strvcat(tmp, alignstr(s(ii,:),Pos, cflag));
   end
   s = tmp;
   return;
end

% single, non-empty line from here
extflag = ~isempty(cflag);
if ~extflag, % get flag from s
   cflag = s(1);
   s = s(2:end);
end
aPos = min(find(s==cflag)); % 2nd occurence of cflag
if isempty(aPos), aPos=length(s)+1; 
elseif ~extflag, s(aPos) = ''; % remove 2nd occurence
end;
if Pos>=aPos, % pad blanks
   s = [blanks(Pos-aPos) s];
else, % truncate
   s = s((aPos-Pos+1):end);
end








