function ls=StrLeftLim(s,n);

% function ls=StrLeftLim(s,n); XXX help comment

nn= length(s);
if nn<=n,
   ls = s;
elseif n>2,
   ls = ['..' s((nn-n+3):nn)];
elseif n>1,
   ls = '..';
elseif n==1,
   ls = '.';
else,
   ls = '';
end




