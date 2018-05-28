function structOut = deletePropertyRow( structIn, numRow )
% DELETEPROPERTYROW Deletes a row from the leafs of the given structure
% 
% structOut = deletePropertyRow( structIn, numRow )
% Goes through the leafs of structIn; if a leaf is a column cell array, the
% given row is deleted.
% 
%  structIn: The structure being edited. Leafs should be scalars, strings,
%            or column cell arrays; only in the latter case, an action is
%            taken.
%    numRow: The row being deleted.
% 
% Returns: a new struct, without the given row
% 
% Example:
%     A.a = 17
%     A = 
%         a: 17
%     A.b = {1; 5; 17; 19; 20}
%     A = 
%         a: 17
%         b: {5x1 cell}
%     B = deletePropertyRow(A, 3)
%     B = 
%         a: 17
%         b: {4x1 cell}
%     B.b
%     ans = 
%         [ 1]
%         [ 5]
%         [19]
%         [20]

% Created by: Kevin Spiritus
% Last edited: January 5th, 2007

%% Check args
if ~isequal( 2, nargin )
    error('Function expects 2 arguments.');
end

if ~isstruct(structIn) || ~isequal( 0, mod(numRow, 1) ) || (numRow <= 0)
    error('Wrong type of arguments');
end

%% Remove the row from each leaf
structOut = structIn;
structFields = fieldnames(structIn);
% loop through the top fields of structIn
for i = 1:length(structFields)
    studiedField =  structIn.(structFields{i});
    if iscell( studiedField )
        numRows = size( studiedField, 1 );
        numCols = size( studiedField, 2 );
        if numRows < numRow
            error('Deletion failed: row does not exist.');
        end
        if ~isequal(1, numCols)
            error('Only columns are supported for the leafs.');
        end
        % delete the row
        keepPos = [1:numRow-1, numRow+1:numRows];
        structOut.(structFields{i}) = {studiedField{keepPos}}';
    elseif isstruct( studiedField )
        %recurse
        structOut.(structFields{i}) = deletePropertyRow( studiedField, numRow );
    elseif ~ ( isequal([1 1], size(studiedField)) || ischar(studiedField) || isempty(studiedField) )
        error('Leafs should be cell arrays.');
    else
        % Field is not a cell, not a struct, and either it's empty, it's size is [1,1]
        % or it's a string. In this case, we undertake no action.
    end    
end