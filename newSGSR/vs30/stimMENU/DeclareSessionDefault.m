function DeclareSessionDefaults(VarName, MenuName, EditName);
% DeclareSessionDefault - add param of specified menu to session defaults
global SessionDefaults

if nargin==1,
   if isequal(VarName,'reset'),
      SessionDefaults = [];
      return
   end
end

if ~isfield(SessionDefaults, VarName),
   Value = []; Members = [];
   SessionDefaults = setfield(SessionDefaults, VarName, CollectInStruct(Value, Members));
end

Item = CollectInStruct(MenuName, EditName);
MfieldNam = ['SessionDefaults.' VarName '.Members'];
eval(['oldList = ' MfieldNam ';']);
newList = [oldList, Item];
eval([MfieldNam '= newList;']);
