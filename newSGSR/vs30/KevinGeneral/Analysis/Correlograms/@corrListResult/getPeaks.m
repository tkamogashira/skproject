function [primaryPeaks, secondaryPeaks] = getPeaks(CLR, primPeakRange)
% GETPRIMARYPEAKS Gets the peaks of the corrListResult instance
%
% [primaryPeaks, secondaryPeaks] = getPeaks(CLR)
% Returns the  peaks of the corrListResult instance CLR.

if nargin < 2
    primPeakRange = [-inf, inf];
end

listLength = size(CLR.corrFncs, 1);
switch lower(CLR.calcType)
    case {'refrow', 'within'}
        primaryPeaks = deal(zeros(listLength, 2));
        secondaryPeaks = deal(zeros(listLength, 2, 2));
        for row=1:listLength
            [primaryPeaks(row, :), secondaryPeaks(row, :, :)] = localGetPeaks( CLR.corrLag{row}, CLR.corrFncs{row}, primPeakRange );
        end
    case {'all', 'deltadiscern'}
        primaryPeaks = deal(zeros(listLength, listLength, 2));
        secondaryPeaks = deal(zeros(listLength, listLength, 2, 2));
        for row = 1:listLength
            for col = 1:listLength
                if ~isempty(CLR.corrLag{row,col})
                    [primaryPeaks(row, col, :), secondaryPeaks(row, col, :, :)] = localGetPeaks( CLR.corrLag{row,col}, CLR.corrFncs{row,col}, primPeakRange );
                else
                    primaryPeaks(row, col, :) = deal([0 0]);
                    secondaryPeaks(row, col, 1, :) = deal([0 0]);
                    secondaryPeaks(row, col, 2, :) = deal([0 0]);
                end
            end
        end
end

function [primaryPeaks, secondaryPeaks] = localGetPeaks(X, Y, primPeakRange)
[primaryPeaks(1), primaryPeaks(2), secondaryPeaks(1,:), secondaryPeaks(2,:)] = getPeaks(X, Y, 0, NaN, primPeakRange);
secondaryPeaks = secondaryPeaks';

%Make sure this is really the maximum (getpeaks goes wierd if only one
%point in primPeakRange)
%If the "peak" is over the edge of the range, make NaN ...
peakIdx = find(X == primaryPeaks(1));

validPeak = 1;
if ~isequal(1, peakIdx)
    if Y(peakIdx - 1) > primaryPeaks(2)
        validPeak = 0;
    end
end
if ~isequal(length(Y), peakIdx)
    if Y(peakIdx + 1) > primaryPeaks(2)
        validPeak = 0;
    end    
end
if ~(primPeakRange(1) < primaryPeaks(1) & primPeakRange(2) > primaryPeaks(1))
    validPeak = 0;
end

if ~validPeak   
    primaryPeaks(1) = NaN;
    primaryPeaks(2) = NaN;
    secondaryPeaks(1,1) = NaN;
    secondaryPeaks(1,2) = NaN;
    secondaryPeaks(2,1) = NaN;
    secondaryPeaks(2,2) = NaN;
    return;
end