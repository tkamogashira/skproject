function IP = isPDP11compatible(X)

if isstruct(X)
   IP = ~isfield(X.GlobalInfo,'nonPDP11');
elseif ischar(X)
   X = upper(X);
   [dummy, OldNames] = IDFstimname(0);
   IP = 0;
   for ii=1:length(OldNames),
      nn = upper(OldNames{ii});
      IP = IP | isequal(X,nn);
   end
else
   error('wrong type of arg');
end

