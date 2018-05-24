function dp(S);
% DP - display structure in recursive  fashion
if ischar(S), % S is *name* of variable in caller workspace
   % pass S via temporary global variable
   evalin('caller','global StructToBeDisplayed');
   evalin('caller', ['StructToBeDisplayed = ' S ';']);
   global StructToBeDisplayed
   S = StructToBeDisplayed;
   evalin('caller', 'clear global StructToBeDisplayed;');
end
try % avoid errors due to quitting pager
   dispstruct(S);
end