function S = structaggregate(varargin)
%STRUCTAGGREGATE    grouping and aggregational functions on structure-arrays.
%   S = STRUCTAGGREGATE(S, AggrFncs) apply the supplied aggregational functions
%   to the structure array S. An aggregational function can be supplied as a 
%   character string or a cell array of string if multiple aggregational 
%   functions need to be applied to S. An aggregational function is given
%   as a MATLAB expression. Fieldnames in these expressions must be enclosed
%   between dollar signs and for branched structures fieldnames can be given
%   using the dot as a fieldname separator.
%   S = STRUCTAGGREGATE(S, AggrFncs, GroupFields) first groups the rows of S
%   according to the list of fieldnames to group by (supplied as a character
%   string of a cell-array of strings) and applies the aggregational functions
%   to each different group.
%   S = STRUCTAGGREGATE(S, AggrFncs, GroupFields, GroupIntervals) group S by
%   the supplied fieldnames using the intervals supplied in GroupIntervals.
%   Intervals can be supplied as rowvectors or as matrices with two columns
%   if the intervals are not adjacent. The intervals are considered closed to
%   the left, but open to the right. If more than one grouping fieldname is
%   supplied then intervals must be specified as a cell-array with numerical
%   matrices. An empty matrix as intervals for a given grouping fieldname 
%   designates grouping by unique values for that fieldname.
%
%   E.g.:
%       S = struct('field1', {2,2,1,1,1,1}, 'field2', {3,3,4,4,3,3}, ...
%               'field3', num2cell(1:6));
%       S = structaggregate(S, {'mean($field3$)', 'sum($field3$)', ...
%           'length($field3$)'}, {'field1', 'field2'});
%   E.g.:
%       S = serverquest('strcmpi($ID.SchName$, ''NRHO'')', ...
%           'outfields', {'ID.FileName', 'ID.iSeq', 'ID.iCell', 'Common.SPL', 'Common.ITD'});
%       S = structaggregate(S, {'length($ID.iCell$)', 'min($Common.ITD$)'}, ...
%           'Common.SPL', [30 50 70 90], 'aggrfnames', {'NrOfCells', 'MinITD'})
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 26-07-2005

