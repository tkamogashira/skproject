function output = KQuestOutput()
% KQuestOutput -- Import results from KQuest
%   output = KQuestOutput()
%
%   This command only works after running a query in KQuest. Select "Output 
%   to disk" in KQuest when running a query.
%
%   output will contain a struct array with the results from the query.

%% Is there any data?
if ~exist('c:\KQuestOutput.xls', 'file')
    error('No output was found from KQuest');
end

%% Read to raw table
[dummy,dummy,rawTable]=XLSREAD('c:\KQuestOutput.xls');
clear dummy;

%% Convert to struct array
for cRow = 2:size(rawTable, 1)
    for cCol = 1:size(rawTable, 2)
        output(cRow-1).(rawTable{1, cCol}) = rawTable{cRow, cCol};
    end
end