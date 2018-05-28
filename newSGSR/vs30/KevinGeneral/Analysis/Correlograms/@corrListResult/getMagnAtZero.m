function magnAtZero = getMagnAtZero(CLR)
% GETMAGNATZERO Gets the magnitudes at zero for the corrListResult instance
%
% magnAtZero = getMagnAtZero(CLR)
% Gets the magnitudes at zero for the corrListResult instance CLR.

listLength = size(CLR.corrFncs, 1);
switch lower(CLR.calcType)
    case {'refrow', 'within'}
        magnAtZero = deal(zeros(listLength, 1));
        for row=1:listLength
            magnAtZero(row) = CLR.corrFncs{row}(CLR.corrLag{row} == 0);
        end
    case {'all', 'deltadiscern'}
        magnAtZero = deal(zeros(listLength, listLength));
        for row = 1:listLength
            for col = 1:listLength
                if isempty(CLR.corrLag{row, col})
                    magnAtZero(row,col) = 0;
                else
                    magnAtZero(row,col) = CLR.corrFncs{row, col}(CLR.corrLag{row, col} == 0);
                end
            end
        end
end