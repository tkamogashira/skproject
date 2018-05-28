function RetrieveSessionDefaults(MenuName, hh);
% RetrieveSessionDefaults - retrieve session defaults and put in current menu
items = listSessionDefaults(MenuName,1); % values, not names
for item=items,
   h = getfield(hh, item.EditName);
   setstring(h, item.Value);
end



