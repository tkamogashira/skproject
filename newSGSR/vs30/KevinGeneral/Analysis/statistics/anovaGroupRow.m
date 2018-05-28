function [P, table, stats, terms, dataCol, groupCols] = anovaGroupRow(varargin)
% anovaGroupRow - Evaluate an N-way anova on a structure array
%
% Use:
%   anovaGroupRow(struct S, string DataCol, group1, group2, group3, ...)
%
%   The structure S is the struct array we work on. DataCol indicates which
%   column of this structure contains the data. All the next parameters
%   indicate different groupings of the data, used for the N-way anova. 
%
%   There are two ways to group the data:
%   * Indicate a column containing the group for each data element. In this
%     case, the parameter should be a string containing the column name.
%     The column should have as many elements as there are data elements.
%   * Indicate intervals to group the data. Intervals can be specified in
%     two-dimensional arrays in a cell array. 
%     E.g.: {[0,30], [30,60], [60,inf]}
%
%   Both methods can be used simultaneously.
%
% In case of a 2-way Anova, the parameters 'model', 'interaction' is used 
% for the 'anovan'.
%
% For more information, take a look at 'doc anovan'.

% read first two arguments
S = varargin{1};
if ~isstruct(S)
    error('First argument of anovaGroupRow should be a struct.');
end

dataColName = varargin{2};
if ~ischar(dataColName)
    error('Second argument of anovaGroupRow should be a string indicating the column with data.');
end
dataCol = retrieveField(S, dataColName);

if nargin < 3
    error('You forgot to specify group columns');
end

% next arguments indicate which columns contain group info
cArg = 3;
groupCols = {};
while cArg <= nargin
    groupColName = varargin{cArg};
    if ~ischar(groupColName)
        error('Names of grouping columns should be strings');
    end
    groupColData = retrieveField(S, groupColName);

    isInterval = 0;
    if cArg < nargin
        if iscell(varargin{cArg + 1})
            isInterval = 1;
            % next argument indicates intervals for this group
            groupIntervals = varargin{cArg + 1};
            groupCol = {};
            for cCol = 1:length(dataCol)
                % compare each value of the data to the group intervals and
                % classify
                foundInterval = 0;
                for cCell = 1:length(groupIntervals)
                    groupInterval = groupIntervals{cCell};
                    if ~isnumeric(groupInterval)
                        error('Intervals for the group intervals should be numeric.');
                    end
                    if groupColData(cCol) >= groupInterval(1) & groupColData(cCol) <= groupInterval(2)
                        groupCol{cCol} = ['[' num2str(groupInterval(1)) ',' num2str(groupInterval(2)) ']'];
                        foundInterval = 1;
                        break;
                    end
                end
                if isequal(0, foundInterval)
                    warning(['The value ' num2str(groupColData(cCol)) ' does not belong to any of the given intervals for group ' groupColName '.']); %#ok<WNTAG>
                    groupCol{cCol} = 'NO INTERVAL';
                end
            end
            groupCols = [groupCols {groupCol'}];         %#ok<AGROW>
            cArg = cArg + 2;
        end
    end

    if ~isInterval
        groupCols = [groupCols {groupColData}]; %#ok<AGROW>
        cArg = cArg + 1;
    end
end

nWay = length(groupCols);
% on 2Way anova, test for interaction
if isequal(nWay, 2)
    [P, table, stats, terms] = anovan(dataCol, groupCols, 'model', 'interaction');
else
    [P, table, stats, terms] = anovan(dataCol, groupCols);
end

% plot in different figures
for cGroup = 1:nWay
    figure;
    [dummy, dummy, dummy] = multcompare(stats,'dimension', cGroup); %#ok<NASGU> Use dummies so a plot is shown
end