function dir = RemoveLastSlash(aDir);

% remove trailing slash returned by path parameters
% as used by Windows shit like uiputfile

nn = length(aDir);
if nn>1,
   if aDir(nn)=='\',
      dir = aDir(1:nn-1);
   else
      dir = aDir;
   end
else,
   dir = '';
end

   