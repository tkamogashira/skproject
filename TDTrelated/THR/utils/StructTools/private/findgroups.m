function [Gint, Gidx] = FindGroups(Data, IntForColumn)

%B. Van de Sande 11-08-2005

Gidx = FindGroupsRec(Data, IntForColumn, 1, {(1:size(Data, 1))'}, 1);
Gint = FindIntervalsForGroups(Data, IntForColumn, Gidx);

%----------------------------local functions----------------------------------
function [Gidx, NextGroupNr] = FindGroupsRec(Data, IntForColumn, ColumnNr, ...
    Gidx, GroupNr)

%Extract fragment to group ...
Fragment  = Data(Gidx{GroupNr}, ColumnNr); Intervals = IntForColumn{ColumnNr};
if all(cellfun('isclass', Fragment, 'double')) & all(ismember(cellfun('size', Fragment, 1), [0, 1])) & ...
    (length(setdiff(unique(cellfun('size', Fragment, 2)), 0)) == 1), 
    Fragment = cat(1, Fragment{:});
elseif ~all(cellfun('isclass', Fragment, 'char')),
    error('Only fieldnames with numeric or character string values can be grouped.'); 
elseif ~isempty(Intervals),
    error('Fieldnames with character string values cannot be grouped by intervals.'); 
end

%Find the offset in index for the groups in this fragment and the number of
%elements in this fragment ...
IdxOffSet = min(Gidx{GroupNr}) - 1; NElem = prod(size(Fragment));

%If no intervals are specified for the current column, then the unique values
%in the fragment are searched for ...
if isempty(Intervals),
    %Group this fragment using UNIQUE.M ...
    [dummy, dummy, idx] = unique(Fragment); NFragGroups = length(unique(idx)); 
    FragGidx = repmat({[]}, NFragGroups, 1);
    for n = 1:NFragGroups, FragGidx{n} = IdxOffSet + find(idx == n); end
else,
    NFragGroups = size(Intervals, 1); FragGidx = repmat({[]}, NFragGroups, 1);
    for n = 1:NFragGroups,
        FragGidx{n} = IdxOffSet + find((Fragment >= Intervals(n, 1)) & (Fragment < Intervals(n, 2)));
    end
    idxEmpty = find(cellfun('isempty', FragGidx)); FragGidx(idxEmpty) = [];
end

%Find groupings for the groups in this fragment using recursion ...
NColumns = size(Data, 2);
if (ColumnNr < NColumns),
    FragGroupNr = 1;
    while (FragGroupNr <= length(FragGidx)),
        [FragGidx, FragGroupNr] = FindGroupsRec(Data, IntForColumn, ColumnNr+1, ...
            FragGidx, FragGroupNr);
    end
end
NextGroupNr = GroupNr + length(FragGidx);
Gidx = [Gidx(1:GroupNr-1); FragGidx; Gidx(GroupNr+1:end)];

%-----------------------------------------------------------------------------
function Gint = FindIntervalsForGroups(Data, IntForColumn, Gidx)

NGroups = length(Gidx); NColumns = size(Data, 2);
Gint = cell(NGroups, NColumns); %Pre-allocation ...
for ColNr = 1:NColumns, for GrpNr = 1:NGroups,
    if isempty(IntForColumn{ColNr}), Gint{GrpNr, ColNr} = Data{Gidx{GrpNr}(1), ColNr};
    else,
        Value = Data{Gidx{GrpNr}(1), ColNr};
        idx = find((Value >= IntForColumn{ColNr}(:, 1)) & (Value < IntForColumn{ColNr}(:, 2)));
        Gint{GrpNr, ColNr} = IntForColumn{ColNr}(idx, :);
    end    
end; end;

%-----------------------------------------------------------------------------