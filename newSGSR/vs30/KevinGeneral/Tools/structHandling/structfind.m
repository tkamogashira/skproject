function rowsOk = structfind(inStruct, querry)
% STRUCTFIND - Find rows in a structure
%
%  rowsOk = structfind(inStruct, querry)
%
%  inStruct: a structure array being querried
%    querry: the condition the rows looked for need to fulfil

%% Check arguments
if isequal( 0, nargin )
    help structfind
    return;
elseif ~isequal( 2, nargin )
    error([mfilename ' expects exactly two arguments.']);
end
if ~isstruct(inStruct)
    error('First argument to structfind should be a structure array.');
end
if ~ischar(querry)
    error('Second argument to structfind should be a querry string.');
end
    
%% Run querry
rowsOk = [];
for cRow = 1:length(inStruct)
    rowOk = eval(parseExpression(querry, 'inStruct(cRow)'));
    if rowOk
        rowsOk = [rowsOk; cRow];
    end
end