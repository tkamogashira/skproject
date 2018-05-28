function Name = ParsePropertyName(Input)
%PARSEPROPERTYNAME  parse the name of a property.
%   Name = PARSEPROPERTYNAME(Name)
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 06-05-2004

if ~ischar(Input), error('First argument should be name of property to add.'); 
else, Name = lower(Input); end