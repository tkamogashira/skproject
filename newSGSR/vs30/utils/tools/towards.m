function towards(mfilename);

% function towards(mfilename) - cd to dir where mfile resides
% windows style pathNames

ffn = which(mfilename);
if isempty(ffn),
   disp([mfilename ' not found']);
end

lastBackslash = max(findstr('\', ffn));
if isempty(lastBackslash), return; end;
thedir = ffn(1:(lastBackslash-1));
cd(thedir);
cd

