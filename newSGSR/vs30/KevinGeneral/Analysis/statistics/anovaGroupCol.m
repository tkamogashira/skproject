function [P, table, stats, terms, dataCol, groupCol] = anovaGroupCol(varargin)
% anovaGroupRow - Evaluate an N-way anova on a structure array
%
%    Use:
%    >> [P, table, stats, terms, dataCol, groupCol] = ...
%          anovaGroupCol(struct S, string columnNameS1, string columnNameS2, ...,
%                        struct T, string columnNameT1, string columnNameT2, ..., 
%                        ... )
%
%    An N-way anova analysis is done, using the indicated columns of the
%    structures as data and the structure and column names as group names.
%    
%    'P', 'table', 'stats' and 'terms' are as returned by 'anovan'. The
%    data users for the anova analysis is returned in dataCol and groupCol.
%    
%    See 'doc anovan' for more information on N-way analyses.

cArg = 1;
dataCol = [];
groupCol = {};

while cArg < nargin
    inStruct = varargin{cArg};
    structName = inputname(cArg);
    if ~isstruct(inStruct)
        error('First argument for anovaGroupCol should be a struct.');
    end

    cArg = cArg + 1;
    while cArg <= nargin
        if ischar(varargin{cArg})
            groupName = varargin{cArg};
            if ~ischar(groupName)
                error('All arguments after the first should be column names.');
            end

            groupData = retrieveField(inStruct, groupName);
            dataCol = [dataCol; groupData];
            groupCol = [groupCol; repmat({[structName '_' groupName]}, length(groupData), 1)];

            cArg = cArg + 1;
        else
            break
        end
    end
end

[P, table, stats, terms] = anovan(dataCol, {groupCol});

% plot
[dummy, dummy, dummy] = multcompare(stats); %#ok<NASGU> Use dummies so a plot is shown