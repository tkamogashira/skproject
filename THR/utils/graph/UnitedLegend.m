function Str = UnitedLegend(X, FormatString);
%  UnitedLegend - cell string describing parameter with its units
%     UnitedLegend(X, FormatString) is a cellstring whose kth element
%     displays X(k) using the format described by FormatString. This
%     cellstring can be readily passed to LEGEND.
%
%     EXAMPLE
%       UnitedLegend(linspace(pi, pi^2,5), '%0.2f kHz')
%     ans = 
%         '3.14 kHz'    '4.82 kHz'    '6.51 kHz'    '8.19 kHz'    '9.87 kHz'
%
%     See also LEGEND, sprintf.

Str = sprintf([FormatString char(3)], X); % append char(3) to each displayed value
Str = words2cell(Str, char(3)); % use char(3) as delimiter







