% GL = declare all existing global variables in current workspace
%     GL declares in the current workspace all global variables 
%     that may have been declared within different scope. This makes these
%     variable accessible to the current workspace.
qq = who('global');
for ii=1:length(qq),
   eval(['global ' qq{ii}]);
end