%---------------------------default parameters--------------------------------
%Fieldnames for columns of aggregate functions in resulting structure-array. If
%the value is empty, the default name is given to each column ...
DefParam.aggrfnames = {};
%Expression specifying the value for each grouping interval in the resulting 
%structure-array. The value of this property must be a character string or a 
%cell-array of strings when a different expression for every grouping fieldname
%is wanted. The empty string designates the default value, i.e. a two element
%rowvector specifying beginning and end of the interval. When specifying an
%expression the name of any field in the resulting table can be used (enclosed
%between dollar signs). The values of the grouping field is returned as a single
%N by 2 matrix of grouping is performed by supplied intervals, otherwise a single
%columnvector is returned. The MATLAB expression should transform this to a N by 1
%matrix ...
%E.g.: 'diff($GroupFieldName$, 1, 2)' or 'mean($GroupFieldName$, 2)' (Replace Group-
%FieldName with the appropriate fieldname ...
DefParam.intexpr = '';

%------------------------------main program-----------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    if (nargout == 0), disp('Properties and their factory defaults:'); disp(DefParam);
    else, ArgOut = DefParam; end
    return;
else, [Data, FieldNames, Param] = ParseArgs(DefParam, varargin{:}); end

%Grouping ...
if ~isempty(Param.groupfnames),
    N = length(Param.groupfnames); ColumnIdx = zeros(1, N);
    for n = 1:N, ColumnIdx(n) = find(ismember(FieldNames, Param.groupfnames{n})); end
    [GroupData, GroupIdx] = findgroups(Data(:, ColumnIdx), Param.groupintervals);
    NGroups = length(GroupIdx);
else,
    GroupIdx{1} = 1:size(Data, 1); GroupData = {};
    NGroups = 1;
end

%Apply aggregate functions per group ...
NFncs = prod(size(Param.aggrfncs));
ResultData = repmat({[]}, NGroups, NFncs); %Pre-allocation ...
for g = 1:NGroups, for f = 1:NFncs,
    ResultData{g, f} = EvalExpr(Param.aggrfncs{f}, Data(GroupIdx{g} , :)); 
end; end
ResultData(find(cellfun('isclass', ResultData, 'cell') & cellfun('isempty', ResultData))) = {[]};
ResultData = [GroupData, ResultData];
ResultFNames = [Param.groupfnames, Param.aggrfnames];
if ~isempty(Param.intexpr),
    NGroupFNs = length(Param.groupfnames);
    for n = 1:NGroupFNs, 
        Value = EvalExpr(Param.intexpr{n}, ResultData);
        if isnumeric(Value), ResultData(:, n) = num2cell(Value, 2); 
        else ResultData(:, n) = Value; end    
    end
end

%Assemble resulting structure array ...
S = construct(ResultData, ResultFNames);

%----------------------------local functions----------------------------------
function [Data, FieldNames, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
NArgs = length(varargin); if (NArgs < 2), error('Wrong number of input arguments.'); end
if ~isstruct(varargin{1}), error('First argument should be structure array.'); end
[Data, FieldNames] = destruct(varargin{1});
if ~ischar(varargin{2}) & ~iscellstr(varargin{2}), 
    error('Second argument should be character string or cellarray of strings.'); 
end
AggrFncs = cellstr(varargin{2}); NAggrFncs = prod(size(AggrFncs));
for n = 1:NAggrFncs, AggrFncs{n} = ParseExpr(AggrFncs{n}, FieldNames); end
if (NArgs >= 4) & ((ischar(varargin{3}) & ~ismember(varargin{3}, fieldnames(DefParam))) | iscellstr(varargin{3})) & ...
    (isnumeric(varargin{4}) | iscell(varargin{4})),
    GroupFNames = cellstr(varargin{3}); NGroups = length(GroupFNames);
    if ~all(ismember(GroupFNames, FieldNames)), error(sprintf('The field ''%s'' to group by doesn''t exist.', GroupFNames{1})); end
    if isnumeric(varargin{4}), GroupIntervals = varargin(4);
    else, GroupIntervals = varargin{4}; end
    NIntervals = length(GroupIntervals);
    if (NIntervals ~= NGroups), error('Number of supplied intervals should be equal to the number of supplied grouping fieldnames.'); end
    for n = 1:NIntervals,
        if (size(GroupIntervals{n}, 1) == 1) & (size(GroupIntervals{n}, 2) ~= 0), %Also applicable to two-element rowvectors ...
            N = length(GroupIntervals{n});
            GroupIntervals{n} = reshape(mmrepeat(GroupIntervals{n}, [1, repmat(2, 1, N-2), 1]), 2, (2*(N-2)+2)/2)';
        elseif ~(size(GroupIntervals{n}, 1) ~= 0) & (size(GroupIntervals{n}, 2) == 2) & ~isempty(GroupIntervals{n}),
            error('Invalid format for grouping intervals.'); 
        end
    end    
    ParamIdx = 5;
elseif (NArgs >= 3) & ((ischar(varargin{3}) & ~ismember(varargin{3}, fieldnames(DefParam)))| iscellstr(varargin{3})),
    GroupFNames = cellstr(varargin{3}); NGroups = length(GroupFNames);
    GroupIntervals = repmat({[]}, 1, NGroups);
    if ~all(ismember(GroupFNames, FieldNames)), error('One of the fields to group by doesn''t exist.'); end
    ParamIdx = 4;
else,
    [GroupFNames, GroupIntervals] = deal({}); %Must be empty cell-array ...
    ParamIdx = 3; NGroups = 0;
end

%Checking properties and their values ...
Param = CheckPropList(DefParam, varargin{ParamIdx:end});
if isempty(Param.aggrfnames),
    Param.aggrfnames = cellstr([repmat('aggr', NAggrFncs, 1), num2str((1:NAggrFncs)')])';
elseif ischar(Param.aggrfnames) & (NAggrFncs == 1), Param.aggrfnames = cellstr(Param.aggrfnames);
elseif ~iscellstr(Param.aggrfnames) | (length(Param.aggrfnames) ~= NAggrFncs),   
    error('Property ''aggrfnames'' must be character string or cell-array of strings with same number of elements as aggregational functions.');
end
if isempty(Param.aggrfnames),
    Param.aggrfnames = cellstr([repmat('aggr', NAggrFncs, 1), num2str((1:NAggrFncs)')])';
elseif ischar(Param.aggrfnames) & (NAggrFncs == 1), Param.aggrfnames = cellstr(Param.aggrfnames);
elseif ~iscellstr(Param.aggrfnames) | (length(Param.aggrfnames) ~= NAggrFncs),   
    error('Property ''aggrfnames'' must be character string or cell-array of strings with same number of elements as aggregational functions.');
end
if ischar(Param.intexpr), Param.intexpr = repmat({Param.intexpr}, 1, NGroups);
elseif iscellstr(Param.intexpr) & (length(Param.intexpr) == 1), Param.intexpr = repmat(Param.intexpr, 1, NGroups);
elseif ~iscellstr(Param.intexpr) | (length(Param.intexpr) ~= NGroups),
    error('Property ''intexpr'' must be character string or a cell-array of strings with the same number of elements as grouping fieldnames.');
end
ResultFNames = [GroupFNames, Param.aggrfnames];
for n = 1:NGroups,
    if isempty(Param.intexpr{n}), Param.intexpr{n} = {n};
    else, Param.intexpr{n} = ParseExpr(Param.intexpr{n}, ResultFNames); end
end

%Adding additional parameters to the Param structure for convenience ...
Param.aggrfncs       = AggrFncs;
Param.groupfnames    = GroupFNames;
Param.groupintervals = GroupIntervals;

%-----------------------------------------------------------------------------