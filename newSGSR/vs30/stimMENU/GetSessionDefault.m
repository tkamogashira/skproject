function X = GetSessionDefault(Varname);
% GetSessionDefault - get a session default variable
global SessionDefaults
eval(['X = SessionDefaults.' Varname '.Value;'])
