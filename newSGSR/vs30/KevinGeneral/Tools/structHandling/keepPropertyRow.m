function structOut = keepPropertyRow( structIn, keepRows )
% KEEPPROPERTYROW Deletes rows from the leafs of the given structure
%
% structOut = keepPropertyRow( structIn, keepRows )
% Goes through the leafs of structIn; if a leaf is a column cell array, all
% rows not given in keepRows are deleted.
%
%  structIn: The structure being edited. Leafs should be scalars, strings,
%            or column cell arrays; only in the latter case, an action is
%            taken.
%   keepRows: The rows being kept.
% 
% Returns: a new structure, with only the given rows

% Created by: Kevin Spiritus
% Last edited: January 5th, 2007

%% Check args
if ~isequal( 2, nargin )
    error('Function expects 2 arguments.');
end

if ~isstruct(structIn) || ~isnumeric( keepRows )
    error('Wrong type of arguments');
end

%% Remove rows from each leaf
structOut = structIn;
structFields = fieldnames(structIn);
% loop through the top fields of structIn
for i = 1:length(structFields)
    studiedField = structIn.(structFields{i});
    if iscell(studiedField)
        numCols = size(studiedField, 2 );
        if ~isequal(1, numCols)
            error('Only columns are supported for the leafs.');
        end
        % delete the rows
        structOut.(structFields{i}) = {studiedField{keepRows}}';
    elseif isstruct(studiedField)
        %recurse
        structOut.(structFields{i}) = keepPropertyRow(studiedField, keepRows );
    elseif ~( isequal([1 1], size(studiedField)) || ischar(studiedField) || isempty(studiedField) )
        error('Leafs should be cell arrays.');
    else
        % Field is not a cell, not a struct, and either it's empty, it's size is [1,1]
        % or it's a string. In this case, we undertake no action.
    end    
end