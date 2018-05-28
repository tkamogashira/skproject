function ClassName = FixObjectFormat(ConstructorName);
% FixObjectFormat - ensure the consistency among different formats of a constructor call
%   FixObjectFormat(mfile) called from an object constructor foo/foo calls foo once with
%   no arguments, thereby setting a standard for the data format of foo.
%   Subsequent calls from the same constructor are ignored (this prevents endless recursion).
%
%   FixObjectFormat returns the classname as derived from mfile.
%
%   Use CLEAR ALL to change the data format.
%
%   See also Parameter.

Ob = nan; % see help
ClassName = strtok(ConstructorName,'/'); % note: this is robust against ver 6->7 change of mfilename
persistent ClassNameBAG
if isfield(ClassNameBAG, ClassName), return; end % has been called before, get out to avoid endless recursion

% create the fieldname of ClassNameBAG to avoid endless recursion
eval(['ClassNameBAG.' ClassName ' = 1;']);
%  perform an argless contructor call.
eval([ClassName ';']);


















