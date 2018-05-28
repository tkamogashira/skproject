function S = construct(C, F)
%CONSTRUCT  create structure-array from a rectangular, flat cell-array.
%   S = CONSTRUCT(C, F) creates a structure-array S from the rectangular,
%   flat cell-array C containing the data. C must have the same number of
%   rows as their are elements in the structure array. The number of columns
%   must be equal to the total number of leaves in the tree of fieldnames.
%   F is a cell-array of strings containing the expanded fieldnames of S, so
%   each field should have the form <SuperField>.<SuperField>. ...<Field>.

%B. Van de Sande 25-04-2005

%Checking input arguments ...
if (nargin ~= 2) || ~iscell(C) || ~iscellstr(F) || (size(C, 2) ~= length(F))
    error('Wrong input arguments.'); 
end

%Special case if empty structure-array has to be returned ...
if isempty(C)
    S = struct([]);
    return
end

%Transforming cell-array of fieldnames to a one-dimensional structure and
%creating map of fieldnames ...
MaxNBranches = max(sum(ismember(char(F), '.'), 2)) + 1;
NLeaves = length(F);
FieldMap = repmat({''}, NLeaves, MaxNBranches);
FieldLayout = [];
for n = 1:NLeaves
    Path = Words2cell(F{n}, '.');
    NEntries = length(Path);
    FieldMap(n, 1:NEntries) = Path;
    FieldLayout = setfield(FieldLayout, Path{:}, NaN);
end

%Expanding one-dimensional structure ...
NBranches = size(FieldMap, 2);
for nBranch = (NBranches-1):-1:1
    SuperFields = unique(MergeFNames( ...
        FieldMap(~cellfun('isempty', FieldMap(:, nBranch)), 1:nBranch)));
    NSuperFields = length(SuperFields);
    ExcIdx = [];
    for n = 1:NSuperFields
        idx = find(ismember(MergeFNames(FieldMap(:, 1:nBranch)), SuperFields{n}));
        if ~any(cellfun('isempty', FieldMap(idx, nBranch+1)))
            Args = num2cell(cell2struct(C(:, idx), FieldMap(idx, nBranch+1), 2));
            [C{:, min(idx)}] = deal(Args{:});
            ExcIdx = [ExcIdx; setdiff(idx(:), min(idx))];
        end
    end
    FieldMap(:, nBranch+1) = [];
    FieldMap(ExcIdx, :) = [];
    C(:, ExcIdx) = [];
end
S = cell2struct(C, FieldMap, 2); %Return structure-array ...

%-----------------------------------------------------------------------
function FNames = MergeFNames(FieldMap)

[Nr, Nc] = size(FieldMap);
Sep = repmat('.', Nr, 1); 
FNames = [];
for n = 1:(Nc-1)
    FNames = [FNames, char(FieldMap(:, n)), Sep];
end
FNames = Str2FNames([FNames, char(FieldMap(:, Nc))]);

%-----------------------------------------------------------------------
function FN = Str2FNames(Str)

Str = [Str, repmat(sprintf('\n'), size(Str, 1), 1)]';
Str(Str == ' ') = [];
FN = strread(Str, '%s', 'delimiter', '\n')';

%-----------------------------------------------------------------------