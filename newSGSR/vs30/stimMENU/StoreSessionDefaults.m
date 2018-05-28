function StoreSessionDefaults(MenuName);
% StoreSessionDefaults - find session defaults of current menu and store them
items = listSessionDefaults(MenuName); % names, not values
for item=items,
   curVal = getstring(getfield(stimmenuhandles, item.EditName));
   curVal = strtok(curVal);
   setSessionDefault(item.VarName, curVal);
end



