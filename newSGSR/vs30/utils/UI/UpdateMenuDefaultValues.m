function UpdateMenuDefaultValues(MenuName);

% menu-specific default values
DefaultValues = CollectMenuDefaultValues(MenuName);

MSname = MenuStatusName(MenuName);
eval(['global ' MSname]);
eval([MSname '.defaults = DefaultValues;']);

