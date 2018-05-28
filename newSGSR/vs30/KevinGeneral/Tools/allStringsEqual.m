function result = allStringsEqual(strCell)
% ALLSTREQUAL Checks if all strings in given cell aray are equal
%
% result = allStrEqual(strCell)
%  returns 1 if all equal, 0 if not
%
% Arguments:
%  strCell: a cell array of strings

%% check params; use the first entry as control string
ctrlString = strCell{1};
if ~iscell(strCell) | ~ischar(ctrlString) %#ok<OR2>
    errorArg;
end

%% compare all other strings to the control string
result = 1;
for i = 2:numel(strCell)
    if ~ischar(strCell{i})
        errorArg;
    end
    if ~isequal(ctrlString, strCell{i})
        result = 0;
        return;
    end
end
    
%% error when arguments are not ok
function errorArg
    error('argument should be cell array of strings');