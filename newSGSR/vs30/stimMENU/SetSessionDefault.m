function SetSessionDefault(Varname, Value);
% SetSessionDefault - set a session default variable
global SessionDefaults
eval(['SessionDefaults.' Varname '.Value = Value;'])
