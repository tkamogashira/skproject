function itdoes = StrEndsWith(str,postfix);
% StrEndsWith - test if last part of string equals a test string
%   StrEndsWith(S,T) returns true if teh string S is of the
%   form S = [X T].
%   Examples: 
%      StrEndsWith('last but bot least', 'least') is true;
%      StrEndsWith('last but bot least', 'last') is false.
%
%   S may be cellstring:
%   StrEndsWith({S1 S2 ..}, T) returns [StrEndsWith(S1,T) StrEndsWith(S2,T) ...]

if iscellstr(str),
   itdoes = [];
   for ii=1:length(str),
      itdoes = [itdoes StrEndsWith(str{ii},postfix);];
   end
   return
end
N = length(str);
M = length(postfix);
finalPos = max(findstr(str,postfix));
itdoes = isequal(finalPos,N-M+1);
