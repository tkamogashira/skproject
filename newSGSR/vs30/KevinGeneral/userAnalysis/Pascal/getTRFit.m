function TRFit = getTRFit(T)
% GETTRFIT - gets Trading Ration and fit for result of kevCorr
%
% TRFit = getTRFit(T)
% Returns a structure:
%   TRFit.xValues   : difference of SPL with reference row
%   TRFit.yValues   : delay of primary peaks
%   TRFit.slope     : slope of the fit
%   TRFit.polyVal   : values of the fit


% get the values to be fitted
TRFit.xValues = [];
TRFit.yValues = [];
for i = 1:length(T)
    TRFit.xValues = [TRFit.xValues, T(i).ds2.discernvalue - T(i).ds1.discernvalue]; % difference of SPL with reference row
    TRFit.yValues = [TRFit.yValues, 1000 * T(i).primpeak.delay];                    % delay of primary peak, in us
end

% sort
[TRFit.xValues, sortIdx]  = sort(TRFit.xValues);
TRFit.yValues = TRFit.yValues(sortIdx);

% fit
P = polyfit(TRFit.xValues, TRFit.yValues, 1);
TRFit.slope = P(1);
TRFit.polyVal = polyval(P, TRFit.xValues);