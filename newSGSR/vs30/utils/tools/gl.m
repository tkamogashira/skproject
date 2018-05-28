% utility scribt GL makes the set of important global viables
% accessible from workspace

q________q = who('global');
for ii=1:length(q________q),
   eval(['global ' q________q{ii}]);
end
clear q________q;