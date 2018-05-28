function se = StripError(s);
% STRIPERROR - strips first line from error message so that it can be fed to ERROR again
%   usage: error(stripError(lasterr)) in error trapping


while(s(end)==char(10)),
   s=s(1:end-1);
end

RET = find(s==char(10))+1;
if isempty(RET),
   se = s;
else,
   se = s(RET:end);
end

