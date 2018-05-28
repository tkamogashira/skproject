function ItemList = ListSessionDefaults(MenuName, getValues);
% ListSessionDefaults - returns list menudefaults for given menu name
if nargin<2, getValues=0; end

ItemList = [];
global SessionDefaults
DefVars = fieldnames(SessionDefaults);
for ii=1:length(DefVars);
   VarName = DefVars{ii};
   qqq = getfield(SessionDefaults, VarName);
   for jj=1:length(qqq.Members),
      item = qqq.Members(jj);
      if isequal(item.MenuName,MenuName),
         if getValues,
            EditName = item.EditName;
            Value = num2str(qqq.Value);
            if ~isempty(Value),
               ItemList = [ItemList, CollectInStruct(EditName, Value)];
            end
         else,
            EditName = item.EditName;
            ItemList = [ItemList, CollectInStruct(EditName, VarName)];
         end
      end
   end
end