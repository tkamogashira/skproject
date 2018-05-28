function boolean = isRAPStatDef(RAPStat, FieldName) %#ok
%isRAPStatDef   checks if RAP status field is set to its default
%   boolean = isRAPStatDef(RAPStat, FieldName)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-10-2003

DefValue = ManageRAPStatus(FieldName);
SetValue = eval(['RAPStat.' FieldName]);

boolean = isequal(SetValue, DefValue);
